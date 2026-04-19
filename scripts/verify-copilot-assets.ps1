<#
.SYNOPSIS
    校验 Pek.Skills 运行时资产完整性。

.DESCRIPTION
    检查 Copilot 运行时核心资产是否齐全：
    - 必要目录与文件是否存在
    - Skills 是否均满足 <name>/SKILL.md 结构
    - 主指令中引用的 instructions 是否存在
    - README 中列出的 instructions / agents / prompts 是否存在

    若发现缺口则以非 0 退出码结束，便于发版前快速自检。

.EXAMPLE
    .\verify-copilot-assets.ps1
#>
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
)

$ErrorActionPreference = "Stop"

$issues = [System.Collections.Generic.List[string]]::new()

function Add-Issue([string]$message) {
    $issues.Add($message)
}

function Assert-Path([string]$path, [string]$label) {
    if (-not (Test-Path $path)) { Add-Issue("缺少${label}: $path") }
}

$githubDir = Join-Path $RepoRoot ".github"
$skillsDir = Join-Path $githubDir "skills"
$instructionsDir = Join-Path $githubDir "instructions"
$agentsDir = Join-Path $githubDir "agents"
$promptsDir = Join-Path $githubDir "prompts"
$readme = Join-Path $RepoRoot "README.md"
$globalInstructions = Join-Path $githubDir "copilot-instructions.md"
$installScript = Join-Path $RepoRoot "scripts\install-copilot-assets.ps1"
$compatScript = Join-Path $RepoRoot "scripts\sync-skills-to-user.ps1"

Assert-Path $githubDir ".github 目录"
Assert-Path $skillsDir "skills 目录"
Assert-Path $instructionsDir "instructions 目录"
Assert-Path $agentsDir "agents 目录"
Assert-Path $promptsDir "prompts 目录"
Assert-Path $readme "README.md"
Assert-Path $globalInstructions "全局协作指令"
Assert-Path $installScript "主安装脚本"
Assert-Path $compatScript "兼容安装脚本"

if (Test-Path $skillsDir) {
    foreach ($folder in (Get-ChildItem -Path $skillsDir -Directory)) {
        $skillFile = Join-Path $folder.FullName "SKILL.md"
        if (-not (Test-Path $skillFile)) {
            Add-Issue("技能目录缺少 SKILL.md: $($folder.FullName)")
        }
    }
}

if (Test-Path $globalInstructions) {
    $content = Get-Content -Path $globalInstructions -Raw -Encoding UTF8
    $matches = [regex]::Matches($content, '[A-Za-z0-9_-]+\.instructions\.md')
    foreach ($match in $matches) {
        $fileName = $match.Value
        $candidate = Join-Path $instructionsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("主指令引用了不存在的 instructions 文件: $fileName")
        }
    }
}

if (Test-Path $readme) {
    $content = Get-Content -Path $readme -Raw -Encoding UTF8

    foreach ($match in [regex]::Matches($content, '[A-Za-z0-9_-]+\.instructions\.md')) {
        $fileName = $match.Value
        $candidate = Join-Path $instructionsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("README 引用了不存在的 instructions 文件: $fileName")
        }
    }

    foreach ($match in [regex]::Matches($content, '[A-Za-z0-9_-]+\.agent\.md')) {
        $fileName = $match.Value
        $candidate = Join-Path $agentsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("README 引用了不存在的 agent 文件: $fileName")
        }
    }

    foreach ($match in [regex]::Matches($content, '[A-Za-z0-9_-]+\.prompt\.md')) {
        $fileName = $match.Value
        $candidate = Join-Path $promptsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("README 引用了不存在的 prompt 文件: $fileName")
        }
    }
}

$skillCount = if (Test-Path $skillsDir) { (Get-ChildItem -Path $skillsDir -Directory | Measure-Object).Count } else { 0 }
$instructionCount = if (Test-Path $instructionsDir) { (Get-ChildItem -Path $instructionsDir -File -Filter *.instructions.md | Measure-Object).Count } else { 0 }
$agentCount = if (Test-Path $agentsDir) { (Get-ChildItem -Path $agentsDir -File -Filter *.agent.md | Measure-Object).Count } else { 0 }
$promptCount = if (Test-Path $promptsDir) { (Get-ChildItem -Path $promptsDir -File -Filter *.prompt.md | Measure-Object).Count } else { 0 }

Write-Host "Pek.Skills 资产统计:" -ForegroundColor Cyan
Write-Host "  Skills       : $skillCount"
Write-Host "  Instructions : $instructionCount"
Write-Host "  Agents       : $agentCount"
Write-Host "  Prompts      : $promptCount"

if ($issues.Count -gt 0) {
    Write-Host "`n发现以下问题:" -ForegroundColor Red
    foreach ($issue in $issues) {
        Write-Host "  - $issue" -ForegroundColor Red
    }
    exit 1
}

Write-Host "`n运行时核心资产校验通过。" -ForegroundColor Green