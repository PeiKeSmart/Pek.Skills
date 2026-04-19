<#
.SYNOPSIS
    兼容旧脚本名称，转调 install-copilot-assets.ps1。

.DESCRIPTION
    某些历史文档或个人习惯可能仍使用 sync-skills-to-user.ps1。
    本脚本作为兼容包装器保留，内部直接调用 install-copilot-assets.ps1。

.PARAMETER RepoRoot
    仓库根目录，透传给 install-copilot-assets.ps1。

.PARAMETER Clean
    安装前清空对应目标目录，透传给 install-copilot-assets.ps1。

.EXAMPLE
    .\sync-skills-to-user.ps1

.EXAMPLE
    .\sync-skills-to-user.ps1 -Clean
#>
param(
    [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$Clean
)

$script = Join-Path $PSScriptRoot "install-copilot-assets.ps1"
if (-not (Test-Path $script)) {
    throw "未找到安装脚本: $script"
}

& $script -RepoRoot $RepoRoot -Clean:$Clean