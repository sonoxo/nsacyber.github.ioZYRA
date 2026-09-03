[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    foreach ($tag in @($release.tags)) {
        if ([string]::IsNullOrWhiteSpace([string]$tag)) { $errors += "$($release.name): empty tag" }
        elseif ([string]$tag -notmatch '^[a-z0-9][a-z0-9._-]*$') { $errors += "$($release.name): malformed tag '$tag'" }
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Tag values are normalized.'