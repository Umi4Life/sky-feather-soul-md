# Build flat character bundles into a target directory.
param(
    [string]$OutputDir
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\common.ps1')

$repoRoot = Get-SfRepoRoot
if (-not $OutputDir) {
    $OutputDir = Join-Path (Get-SfSkyFeatherMirror) 'bundles'
}

Write-Host "Building bundles from: $repoRoot"
Write-Host "Output directory: $OutputDir"

Build-SfAllBundles -RepoRoot $repoRoot -OutputDir $OutputDir

$config = Get-SfCharactersConfig
Write-Host 'Built bundles:'
foreach ($char in $config.characters) {
    Write-Host "  $(Join-Path $OutputDir "$($char.id).md")"
}
