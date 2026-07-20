<#
.SYNOPSIS
    Verify Pek.Skills asset consistency.

.DESCRIPTION
    Scans .github/{instructions,skills,agents,prompts} and the global instruction file,
    then validates:
      1. Required directories and files exist.
      2. Every asset has a valid YAML frontmatter with required fields (name/description).
      3. Each skill folder name matches its `name` field.
      4. Global instructions references to instructions files are valid.
      5. README.md asset tables match disk in BOTH directions:
           - every disk asset is listed in README (no forgotten registration);
           - every README-listed asset exists on disk (no stale/phantom entry).
      6. (Optional) Installed assets count matches source.

    All files are read as UTF-8 (no BOM) via .NET to avoid PowerShell's default GBK
    corruption on Chinese content. The script NEVER modifies any file.

    Exits 1 when any problem is found (CI-friendly), 0 otherwise.

.PARAMETER RepoRoot
    Repository root. Defaults to script parent directory.

.PARAMETER CheckInstalled
    Also verify installed assets in VS Code user data directories.

.EXAMPLE
    .\verify-copilot-assets.ps1
        Run a full consistency check and print a report.

.EXAMPLE
    .\verify-copilot-assets.ps1 -CheckInstalled
        Also verify installed assets in VS Code user prompts dirs.
