[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$errors = @()
foreach ($release in $catalog.releases) {
    if ([string]::IsNullOrWhiteSpace([string]$release.vcs)) { $errors += "$($release.name): missing vcs" }
    elseif ([string]$release.vcs -notmatch '^(?i:git)$') { $errors += "$($release.name): unexpected vcs '$($release.vcs)'" }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Warning $_ }; exit 2 }
Write-Host 'VCS metadata is valid.'