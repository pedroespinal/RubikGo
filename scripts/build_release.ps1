<#
Release build gate for RubikGo.

Rule: a new version is never built/published unless `flutter analyze` and
`flutter test` pass cleanly. This script enforces that gate, then bumps the
version (patch + build number) and produces the release APK with an
embedded build signature (see lib/core/signature/app_signature.dart).

Usage: powershell -File scripts/build_release.ps1
#>

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    Write-Output "==> flutter analyze"
    flutter analyze
    if ($LASTEXITCODE -ne 0) {
        throw "flutter analyze failed. Fix all issues before building a release."
    }

    Write-Output "==> flutter test"
    flutter test
    if ($LASTEXITCODE -ne 0) {
        throw "flutter test failed. Fix all failing tests before building a release."
    }

    $pubspecPath = Join-Path $repoRoot "pubspec.yaml"
    $versionBeforeBump = (Select-String -Path $pubspecPath -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value.Trim()

    Write-Output "==> Bumping version"
    $newVersion = & (Join-Path $PSScriptRoot "bump_version.ps1")
    Write-Output "New version: $newVersion"

    try {
        $author = "Pedro Espinal"
        $creationDate = "2026-08-05"
        $commitHash = "nogit"
        try {
            $commitHash = (git rev-parse --short HEAD 2>$null)
            if (-not $commitHash) { $commitHash = "nogit" }
        } catch { $commitHash = "nogit" }

        $rawSignature = "$newVersion|$author|$creationDate|$commitHash"
        $sha256 = [System.Security.Cryptography.SHA256]::Create()
        $bytes = [System.Text.Encoding]::UTF8.GetBytes($rawSignature)
        $hashBytes = $sha256.ComputeHash($bytes)
        $buildSignature = ($hashBytes | ForEach-Object { $_.ToString("x2") }) -join ""

        Write-Output "Build signature: $buildSignature"

        Write-Output "==> flutter build apk --release"
        flutter build apk --release `
            --dart-define=BUILD_SIGNATURE=$buildSignature `
            --dart-define=BUILD_VERSION=$newVersion `
            --dart-define=BUILD_COMMIT=$commitHash

        if ($LASTEXITCODE -ne 0) {
            throw "flutter build apk failed."
        }
    }
    catch {
        Write-Output "==> Build failed: reverting the version bump (staying on $versionBeforeBump)"
        (Get-Content $pubspecPath) -replace '^version:\s*.+$', "version: $versionBeforeBump" |
            Set-Content -Path $pubspecPath -Encoding utf8
        throw
    }

    Write-Output "==> Done. APK at build\app\outputs\flutter-apk\app-release.apk (version $newVersion)"
}
finally {
    Pop-Location
}
