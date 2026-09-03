[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
if ($null -eq $catalog.measurementType) { Write-Warning 'measurementType is missing'; exit 2 }
if ([string]::IsNullOrWhiteSpace([string]$catalog.measurementType.method)) { Write-Warning 'measurementType.method is missing'; exit 2 }
Write-Host "measurementType.method=$($catalog.measurementType.method)"