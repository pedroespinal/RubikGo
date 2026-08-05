<#
Increments the patch version and build number in pubspec.yaml.
Reads a line like:  version: 1.2.3+9
Writes it back as:  version: 1.2.4+10

Usage: powershell -File scripts/bump_version.ps1
Prints the new version string to stdout on success.
#>

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$pubspecPath = Join-Path $repoRoot "pubspec.yaml"

if (-not (Test-Path $pubspecPath)) {
    throw "pubspec.yaml not found at $pubspecPath"
}

$lines = Get-Content $pubspecPath
$versionLineIndex = -1
$newVersion = $null

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^version:\s*(\d+)\.(\d+)\.(\d+)\+(\d+)\s*$') {
        $major = [int]$Matches[1]
        $minor = [int]$Matches[2]
        $patch = [int]$Matches[3] + 1
        $build = [int]$Matches[4] + 1
        $newVersion = "$major.$minor.$patch+$build"
        $lines[$i] = "version: $newVersion"
        $versionLineIndex = $i
        break
    }
}

if ($versionLineIndex -eq -1) {
    throw "Could not find a 'version: X.Y.Z+N' line in pubspec.yaml"
}

Set-Content -Path $pubspecPath -Value $lines -Encoding utf8

Write-Output $newVersion
