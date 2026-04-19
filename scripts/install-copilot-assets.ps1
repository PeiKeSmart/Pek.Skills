<#
.SYNOPSIS
    安装 PeikeSmart Copilot 资产到 VSCode 用户数据目录，使其对本机所有项目生效。

.DESCRIPTION
        将 .github/ 下的 skills/instructions/prompts/agents 安装到 VSCode 用户数据目录：
            Skills        → %APPDATA%\Code\User\prompts\skills\ 以及 %APPDATA%\Code - Insiders\User\prompts\skills\
            Instructions  → %APPDATA%\Code\User\prompts\ 以及 %APPDATA%\Code - Insiders\User\prompts\
            Prompts       → %APPDATA%\Code\User\prompts\ 以及 %APPDATA%\Code - Insiders\User\prompts\
            Agents        → 对应 prompts 目录下（*.agent.md，与 instructions 同目录)

    安装后无需在每个项目都放 .github 目录，Copilot 即可使用全部资产。

    支持平台：Win10 / Win11 + VS Code + GitHub Copilot Chat

.PARAMETER RepoRoot
    仓库根目录，默认为脚本目录的父目录。

.PARAMETER Clean
    安装前清空对应目标目录（慎用，会删除其他来源的同名文件）。

.EXAMPLE
    .\install-copilot-assets.ps1
    .\install-copilot-assets.ps1 -Clean
#>
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$Clean
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

$githubDir = Join-Path $RepoRoot ".github"
$userDataDirs = @(
    (Join-Path $env:APPDATA "Code\User"),
    (Join-Path $env:APPDATA "Code - Insiders\User")
) | Select-Object -Unique

# ── Source ────────────────────────────────────────────────────────────────────
$skillsSrc      = Join-Path $githubDir "skills"
$instructionsSrc = Join-Path $githubDir "instructions"
$promptsSrc     = Join-Path $githubDir "prompts"
$agentsSrc      = Join-Path $githubDir "agents"
$globalInstrSrc = Join-Path $githubDir "copilot-instructions.md"

