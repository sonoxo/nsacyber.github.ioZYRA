[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$releases = @($catalog.releases)
[pscustomobject]@{
    agency = $catalog.agency
    version = $catalog.version
    releases = $releases.Count
    production = @($releases | Where-Object status -eq 'Production').Count
    archival = @($releases | Where-Object status -eq 'Archival').Count
    withHomepage = @($releases | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.homepageURL) }).Count
    withDownload = @($releases | Where-Object { -not [string]::IsNullOrWhiteSpace([string]$_.downloadURL) }).Count
    withLanguages = @($releases | Where-Object { @($_.languages).Count -gt 0 }).Count
} | Format-List