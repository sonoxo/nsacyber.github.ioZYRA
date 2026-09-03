[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$duplicates = @($catalog.releases | Group-Object { $_.name.ToLowerInvariant() } | Where-Object Count -gt 1)
if ($duplicates.Count) {
    $duplicates | ForEach-Object { Write-Error "duplicate release name: $($_.Name) ($($_.Count)x)" }
    exit 1
}
Write-Host 'Release names are unique.'