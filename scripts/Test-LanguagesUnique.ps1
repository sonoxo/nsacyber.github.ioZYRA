[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
  $groups = @($release.languages | Group-Object { ([string]$_).ToLowerInvariant() } | Where-Object Count -gt 1)
  foreach ($group in $groups) { $warnings += "$($release.name): duplicate language '$($group.Name)'" }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Languages are unique within each release.'