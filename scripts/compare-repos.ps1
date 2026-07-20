$nlDir = "G:\GitHub\NewLife.Skills\.github"
$pekDir = "G:\Code\Pek.FrameWork\Pek.Skills\.github"

function Get-SkillNames($dir) {
    $result = @()
    Get-ChildItem (Join-Path $dir "skills") -Directory | ForEach-Object {
        if ($_.Name -ne 'design-md') { $result += $_.Name }
    }
    return $result
}

function Get-FileNames($dir, $filter) {
    $result = @()
    if (Test-Path $dir) {
        Get-ChildItem $dir -Filter $filter -File | ForEach-Object { $result += $_.Name }
    }
    return $result
}

# Skills
$nlSkills = Get-SkillNames $nlDir
$pekSkills = Get-SkillNames $pekDir

Write-Host "=== Skills: NL 有 / Pek 无 ==="
$nlOnly = $nlSkills | Where-Object { $_ -notin $pekSkills }
if ($nlOnly.Count -eq 0) { Write-Host "  (无)" } else { $nlOnly | ForEach-Object { Write-Host "  $_" } }

Write-Host "`n=== Skills: Pek 有 / NL 无 (共 $($pekSkills.Count) 个) ==="
$pekOnly = $pekSkills | Where-Object { $_ -notin $nlSkills }
Write-Host "  前20个:"
$pekOnly | Select-Object -First 20 | ForEach-Object { Write-Host "  $_" }
if ($pekOnly.Count -gt 20) { Write-Host "  ... 还有 $($pekOnly.Count - 20) 个" }

# Instructions
$nlInstr = Get-FileNames (Join-Path $nlDir "instructions") "*.instructions.md"
$pekInstr = Get-FileNames (Join-Path $pekDir "instructions") "*.instructions.md"
Write-Host "`n=== Instructions: NL=$($nlInstr.Count) Pek=$($pekInstr.Count) ==="
Write-Host "NL:"; $nlInstr | ForEach-Object { Write-Host "  $_" }
Write-Host "Pek:"; $pekInstr | ForEach-Object { Write-Host "  $_" }

# Agents
$nlAgents = Get-FileNames (Join-Path $nlDir "agents") "*.agent.md"
$pekAgents = Get-FileNames (Join-Path $pekDir "agents") "*.agent.md"
Write-Host "`n=== Agents: NL=$($nlAgents.Count) Pek=$($pekAgents.Count) ==="
Write-Host "NL:"; $nlAgents | ForEach-Object { Write-Host "  $_" }
Write-Host "NL 有 Pek 无:"; $nlAgents | Where-Object { $_ -notin $pekAgents } | ForEach-Object { Write-Host "  $_" }

# Prompts
$nlPrompts = Get-FileNames (Join-Path $nlDir "prompts") "*.prompt.md"
$pekPrompts = Get-FileNames (Join-Path $pekDir "prompts") "*.prompt.md"
Write-Host "`n=== Prompts: NL=$($nlPrompts.Count) Pek=$($pekPrompts.Count) ==="

# Docs
$nlDocs = Get-FileNames (Join-Path $nlDir "..\docs") "*.*"
$pekDocs = Get-FileNames (Join-Path $pekDir "..\docs") "*.*"
Write-Host "`n=== Docs: NL=$($nlDocs.Count) Pek=$($pekDocs.Count) ==="

# Global instructions
Write-Host "`n=== 全局指令 ==="
if (Test-Path (Join-Path $nlDir "copilot-instructions.md")) { Write-Host "NL: 有" }
if (Test-Path (Join-Path $pekDir "copilot-instructions.md")) { Write-Host "Pek: 有" }

# Scripts
Write-Host "`n=== Scripts ==="
$nlScripts = Get-FileNames (Join-Path $nlDir "..\scripts") "*.ps1"
$pekScripts = Get-FileNames (Join-Path $pekDir "..\scripts") "*.ps1"
Write-Host "NL:"; $nlScripts | ForEach-Object { Write-Host "  $_" }
Write-Host "Pek:"; $pekScripts | ForEach-Object { Write-Host "  $_" }

Remove-Item $PSCommandPath -Force
