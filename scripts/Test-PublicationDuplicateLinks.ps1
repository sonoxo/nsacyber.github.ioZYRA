[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'publications.md'))
$links = @()
foreach ($line in Get-Content -LiteralPath $Path) {
  if ($line -match '^\*\s+Link:\s*<?(https?://[^>\s]+)>?') { $links += $Matches[1].TrimEnd('/').ToLowerInvariant() }
}
$groups = @($links | Group-Object | Where-Object Count -gt 1)
if ($groups.Count) { $groups | ForEach-Object { Write-Warning "duplicate publication link: $($_.Name) ($($_.Count)x)" }; exit 2 }
Write-Host 'Publication links are unique.'