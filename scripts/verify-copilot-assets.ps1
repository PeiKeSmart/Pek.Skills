<#
.SYNOPSIS
    校验 Pek.Skills 运行时资产完整性。

.DESCRIPTION
    检查 Copilot 运行时核心资产是否齐全：
    - 必要目录与文件是否存在
    - Skills 是否均满足 <name>/SKILL.md 结构
    - 主指令中引用的 instructions 是否存在
    - README 中列出的 instructions / agents / prompts 是否存在

    说明：运行时输出统一使用 ASCII / English 文案，避免不同 PowerShell 宿主
    对中文输出、编码和字符串解析的兼容性差异。

    若发现缺口则以非 0 退出码结束，便于发版前快速自检。

.EXAMPLE
    .\verify-copilot-assets.ps1
#>
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$CheckInstalled
)

$ErrorActionPreference = "Stop"

$issues = [System.Collections.Generic.List[string]]::new()

function Add-Issue([string]$message) {
    $issues.Add($message)
}

function Assert-Path([string]$path, [string]$label) {
    if (-not (Test-Path $path)) { Add-Issue("Missing ${label}: $path") }
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
$installedRoots = @(
    [PSCustomObject]@{ Name = "VS Code"; Root = (Join-Path $env:APPDATA "Code\User\prompts") },
    [PSCustomObject]@{ Name = "VS Code Insiders"; Root = (Join-Path $env:APPDATA "Code - Insiders\User\prompts") }
)

Assert-Path $githubDir ".github directory"
Assert-Path $skillsDir "skills directory"
Assert-Path $instructionsDir "instructions directory"
Assert-Path $agentsDir "agents directory"
Assert-Path $promptsDir "prompts directory"
Assert-Path $readme "README.md"
Assert-Path $globalInstructions "global instructions"
Assert-Path $installScript "main install script"
Assert-Path $compatScript "compat install script"

if (Test-Path $skillsDir) {
    foreach ($folder in (Get-ChildItem -Path $skillsDir -Directory)) {
        $skillFile = Join-Path $folder.FullName "SKILL.md"
        if (-not (Test-Path $skillFile)) {
            Add-Issue("Missing SKILL.md in skill directory: $($folder.FullName)")
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
            Add-Issue("Global instructions reference missing instructions file: $fileName")
        }
    }
}

if (Test-Path $readme) {
    $content = Get-Content -Path $readme -Raw -Encoding UTF8

    foreach ($match in [regex]::Matches($content, '[A-Za-z0-9_-]+\.instructions\.md')) {
        $fileName = $match.Value
        if ($fileName -eq 'peikesmart-global.instructions.md') { continue }
        $candidate = Join-Path $instructionsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("README references missing instructions file: $fileName")
        }
    }

    foreach ($match in [regex]::Matches($content, '[A-Za-z0-9_-]+\.agent\.md')) {
        $fileName = $match.Value
        $candidate = Join-Path $agentsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("README references missing agent file: $fileName")
        }
    }

    foreach ($match in [regex]::Matches($content, '[A-Za-z0-9_-]+\.prompt\.md')) {
        $fileName = $match.Value
        $candidate = Join-Path $promptsDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("README references missing prompt file: $fileName")
        }
    }
}

$skillCount = if (Test-Path $skillsDir) { (Get-ChildItem -Path $skillsDir -Directory | Measure-Object).Count } else { 0 }
$instructionCount = if (Test-Path $instructionsDir) { (Get-ChildItem -Path $instructionsDir -File -Filter *.instructions.md | Measure-Object).Count } else { 0 }
$agentCount = if (Test-Path $agentsDir) { (Get-ChildItem -Path $agentsDir -File -Filter *.agent.md | Measure-Object).Count } else { 0 }
$promptCount = if (Test-Path $promptsDir) { (Get-ChildItem -Path $promptsDir -File -Filter *.prompt.md | Measure-Object).Count } else { 0 }

Write-Output "Pek.Skills source asset summary:"
Write-Output "  Skills       : $skillCount"
Write-Output "  Instructions : $instructionCount"
Write-Output "  Agents       : $agentCount"
Write-Output "  Prompts      : $promptCount"

if ($CheckInstalled) {
    foreach ($installed in $installedRoots) {
        $installedName = $installed.Name
        $installedRoot = $installed.Root
        $installedSkillsDir = Join-Path $installedRoot "skills"
        $installedGlobalInstructions = Join-Path $installedRoot "peikesmart-global.instructions.md"

        Assert-Path $installedRoot ("Installed prompts root ({0})" -f $installedName)
        Assert-Path $installedSkillsDir ("Installed skills dir ({0})" -f $installedName)
        Assert-Path $installedGlobalInstructions ("Installed global instructions ({0})" -f $installedName)

        $installedSkillCount = if (Test-Path $installedSkillsDir) { (Get-ChildItem -Path $installedSkillsDir -Directory | Measure-Object).Count } else { 0 }
        $installedInstructionCount = if (Test-Path $installedRoot) { (Get-ChildItem -Path $installedRoot -File -Filter *.instructions.md | Measure-Object).Count } else { 0 }
        $installedAgentCount = if (Test-Path $installedRoot) { (Get-ChildItem -Path $installedRoot -File -Filter *.agent.md | Measure-Object).Count } else { 0 }
        $installedPromptCount = if (Test-Path $installedRoot) { (Get-ChildItem -Path $installedRoot -File -Filter *.prompt.md | Measure-Object).Count } else { 0 }

        Write-Output ("Installed asset summary ({0}):" -f $installedName)
        Write-Output "  Skills       : $installedSkillCount"
        Write-Output "  Instructions : $installedInstructionCount"
        Write-Output "  Agents       : $installedAgentCount"
        Write-Output "  Prompts      : $installedPromptCount"

        if ($installedSkillCount -lt $skillCount) {
            Add-Issue(("Installed skills less than source ({0}): {1} / {2}" -f $installedName, $installedSkillCount, $skillCount))
        }
        if ($installedInstructionCount -lt ($instructionCount + 1)) {
            Add-Issue(("Installed instructions less than expected with global file ({0}): {1} / {2}" -f $installedName, $installedInstructionCount, ($instructionCount + 1)))
        }
        if ($installedAgentCount -lt $agentCount) {
            Add-Issue(("Installed agents less than source ({0}): {1} / {2}" -f $installedName, $installedAgentCount, $agentCount))
        }
        if ($installedPromptCount -lt $promptCount) {
            Add-Issue(("Installed prompts less than source ({0}): {1} / {2}" -f $installedName, $installedPromptCount, $promptCount))
        }

        Write-Output ""
    }
}

if ($issues.Count -gt 0) {
    Write-Output ""
    Write-Output "Issues found:"
    foreach ($issue in $issues) {
        Write-Output "  - $issue"
    }
    exit 1
}

Write-Output ""
Write-Output "Runtime core asset validation passed."
exit 0