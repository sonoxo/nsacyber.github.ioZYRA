[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
if ([string]::IsNullOrWhiteSpace([string]$catalog.agency)) { Write-Error 'agency is missing'; exit 1 }
if ([string]$catalog.agency -ne 'NSA') { Write-Warning "unexpected agency '$($catalog.agency)'"; exit 2 }
Write-Host 'Agency metadata is NSA.'