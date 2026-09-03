[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    $usage = [string]$release.permissions.usageType
    if ([string]::IsNullOrWhiteSpace($usage)) { $errors += "$($release.name): missing permissions.usageType" }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Usage type metadata is present.'