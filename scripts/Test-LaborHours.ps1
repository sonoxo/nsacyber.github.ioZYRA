[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    if ($null -eq $release.laborHours) { continue }
    $value = 0.0
    if (-not [double]::TryParse([string]$release.laborHours, [ref]$value) -or $value -lt 0) {
        $errors += "$($release.name): invalid laborHours '$($release.laborHours)'"
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'laborHours values are valid.'