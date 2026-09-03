[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'publications.md'))

$ErrorActionPreference = 'Stop'
if (-not (Test-Path -LiteralPath $Path)) { throw "Missing publications file: $Path" }
$lines = Get-Content -LiteralPath $Path
$current = $null
$fields = @{}
$errors = [System.Collections.Generic.List[string]]::new()

function Test-Block {
    param($Title, $Map)
    if (-not $Title) { return }
    if (-not $Map.ContainsKey('Date')) { $script:errors.Add("$Title: missing Date") }
    if (-not $Map.ContainsKey('Link')) { $script:errors.Add("$Title: missing Link") }
    elseif ($Map['Link'] -notmatch 'https?://') { $script:errors.Add("$Title: invalid Link") }
}

foreach ($line in $lines) {
    if ($line -match '^###\s+(.+)$') {
        Test-Block $current $fields
        $current = $Matches[1].Trim()
        $fields = @{}
    } elseif ($current -and $line -match '^\*\s+([^:]+):\s*(.*)$') {
        $fields[$Matches[1].Trim()] = $Matches[2].Trim()
    }
}
Test-Block $current $fields

if ($errors.Count) { $errors | ForEach-Object { Write-Warning $_ }; exit 1 }
Write-Host 'Publication metadata validation passed.'