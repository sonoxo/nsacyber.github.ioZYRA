[CmdletBinding()]
param([string]$Root = (Resolve-Path (Join-Path $PSScriptRoot '..')))

$ErrorActionPreference = 'Stop'
$errors = [System.Collections.Generic.List[string]]::new()
Get-ChildItem -LiteralPath $Root -Filter '*.md' -Recurse -File | ForEach-Object {
    $file = $_
    $text = Get-Content -LiteralPath $file.FullName -Raw
    $matches = [regex]::Matches($text, '\[[^\]]+\]\((?!https?://|mailto:|#)([^)]+)\)')
    foreach ($m in $matches) {
        $target = ($m.Groups[1].Value -split '#')[0]
        if ([string]::IsNullOrWhiteSpace($target)) { continue }
        $decoded = [System.Uri]::UnescapeDataString($target)
        $candidate = Join-Path $file.DirectoryName $decoded
        if (-not (Test-Path -LiteralPath $candidate)) {
            $errors.Add("$($file.FullName): missing local target '$target'")
        }
    }
}
if ($errors.Count) { $errors | ForEach-Object { Write-Error $_ }; exit 1 }
Write-Host 'Local Markdown link validation passed.'