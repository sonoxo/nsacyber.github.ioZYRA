[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    foreach ($language in @($release.languages)) {
        if ([string]::IsNullOrWhiteSpace([string]$language)) { $errors += "$($release.name): empty language value" }
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Language metadata is nonempty.'