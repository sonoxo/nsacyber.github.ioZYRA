[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
    if ($null -eq $release.contact) { $warnings += "$($release.name): missing contact metadata"; continue }
    if ([string]::IsNullOrWhiteSpace([string]$release.contact.name)) { $warnings += "$($release.name): contact missing name" }
    if ([string]::IsNullOrWhiteSpace([string]$release.contact.URL)) { $warnings += "$($release.name): contact missing URL" }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Contact metadata is complete.'