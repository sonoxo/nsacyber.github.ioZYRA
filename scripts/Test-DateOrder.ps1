[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
  $created = $null; $modified = $null
  if ([datetime]::TryParse([string]$release.date.created,[ref]$created) -and [datetime]::TryParse([string]$release.date.lastModified,[ref]$modified)) {
    if ($modified -lt $created) { $warnings += "$($release.name): lastModified precedes created" }
  }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Release date ordering is valid.'