[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$seen = @{}
$duplicates = @()
foreach ($release in $catalog.releases) {
    foreach ($field in @('repositoryURL','homepageURL','downloadURL')) {
        $url = [string]$release.$field
        if ([string]::IsNullOrWhiteSpace($url)) { continue }
        $key = $url.TrimEnd('/').ToLowerInvariant()
        if ($seen.ContainsKey($key)) { $duplicates += "$($release.name): $field duplicates '$($seen[$key])'" } else { $seen[$key] = "$($release.name).$field" }
    }
}
if ($duplicates.Count) { $duplicates | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'No canonical URL duplicates found.'