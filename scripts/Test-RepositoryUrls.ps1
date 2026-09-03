[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    $url = [string]$release.repositoryURL
    if ([string]::IsNullOrWhiteSpace($url)) { $errors += "$($release.name): missing repositoryURL"; continue }
    $uri = $null
    if (-not [Uri]::TryCreate($url, [UriKind]::Absolute, [ref]$uri) -or $uri.Scheme -notin @('http','https')) {
        $errors += "$($release.name): invalid repositoryURL '$url'"
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'Repository URLs are structurally valid.'