[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
  $email = [string]$release.contact.email
  if ([string]::IsNullOrWhiteSpace($email)) { continue }
  if ($email -notmatch '^[^\s@]+@[^\s@]+\.[^\s@]+$') { $warnings += "$($release.name): malformed contact email '$email'" }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Contact email values have valid shape.'