[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
    if ($null -eq $release.date) { $warnings += "$($release.name): missing date metadata"; continue }
    if ([string]::IsNullOrWhiteSpace([string]$release.date.created)) { $warnings += "$($release.name): missing date.created" }
    if ([string]::IsNullOrWhiteSpace([string]$release.date.lastModified)) { $warnings += "$($release.name): missing date.lastModified" }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Date metadata is complete.'