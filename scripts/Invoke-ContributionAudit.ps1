[CmdletBinding()]
param([string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')))

$ErrorActionPreference = 'Stop'
$checks = @(
    @{ Name = 'code.json'; Script = 'Test-CodeJson.ps1'; Args = @('-Path', (Join-Path $Root 'code.json')) },
    @{ Name = 'markdown-links'; Script = 'Test-MarkdownLinks.ps1'; Args = @('-Root', $Root) },
    @{ Name = 'publication-metadata'; Script = 'Test-PublicationMetadata.ps1'; Args = @('-Path', (Join-Path $Root 'publications.md')) }
)

$failed = $false
foreach ($check in $checks) {
    Write-Host "==> $($check.Name)"
    & (Join-Path $PSScriptRoot $check.Script) @($check.Args)
    if ($LASTEXITCODE -ne 0) { $failed = $true }
}

if ($failed) { exit 1 }
Write-Host 'Contribution audit passed.'