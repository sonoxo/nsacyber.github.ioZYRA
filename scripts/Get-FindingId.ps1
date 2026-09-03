[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Class,
    [Parameter(Mandatory)][string]$Path,
    [Parameter(Mandatory)][string]$Evidence
)

$normalized = "$($Class.Trim().ToLowerInvariant())|$($Path.Replace('\\','/').Trim().ToLowerInvariant())|$($Evidence.Trim())"
$bytes = [System.Text.Encoding]::UTF8.GetBytes($normalized)
$sha = [System.Security.Cryptography.SHA256]::Create()
try {
    $hash = $sha.ComputeHash($bytes)
    $hex = -join ($hash | ForEach-Object { $_.ToString('x2') })
    "finding-$($hex.Substring(0,16))"
} finally {
    $sha.Dispose()
}