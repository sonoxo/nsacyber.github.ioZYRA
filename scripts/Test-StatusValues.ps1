[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$allowed = @('Production','Archival','Development','Inactive')
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    if ([string]::IsNullOrWhiteSpace([string]$release.status)) {
        $errors += "$($release.name): missing status"
    } elseif ($release.status -notin $allowed) {
        $errors += "$($release.name): unrecognized status '$($release.status)'"
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'Release status values are recognized.'