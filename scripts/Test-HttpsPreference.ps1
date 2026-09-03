[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
  foreach ($field in @('repositoryURL','homepageURL','downloadURL','disclaimerURL')) {
    $url = [string]$release.$field
    if ($url -match '^http://') { $warnings += "$($release.name): $field uses HTTP" }
  }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Catalog URLs prefer HTTPS.'