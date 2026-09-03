[CmdletBinding()]
param([string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')))

$warnings = [System.Collections.Generic.List[string]]::new()
Get-ChildItem -LiteralPath $Root -Filter '*.md' -Recurse -File | ForEach-Object {
    $file = $_
    $lineNumber = 0
    Get-Content -LiteralPath $file.FullName | ForEach-Object {
        $lineNumber++
        if ($_ -match '!\[\s*\]\([^)]+\)') {
            $warnings.Add("$($file.FullName):$lineNumber image has empty alt text")
        }
    }
}

if ($warnings.Count) {
    $warnings | ForEach-Object { Write-Warning $_ }
    exit 2
}
Write-Host 'Markdown accessibility hint scan passed.'