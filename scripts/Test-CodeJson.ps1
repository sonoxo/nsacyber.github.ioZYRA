[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Path)) { throw "Missing catalog: $Path" }
$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
if (-not $catalog.version) { throw 'code.json: version is required' }
if (-not $catalog.agency) { throw 'code.json: agency is required' }
if ($null -eq $catalog.releases) { throw 'code.json: releases is required' }

$errors = [System.Collections.Generic.List[string]]::new()
$names = @{}
$repos = @{}
foreach ($release in $catalog.releases) {
    if ([string]::IsNullOrWhiteSpace($release.name)) { $errors.Add('release missing name') }
    if ([string]::IsNullOrWhiteSpace($release.repositoryURL)) { $errors.Add("$($release.name): missing repositoryURL") }
    elseif ($release.repositoryURL -notmatch '^https?://') { $errors.Add("$($release.name): invalid repositoryURL") }

    if ($release.name) {
        $key = $release.name.ToLowerInvariant()
        if ($names.ContainsKey($key)) { $errors.Add("duplicate release name: $($release.name)") } else { $names[$key] = $true }
    }
    if ($release.repositoryURL) {
        $key = $release.repositoryURL.TrimEnd('/').ToLowerInvariant()
        if ($repos.ContainsKey($key)) { $errors.Add("duplicate repositoryURL: $($release.repositoryURL)") } else { $repos[$key] = $true }
    }
}

if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host "code.json validation passed ($($catalog.releases.Count) releases)."