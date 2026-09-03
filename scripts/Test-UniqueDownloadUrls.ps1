[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$groups = @($catalog.releases | Where-Object { $_.downloadURL } | Group-Object { ([string]$_.downloadURL).TrimEnd('/').ToLowerInvariant() } | Where-Object Count -gt 1)
if ($groups.Count) { $groups | ForEach-Object { Write-Warning "duplicate downloadURL: $($_.Name) ($($_.Count)x)" }; exit 2 }
Write-Host 'Download URLs are unique.'