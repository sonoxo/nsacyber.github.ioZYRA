[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$BeforePath,
  [Parameter(Mandatory)][string]$AfterPath
)
$before = Get-Content -LiteralPath $BeforePath -Raw | ConvertFrom-Json
$after = Get-Content -LiteralPath $AfterPath -Raw | ConvertFrom-Json
$beforeMap = @{}; foreach ($r in $before.releases) { $beforeMap[[string]$r.name] = $r }
$afterMap = @{}; foreach ($r in $after.releases) { $afterMap[[string]$r.name] = $r }
$names = @($beforeMap.Keys + $afterMap.Keys | Sort-Object -Unique)
foreach ($name in $names) {
  if (-not $beforeMap.ContainsKey($name)) { [pscustomobject]@{name=$name;change='added'}; continue }
  if (-not $afterMap.ContainsKey($name)) { [pscustomobject]@{name=$name;change='removed'}; continue }
  $a = $beforeMap[$name] | ConvertTo-Json -Depth 10 -Compress
  $b = $afterMap[$name] | ConvertTo-Json -Depth 10 -Compress
  if ($a -ne $b) { [pscustomobject]@{name=$name;change='modified'} }
}