[CmdletBinding()]
param([string]$Path = (Join-Path $PSScriptRoot '..' 'code.json'))

$catalog = Get-Content -LiteralPath $Path -Raw | ConvertFrom-Json
$releases = @($catalog.releases)
if (-not $releases.Count) { throw 'No releases found.' }
$fields = 'description','repositoryURL','homepageURL','downloadURL','status','vcs','languages','tags','contact'
foreach ($field in $fields) {
    $present = @($releases | Where-Object {
        $value = $_.$field
        if ($value -is [System.Array]) { return $value.Count -gt 0 }
        return -not [string]::IsNullOrWhiteSpace([string]$value)
    }).Count
    [pscustomobject]@{
        field = $field
        present = $present
        total = $releases.Count
        coveragePercent = [math]::Round(($present / $releases.Count) * 100, 2)
    }
}