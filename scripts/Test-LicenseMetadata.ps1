[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
    $licenses = @($release.permissions.licenses)
    if (-not $licenses.Count) {
        $warnings += "$($release.name): no license metadata"
        continue
    }
    foreach ($license in $licenses) {
        if ([string]::IsNullOrWhiteSpace([string]$license.name)) { $warnings += "$($release.name): license missing name" }
        if ([string]::IsNullOrWhiteSpace([string]$license.URL)) { $warnings += "$($release.name): license missing URL" }
    }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'License metadata shape is complete.'