# ── Helpers ───────────────────────────────────────────────────────────────────
function EnsureDir ([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
}

function WriteStep ([string]$Msg) {
    Write-Host "    $Msg" -ForegroundColor DarkCyan
}

# ── Banner ────────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "=== PeikeSmart Copilot 资产安装 ===" -ForegroundColor Green
Write-Host "  仓库: $RepoRoot"
Write-Host "  目标:"
foreach ($dir in $userDataDirs) {
    Write-Host "    $dir"
}
Write-Host ""

if (-not (Test-Path $githubDir)) {
    Write-Error "未找到 .github 目录: $githubDir"
    exit 1
}

$installed = 0

foreach ($userDataDir in $userDataDirs) {
    $skillsDst = Join-Path $userDataDir "prompts\skills"
    $promptsDst = Join-Path $userDataDir "prompts"
    $agentsDst = $promptsDst

    Write-Host ">>> 安装到: $userDataDir" -ForegroundColor Cyan

    # ─── 1. Skills ────────────────────────────────────────────────────────────
    # 所有 Skills 均为 <name>/SKILL.md 文件夹格式 → prompts\skills\<name>\
    Write-Host "[1/5] Skills" -ForegroundColor Yellow
    EnsureDir $skillsDst
    EnsureDir $promptsDst

    if (Test-Path $skillsSrc) {
        $folders = Get-ChildItem -Path $skillsSrc -Directory
        foreach ($folder in $folders) {
            $dst = Join-Path $skillsDst $folder.Name
            if ($Clean -and (Test-Path $dst)) { Remove-Item -Path $dst -Recurse -Force }
            EnsureDir $dst
            Copy-Item -Path (Join-Path $folder.FullName "*") -Destination $dst -Recurse -Force
            WriteStep "skill: $($folder.Name)"
            $installed++
        }
    } else {
        Write-Host "    （跳过：$skillsSrc 不存在）" -ForegroundColor DarkGray
    }

    # ─── 2. Instructions ──────────────────────────────────────────────────────
    Write-Host "[2/5] Instructions" -ForegroundColor Yellow

    if (Test-Path $instructionsSrc) {
        $files = Get-ChildItem -Path $instructionsSrc -Filter "*.instructions.md" -File
        if ($Clean) {
            Get-ChildItem -Path $promptsDst -Filter "*.instructions.md" -File -ErrorAction SilentlyContinue | Remove-Item -Force
        }
        foreach ($f in $files) {
            Copy-Item -Path $f.FullName -Destination $promptsDst -Force
            WriteStep "$($f.Name)"
            $installed++
        }
    } else {
        Write-Host "    （跳过：$instructionsSrc 不存在）" -ForegroundColor DarkGray
    }

    # ─── 3. Prompts ───────────────────────────────────────────────────────────
    Write-Host "[3/5] Prompts" -ForegroundColor Yellow

    if (Test-Path $promptsSrc) {
        $files = Get-ChildItem -Path $promptsSrc -Filter "*.prompt.md" -File
        foreach ($f in $files) {
            Copy-Item -Path $f.FullName -Destination $promptsDst -Force
            WriteStep "$($f.Name)"
            $installed++
        }
    } else {
        Write-Host "    （跳过：$promptsSrc 不存在）" -ForegroundColor DarkGray
    }

    # ─── 4. Agents ────────────────────────────────────────────────────────────
    Write-Host "[4/5] Agents" -ForegroundColor Yellow

    if (Test-Path $agentsSrc) {
        if ($Clean) {
            Get-ChildItem -Path $agentsDst -Filter "*.agent.md" -File -ErrorAction SilentlyContinue | Remove-Item -Force
        }
        $files = Get-ChildItem -Path $agentsSrc -Filter "*.agent.md" -File
        foreach ($f in $files) {
            Copy-Item -Path $f.FullName -Destination $agentsDst -Force
            WriteStep "$($f.Name)"
            $installed++
        }
    } else {
        Write-Host "    （跳过：$agentsSrc 不存在）" -ForegroundColor DarkGray
    }

    # ─── 5. 全局 Copilot 指令 ─────────────────────────────────────────────────
    Write-Host "[5/5] 全局 Copilot 指令" -ForegroundColor Yellow

    if (Test-Path $globalInstrSrc) {
        $content = Get-Content -Path $globalInstrSrc -Raw -Encoding UTF8
        $wrapped = "---`napplyTo: `"**`"`n---`n" + $content
        $legacyFile = Join-Path $promptsDst "newlife-global.instructions.md"
        if (Test-Path $legacyFile) { Remove-Item -Path $legacyFile -Force }
        $dstFile = Join-Path $promptsDst "peikesmart-global.instructions.md"
        [System.IO.File]::WriteAllText($dstFile, $wrapped, [System.Text.UTF8Encoding]::new($false))
        WriteStep "peikesmart-global.instructions.md"
        $installed++
    } else {
        Write-Host "    （跳过：$globalInstrSrc 不存在）" -ForegroundColor DarkGray
    }

    Write-Host ""
}

# ─── 完成 ─────────────────────────────────────────────────────────────────────
Write-Host ""
$msg = "=== 安装完成，共 $installed 项 ==="
Write-Host $msg -ForegroundColor Green
Write-Host ""
$dstInfo = "Install Paths:"
Write-Host $dstInfo
foreach ($userDataDir in $userDataDirs) {
    $promptsDst = Join-Path $userDataDir "prompts"
    $skillsDst = Join-Path $userDataDir "prompts\skills"
    Write-Host "  Target      : $userDataDir"
    Write-Host "    Skills      : $skillsDst"
    Write-Host "    Instructions: $promptsDst  *.instructions.md"
    Write-Host "    Prompts     : $promptsDst  *.prompt.md"
    Write-Host "    Agents      : $promptsDst  *.agent.md"
}
Write-Host ""
$hint = "重启 VS Code 后即可在所有项目中使用以上资产。"
Write-Host $hint
Write-Host ""
