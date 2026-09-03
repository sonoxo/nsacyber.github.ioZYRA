[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$version = [string]$catalog.version
if ([string]::IsNullOrWhiteSpace($version)) { Write-Error 'version is missing'; exit 1 }
if ($version -notmatch '^\d+\.\d+$') { Write-Warning "unexpected version format '$version'"; exit 2 }
Write-Host "Catalog version $version is structurally valid."