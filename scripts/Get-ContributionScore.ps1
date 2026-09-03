[CmdletBinding()]
param([Parameter(Mandatory)][string]$ManifestPath)

$manifest = Get-Content -LiteralPath $ManifestPath -Raw | ConvertFrom-Json
$weights = @{ error = 100; warning = 50; info = 10 }
$rows = foreach ($finding in @($manifest.findings)) {
    $severityWeight = if ($weights.ContainsKey($finding.severity)) { $weights[$finding.severity] } else { 1 }
    $confidence = if ($null -eq $finding.confidence) { 0.5 } else { [double]$finding.confidence }
    [pscustomobject]@{
        id = $finding.id
        class = $finding.class
        severity = $finding.severity
        confidence = $confidence
        score = [math]::Round($severityWeight * $confidence, 2)
        path = $finding.path
    }
}
$rows | Sort-Object score -Descending