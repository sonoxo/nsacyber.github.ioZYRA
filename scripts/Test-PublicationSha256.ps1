[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'publications.md'))
$warnings = @()
$current = $null
foreach ($line in Get-Content -LiteralPath $Path) {
  if ($line -match '^###\s+(.+)$') { $current = $Matches[1].Trim(); continue }
  if ($current -and $line -match '^\*\s+SHA256:\s*(.*)$') {
    $value = $Matches[1].Trim()
    if ($value -and $value -notmatch '^[A-Fa-f0-9]{64}$') { $warnings += "$current: malformed SHA256 '$value'" }
  }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Publication SHA256 values have valid shape.'