#>
param(
    [String]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path,
    [switch]$CheckInstalled
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# ── Helpers ───────────────────────────────────────────────────────────────────
function ReadText([String]$Path) {
    return [System.IO.File]::ReadAllText($Path, [System.Text.UTF8Encoding]::new($false))
}

function GetFrontmatter([String]$Text) {
    if ($Text -match '(?s)^\uFEFF?---\s*\r?\n(.*?)\r?\n---') { return $Matches[1] }
    return $null
}

function GetField([String]$Frontmatter, [String]$Key) {
    if ([String]::IsNullOrEmpty($Frontmatter)) { return $null }
    foreach ($line in ($Frontmatter -split '\r?\n')) {
        $trimmed = $line.TrimStart()
        if ($trimmed.StartsWith($Key + ":")) {
            $val = $trimmed.Substring($Key.Length + 1).Trim()
            return $val.Trim('"').Trim("'").Trim()
        }
    }
    return $null
}

function Add-Issue([string]$message) {
    $issues.Add($message)
}

function Assert-Path([string]$path, [string]$label) {
    if (-not (Test-Path $path)) { Add-Issue("Missing ${label}: $path") }
}

$issues = [System.Collections.Generic.List[String]]::new()

$githubDir            = Join-Path $RepoRoot ".github"
$readmePath           = Join-Path $RepoRoot "README.md"
$skillsDir            = Join-Path $githubDir "skills"
$instrDir             = Join-Path $githubDir "instructions"
$agentsDir            = Join-Path $githubDir "agents"
$promptsDir           = Join-Path $githubDir "prompts"
$globalInstructions   = Join-Path $githubDir "copilot-instructions.md"
$installScript        = Join-Path $RepoRoot "scripts\install-copilot-assets.ps1"

# Identifiers a README table cell may legitimately reference.
$diskIds = [System.Collections.Generic.HashSet[String]]::new()
# Identifiers that MUST appear in README (registration check).
$mustList = [System.Collections.Generic.List[String]]::new()

# ── Path existence checks ────────────────────────────────────────────────────
Assert-Path $githubDir ".github directory"
Assert-Path $skillsDir "skills directory"
Assert-Path $instrDir "instructions directory"
Assert-Path $agentsDir "agents directory"
Assert-Path $promptsDir "prompts directory"
Assert-Path $readmePath "README.md"
Assert-Path $globalInstructions "global instructions"
Assert-Path $installScript "install script"

# ── Skills ────────────────────────────────────────────────────────────────────
foreach ($d in (Get-ChildItem -Path $skillsDir -Directory)) {
    [void]$diskIds.Add($d.Name)
    $mustList.Add($d.Name)
    $skillMd = Join-Path $d.FullName "SKILL.md"
    if (-not (Test-Path $skillMd)) { Add-Issue("SKILL.md missing: $($d.Name)"); continue }
    $fm = GetFrontmatter (ReadText $skillMd)
    if ($null -eq $fm) { Add-Issue("Skill missing frontmatter: $($d.Name)"); continue }
    $name = GetField $fm "name"
    $desc = GetField $fm "description"
    if ($null -eq $name) { Add-Issue("Skill missing 'name' field: $($d.Name)") }
    elseif ($name -ne $d.Name) { Add-Issue("Skill name/folder mismatch: folder=$($d.Name) name=$name") }
    if ([String]::IsNullOrWhiteSpace($desc)) { Add-Issue("Skill missing 'description': $($d.Name)") }
}

# ── Instructions ──────────────────────────────────────────────────────────────
foreach ($f in (Get-ChildItem -Path $instrDir -Filter "*.instructions.md")) {
    [void]$diskIds.Add($f.Name)
    $mustList.Add($f.Name)
    $fm = GetFrontmatter (ReadText $f.FullName)
    if ($null -eq $fm) { Add-Issue("Instruction missing frontmatter: $($f.Name)"); continue }
    $desc = GetField $fm "description"
    if ([String]::IsNullOrWhiteSpace($desc)) { Add-Issue("Instruction missing 'description': $($f.Name)") }
}

# ── Agents ────────────────────────────────────────────────────────────────────
foreach ($f in (Get-ChildItem -Path $agentsDir -Filter "*.agent.md")) {
    $shortName = $f.Name -replace '\.agent\.md$', ''
    [void]$diskIds.Add($f.Name)
    [void]$diskIds.Add($shortName)
    $mustList.Add($shortName)
    $fm = GetFrontmatter (ReadText $f.FullName)
    if ($null -eq $fm) { Add-Issue("Agent missing frontmatter: $($f.Name)"); continue }
    $desc = GetField $fm "description"
    if ([String]::IsNullOrWhiteSpace($desc)) { Add-Issue("Agent missing 'description': $($f.Name)") }
}

# ── Prompts ───────────────────────────────────────────────────────────────────
$promptCount = 0
if (Test-Path $promptsDir) {
    foreach ($f in (Get-ChildItem -Path $promptsDir -Filter "*.prompt.md")) {
        $promptCount++
        $shortName = $f.Name -replace '\.prompt\.md$', ''
        [void]$diskIds.Add($f.Name)
        [void]$diskIds.Add($shortName)
        $mustList.Add($f.Name)
        $fm = GetFrontmatter (ReadText $f.FullName)
        if ($null -eq $fm) { Add-Issue("Prompt missing frontmatter: $($f.Name)"); continue }
        $desc = GetField $fm "description"
        if ([String]::IsNullOrWhiteSpace($desc)) { Add-Issue("Prompt missing 'description': $($f.Name)") }
    }
}

# ── Global instructions reference check ──────────────────────────────────────
if (Test-Path $globalInstructions) {
    $content = ReadText $globalInstructions
    foreach ($m in [regex]::Matches($content, '[A-Za-z0-9_-]+\.instructions\.md')) {
        $fileName = $m.Value
        $candidate = Join-Path $instrDir $fileName
        if (-not (Test-Path $candidate)) {
            Add-Issue("Global instructions reference missing file: $fileName")
        }
    }
}

# ── README cross-check ───────────────────────────────────────────────────────
$readme = ReadText $readmePath
$readmeNames = [System.Collections.Generic.List[String]]::new()
# Table rows whose first cell is a single backticked identifier: | `name` | ... |
foreach ($m in [regex]::Matches($readme, '(?m)^\|\s*`([^`]+)`\s*\|')) {
    [void]$readmeNames.Add($m.Groups[1].Value)
}

foreach ($id in $mustList) {
    if ($readmeNames -notcontains $id) { Add-Issue("Disk asset not listed in README: $id") }
}
foreach ($n in $readmeNames) {
    if (-not $diskIds.Contains($n)) { Add-Issue("README lists non-existent asset: $n") }
}

# ── Report ────────────────────────────────────────────────────────────────────
$skillCount = (Get-ChildItem -Path $skillsDir -Directory).Count
$instrCount = (Get-ChildItem -Path $instrDir -Filter "*.instructions.md").Count
$agentCount = (Get-ChildItem -Path $agentsDir -Filter "*.agent.md").Count

Write-Output ""
Write-Output "Pek.Skills asset verification"
Write-Output ("  skills={0}  instructions={1}  agents={2}  prompts={3}" -f $skillCount, $instrCount, $agentCount, $promptCount)

if ($CheckInstalled) {
    $installedRoots = @(
        @{ Name = "VS Code"; Root = (Join-Path $env:APPDATA "Code\User\prompts") },
        @{ Name = "VS Code Insiders"; Root = (Join-Path $env:APPDATA "Code - Insiders\User\prompts") }
    )
    $officialSkillsPath = Join-Path "$env:USERPROFILE\.copilot" "skills"

    if (Test-Path $officialSkillsPath) {
        $officialCount = (Get-ChildItem -Path $officialSkillsPath -Directory).Count
        Write-Output ("  official_skills={0}" -f $officialCount)
    } else {
        Write-Output "  official_skills=0 (path not found)"
    }

    foreach ($installed in $installedRoots) {
        $installedName = $installed.Name
        $installedRoot = $installed.Root
        $installedSkillsDir = Join-Path $installedRoot "skills"
        $installedGlobal = Join-Path $installedRoot "peikesmart-global.instructions.md"

        if (-not (Test-Path $installedRoot)) {
            Add-Issue("Installed prompts root not found ({0}): {1}" -f $installedName, $installedRoot)
            continue
        }

        $installedSkillCount = if (Test-Path $installedSkillsDir) { (Get-ChildItem -Path $installedSkillsDir -Directory).Count } else { 0 }
        $installedInstrCount = if (Test-Path $installedRoot) { (Get-ChildItem -Path $installedRoot -Filter "*.instructions.md").Count } else { 0 }
        $installedAgentCount = if (Test-Path $installedRoot) { (Get-ChildItem -Path $installedRoot -Filter "*.agent.md").Count } else { 0 }
        $installedPromptCount = if (Test-Path $installedRoot) { (Get-ChildItem -Path $installedRoot -Filter "*.prompt.md").Count } else { 0 }

        Write-Output ("  installed ({0}): skills={1} instr={2} agents={3} prompts={4}" -f $installedName, $installedSkillCount, $installedInstrCount, $installedAgentCount, $installedPromptCount)

        if ($installedSkillCount -lt $skillCount) {
            Add-Issue("Installed skills less than source ({0}): {1} vs {2}" -f $installedName, $installedSkillCount, $skillCount)
        }
        # Expected: instructions + 1 global file
        if ($installedInstrCount -lt ($instrCount + 1)) {
            Add-Issue("Installed instructions less than expected ({0}): {1} vs expected {2}" -f $installedName, $installedInstrCount, ($instrCount + 1))
        }
        if ($installedAgentCount -lt $agentCount) {
            Add-Issue("Installed agents less than source ({0}): {1} vs {2}" -f $installedName, $installedAgentCount, $agentCount)
        }
        if ($installedPromptCount -lt $promptCount) {
            Add-Issue("Installed prompts less than source ({0}): {1} vs {2}" -f $installedName, $installedPromptCount, $promptCount)
        }
    }
}

if ($issues.Count -eq 0) {
    Write-Output "  OK: all assets consistent." -ForegroundColor Green
    exit 0
}

Write-Output ("  {0} problem(s) found:" -f $issues.Count) -ForegroundColor Yellow
foreach ($p in $issues) { Write-Output "    - $p" -ForegroundColor Yellow }
exit 1