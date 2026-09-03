[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$InputPath,
    [string]$OutputPath = (Join-Path $PSScriptRoot '..' 'artifacts' 'findings.csv')
)

$ErrorActionPreference = 'Stop'
$data = Get-Content -LiteralPath $InputPath -Raw | ConvertFrom-Json
$rows = @($data.findings)
$dir = Split-Path -Parent $OutputPath
if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
$rows | Select-Object id,class,severity,path,evidence,proposedAction,confidence | Export-Csv -LiteralPath $OutputPath -NoTypeInformation -Encoding utf8
Write-Host "Exported $($rows.Count) findings to $OutputPath"