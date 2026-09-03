[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$warnings = @()
foreach ($release in $catalog.releases) {
    $url = [string]$release.repositoryURL
    if ($url -match '^https?://github\.com/') {
        $uri = [Uri]$url
        if ($uri.AbsolutePath.Trim('/') -notmatch '^[^/]+/[^/]+$') { $warnings += "$($release.name): unusual GitHub repository path '$($uri.AbsolutePath)'" }
    }
}
if ($warnings.Count) { $warnings | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'GitHub repository paths have owner/repo shape.'