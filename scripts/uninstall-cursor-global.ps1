# Uninstall / prune Sky Feather global Cursor artifacts.
param(
    [switch]$All,
    [switch]$Legacy,
    [switch]$V3,
    [switch]$DryRun,
    [string]$RepoRules
)

$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot 'lib\common.ps1')

$mode = 'all'
if ($Legacy) { $mode = 'legacy' }
elseif ($V3) { $mode = 'v3' }
elseif ($All) { $mode = 'all' }

function Remove-SfPath {
    param([string]$Path)
    if (Test-Path $Path) {
        if ($DryRun) {
            Write-Host "would remove: $Path"
        } else {
            Remove-Item $Path -Recurse -Force
            Write-Host "removed: $Path"
        }
    }
}

$cursorHome = Get-SfCursorHome

if ($mode -eq 'all' -or $mode -eq 'legacy') {
    Remove-SfPath (Get-SfLegacySkillDir)
    Remove-SfPath (Join-Path $cursorHome 'sky-feather\sky-feather-soul.mdc')
}

if ($mode -eq 'all' -or $mode -eq 'v3') {
    Remove-SfPath (Get-SfSkyFeatherMirror)
    Remove-SfPath (Get-SfSkillCharacterDir)
    Remove-SfPath (Join-Path (Get-SfCommandsDir) 'character.md')
}

if ($RepoRules) {
    if (-not (Test-Path $RepoRules -PathType Container)) {
        throw "not a directory: $RepoRules"
    }
    Get-ChildItem -Path $RepoRules -Recurse -Filter 'sky-feather-soul.mdc' -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -match '[\\/]\.cursor[\\/]rules[\\/]sky-feather-soul\.mdc$' } |
        ForEach-Object { Remove-SfPath $_.FullName }
}

Write-Host ''
if ($DryRun) {
    Write-Host 'Dry run complete. No files deleted.'
} else {
    Write-Host "Uninstall complete ($mode)."
}

Write-Host @'

Manual step: remove Sky Feather content from Cursor User Rules
  Settings -> Rules -> User Rules
  Delete the SOUL.md block or thin sky-feather-character stub.
  Start a new chat.

Never removed automatically:
  ~/.cursor/skills-cursor/ (Cursor internal built-ins)
'@
