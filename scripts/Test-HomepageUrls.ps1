[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    $url = [string]$release.homepageURL
    if ([string]::IsNullOrWhiteSpace($url)) { continue }
    $uri = $null
    if (-not [Uri]::TryCreate($url, [UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -notin @('http','https')) {
        $errors += "$($release.name): invalid homepageURL '$url'"
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'Homepage URLs are structurally valid.'