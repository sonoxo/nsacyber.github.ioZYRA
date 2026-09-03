[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
  foreach ($field in @('created','metadataLastUpdated','lastModified')) {
    $value = [string]$release.date.$field
    if ([string]::IsNullOrWhiteSpace($value)) { continue }
    if ($value -notmatch '^\d{4}-\d{2}-\d{2}$') { $warnings += "$($release.name): date.$field is not YYYY-MM-DD ('$value')" }
  }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Release date formats are normalized.'