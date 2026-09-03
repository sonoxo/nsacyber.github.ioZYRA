[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
  $url = [string]$release.repositoryURL
  if ([string]::IsNullOrWhiteSpace($url)) { continue }
  $uri = $null
  if ([Uri]::TryCreate($url,[UriKind]::Absolute,[ref]$uri) -and $uri.Fragment) { $warnings += "$($release.name): repositoryURL contains fragment '$($uri.Fragment)'" }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Repository URLs contain no fragments.'