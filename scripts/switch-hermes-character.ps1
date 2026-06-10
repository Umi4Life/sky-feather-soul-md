# Switch active Sky Feather character on Hermes (~/.hermes/SOUL.md).
param(
    [Parameter(Mandatory)][string]$Character,
    [switch]$PresetOnly,
    [string]$RepoRoot = ''
)

. (Join-Path $PSScriptRoot 'lib\common.ps1')

if (-not $RepoRoot) {
    $RepoRoot = Get-SfRepoRoot
} else {
    $RepoRoot = (Resolve-Path $RepoRoot).Path
}

$charId = Resolve-SfCharacterId -CharacterInput $Character
$mirror = Get-SfHermesMirror
$soulPath = Get-SfHermesSoulPath

if (-not (Test-Path $mirror)) {
    throw "Hermes mirror not found at $mirror. Run install-hermes-global.ps1 first."
}

if ($PresetOnly) {
    $presetDir = Join-Path $mirror 'presets'
    New-Item -ItemType Directory -Force -Path $presetDir | Out-Null
    $presetPath = Join-Path $presetDir "$charId.md"
    Build-SfHermesSoulFile -RepoRoot $RepoRoot -OutputPath $presetPath -CharacterId $charId
    Write-Host "Wrote preset body -> $presetPath"
    exit 0
}

Build-SfHermesSoulFile -RepoRoot $RepoRoot -OutputPath $soulPath -CharacterId $charId
Copy-Item $soulPath (Join-Path $mirror 'active-soul.md') -Force
Write-SfHermesManifest -MirrorDir $mirror -ActiveId $charId

$label = Get-SfHermesDiscordLabel -CharacterId $charId
Write-Host "Active character: $charId ($label)"
Write-Host "Updated: $soulPath"
Write-Host 'Restart Hermes or start a new session for reliable application.'
