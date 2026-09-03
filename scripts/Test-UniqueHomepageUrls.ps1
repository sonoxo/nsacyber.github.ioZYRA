[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$groups = @($catalog.releases | Where-Object { $_.homepageURL } | Group-Object { ([string]$_.homepageURL).TrimEnd('/').ToLowerInvariant() } | Where-Object Count -gt 1)
if ($groups.Count) { $groups | ForEach-Object { Write-Warning "duplicate homepageURL: $($_.Name) ($($_.Count)x)" }; exit 2 }
Write-Host 'Homepage URLs are unique.'