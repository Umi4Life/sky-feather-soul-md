# Install Sky Feather V3.2 on Hermes Agent (~/.hermes/SOUL.md + skills).
param(
    [switch]$Legacy,
    [string]$RepoRoot = ''
)

. (Join-Path $PSScriptRoot 'lib\common.ps1')

if (-not $RepoRoot) {
    $RepoRoot = Get-SfRepoRoot
} else {
    $RepoRoot = (Resolve-Path $RepoRoot).Path
}

$hermesHome = Get-SfHermesHome
$mirror = Get-SfHermesMirror
$soulPath = Get-SfHermesSoulPath
$config = Get-SfCharactersConfig
$defaultChar = $config.default

Write-Host 'Installing Sky Feather on Hermes'
Write-Host "  Repo:        $RepoRoot"
Write-Host "  HERMES_HOME: $hermesHome"
Write-Host "  Mode:        $(if ($Legacy) { 'legacy SOUL.md' } else { 'V3.2 CORE + character' })"

Backup-SfHermesSoul

if ($Legacy) {
    Copy-Item (Join-Path $RepoRoot 'SOUL.md') $soulPath -Force
    Write-Host ''
    Write-Host "Installed legacy SOUL.md -> $soulPath"
    Write-Host 'Restart Hermes to reload identity.'
    exit 0
}

New-Item -ItemType Directory -Force -Path $mirror | Out-Null

foreach ($item in @('CORE.md', 'SOUL.md', 'characters', 'skills', 'examples')) {
    $src = Join-Path $RepoRoot $item
    if (Test-Path $src) {
        $dest = Join-Path $mirror $item
        if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
        Copy-Item $src $dest -Recurse -Force
    }
}

$scriptsLib = Join-Path $mirror 'scripts-lib'
New-Item -ItemType Directory -Force -Path $scriptsLib | Out-Null
Copy-Item (Join-Path $PSScriptRoot 'lib\characters.json') (Join-Path $scriptsLib 'characters.json') -Force
Copy-Item (Join-Path $PSScriptRoot 'lib\hermes-paths.json') (Join-Path $scriptsLib 'hermes-paths.json') -Force

$activeChar = $defaultChar
$manifestPath = Join-Path $mirror 'manifest.json'
if (Test-Path $manifestPath) {
    $existing = (Get-Content $manifestPath -Raw | ConvertFrom-Json).active
    if ($existing) { $activeChar = $existing }
}

Build-SfHermesSoulFile -RepoRoot $RepoRoot -OutputPath $soulPath -CharacterId $activeChar
Copy-Item $soulPath (Join-Path $mirror 'active-soul.md') -Force
Write-SfHermesManifest -MirrorDir $mirror -ActiveId $activeChar
Write-SfHermesPersonalitiesExample -RepoRoot $RepoRoot -MirrorDir $mirror

Write-Host ''
Write-Host "Syncing skills -> $(Get-SfHermesSkillsDir)/"
Sync-SfHermesSkills -RepoRoot $RepoRoot

Write-Host ''
Write-Host 'Installed:'
Write-Host "  $soulPath"
Write-Host "  $mirror/"
Write-Host "  $(Get-SfHermesSkillsDir)/"

Write-SfHermesNextSteps -ActiveChar $activeChar
