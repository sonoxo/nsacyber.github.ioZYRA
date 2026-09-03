[CmdletBinding()]
param(
    [string]$RepositoryRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
)

$ErrorActionPreference = 'Stop'
$errors = [System.Collections.Generic.List[string]]::new()
$warnings = [System.Collections.Generic.List[string]]::new()

function Add-IntegrityError {
    param([string]$Message)
    $errors.Add($Message)
    Write-Host "::error::$Message"
}

function Add-IntegrityWarning {
    param([string]$Message)
    $warnings.Add($Message)
    Write-Host "::warning::$Message"
}

function Test-AbsoluteUrl {
    param([string]$Value)
    if ([string]::IsNullOrWhiteSpace($Value)) { return $false }
    $uri = $null
    if (-not [System.Uri]::TryCreate($Value, [System.UriKind]::Absolute, [ref]$uri)) { return $false }
    return $uri.Scheme -in @('http', 'https')
}

$codeJsonPath = Join-Path $RepositoryRoot 'code.json'
if (-not (Test-Path -LiteralPath $codeJsonPath)) {
    Add-IntegrityError 'code.json is missing.'
}
else {
    try {
        $catalog = Get-Content -LiteralPath $codeJsonPath -Raw | ConvertFrom-Json
    }
    catch {
        Add-IntegrityError "code.json is not valid JSON: $($_.Exception.Message)"
        $catalog = $null
    }

    if ($null -ne $catalog) {
        if ([string]::IsNullOrWhiteSpace([string]$catalog.version)) { Add-IntegrityError 'code.json: version is required.' }
        if ([string]::IsNullOrWhiteSpace([string]$catalog.agency)) { Add-IntegrityError 'code.json: agency is required.' }
        if ($null -eq $catalog.releases -or @($catalog.releases).Count -eq 0) {
            Add-IntegrityError 'code.json: releases must contain at least one entry.'
        }
        else {
            $seenNames = @{}
            $seenRepos = @{}
            $index = 0
            foreach ($release in @($catalog.releases)) {
                $index++
                $prefix = "code.json release #$index"
                foreach ($field in @('name', 'repositoryURL', 'status', 'vcs')) {
                    if ([string]::IsNullOrWhiteSpace([string]$release.$field)) {
                        Add-IntegrityError "$prefix: required field '$field' is missing or empty."
                    }
                }

                $name = [string]$release.name
                $repoUrl = [string]$release.repositoryURL
                if ($name) {
                    $key = $name.ToLowerInvariant()
                    if ($seenNames.ContainsKey($key)) { Add-IntegrityError "$prefix: duplicate release name '$name'." }
                    else { $seenNames[$key] = $true }
                }

                if ($repoUrl) {
                    if (-not (Test-AbsoluteUrl $repoUrl)) { Add-IntegrityError "$prefix: repositoryURL is not a valid HTTP(S) URL: $repoUrl" }
                    $repoKey = $repoUrl.TrimEnd('/').ToLowerInvariant()
                    if ($seenRepos.ContainsKey($repoKey)) { Add-IntegrityError "$prefix: duplicate repositoryURL '$repoUrl'." }
                    else { $seenRepos[$repoKey] = $true }
                }

                foreach ($urlField in @('homepageURL', 'downloadURL', 'disclaimerURL')) {
                    $value = [string]$release.$urlField
                    if ($value -and -not (Test-AbsoluteUrl $value)) {
                        Add-IntegrityWarning "$prefix: $urlField is not a valid HTTP(S) URL: $value"
                    }
                }
            }
        }
    }
}

$markdownFiles = Get-ChildItem -LiteralPath $RepositoryRoot -Filter '*.md' -File
$linkPattern = '\[[^\]]*\]\((?<target>[^)]+)\)'
foreach ($file in $markdownFiles) {
    $text = Get-Content -LiteralPath $file.FullName -Raw
    foreach ($match in [regex]::Matches($text, $linkPattern)) {
        $target = $match.Groups['target'].Value.Trim()
        if (-not $target -or $target.StartsWith('#') -or $target -match '^(https?|mailto):') { continue }

        $pathPart = ($target -split '#', 2)[0]
        $pathPart = [System.Uri]::UnescapeDataString($pathPart)
        if ([string]::IsNullOrWhiteSpace($pathPart)) { continue }

        $candidate = Join-Path $file.DirectoryName $pathPart
        if (-not (Test-Path -LiteralPath $candidate)) {
            Add-IntegrityError "$($file.Name): local Markdown link target does not exist: $target"
        }
    }
}

Write-Host ''
Write-Host "Integrity summary: $($errors.Count) error(s), $($warnings.Count) warning(s)."
if ($errors.Count -gt 0) { exit 1 }
exit 0
