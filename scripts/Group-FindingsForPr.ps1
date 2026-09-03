[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$ManifestPath,
    [int]$MaxPerBatch = 20
)

$manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$groups = @($manifest.findings) | Group-Object class
$result = [System.Collections.Generic.List[object]]::new()
foreach ($group in $groups) {
    $items = @($group.Group | Sort-Object path,id)
    for ($i = 0; $i -lt $items.Count; $i += $MaxPerBatch) {
        $end = [math]::Min($i + $MaxPerBatch - 1, $items.Count - 1)
        $slice = @($items[$i..$end])
        $result.Add([pscustomobject]@{
            class = $group.Name
            batch = [int]($i / $MaxPerBatch) + 1
            count = $slice.Count
            findingIds = @($slice.id)
            paths = @($slice.path | Sort-Object -Unique)
        })
    }
}
$result | ConvertTo-Json -Depth 6