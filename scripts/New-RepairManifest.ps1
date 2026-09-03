[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$InputPath,
    [string]$OutputPath = (Join-Path $PSScriptRoot '..' 'artifacts' 'repair-manifest.json')
)

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $InputPath)) { throw "Missing findings file: $InputPath" }
$findings = Get-Content -LiteralPath $InputPath -Raw | ConvertFrom-Json
$items = @($findings) | Sort-Object class,path,evidence | ForEach-Object {
    [pscustomobject]@{
        id = $_.id
        class = $_.class
        severity = $_.severity
        path = $_.path
        evidence = $_.evidence
        proposedAction = $_.proposedAction
        confidence = $_.confidence
    }
}
$manifest = [pscustomobject]@{
    version = 1
    generatedFrom = (Split-Path -Leaf $InputPath)
    count = $items.Count
    findings = $items
}
$dir = Split-Path -Parent $OutputPath
if ($dir) { New-Item -ItemType Directory -Force -Path $dir | Out-Null }
$manifest | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Host "Wrote $($items.Count) findings to $OutputPath"