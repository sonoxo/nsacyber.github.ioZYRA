[CmdletBinding()]
param(
  [Parameter(Mandatory)][string]$ManifestPath,
  [string]$OutputPath = (Join-Path $PSScriptRoot '..' 'artifacts' 'findings.jsonl')
)
$manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$dir = Split-Path -Parent $OutputPath
if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
@($manifest.findings) | ForEach-Object { $_ | ConvertTo-Json -Depth 8 -Compress } | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Host "Exported $(@($manifest.findings).Count) findings to $OutputPath"