<#
Publishes the RubikGo release currently sitting in pubspec.yaml / the build
output: commits any pending changes (e.g. the version bump from
build_release.ps1), pushes to GitHub, and creates a GitHub Release with the
release APK attached.

This performs real, visible actions (git push, a public GitHub release) —
run it only when you actually mean to publish. Always run
scripts/build_release.ps1 first so the APK on disk matches the version
in pubspec.yaml.

Usage: powershell -File scripts/publish_release.ps1
#>

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    $pubspecPath = Join-Path $repoRoot "pubspec.yaml"
    $versionLine = (Select-String -Path $pubspecPath -Pattern '^version:\s*(.+)$').Matches[0].Groups[1].Value.Trim()
    $versionParts = $versionLine.Split('+')
    $versionName = $versionParts[0]
    $tag = "v$versionName"

    # build_release.ps1 always names its output "RubikGo-v<version>-b<build>.apk".
    $versionedApkName = "RubikGo-v$($versionParts[0])-b$($versionParts[1]).apk"
    $apkPath = Join-Path $repoRoot "build\app\outputs\flutter-apk\$versionedApkName"
    if (-not (Test-Path $apkPath)) {
        throw "No versioned release APK found at $apkPath. Run scripts/build_release.ps1 first."
    }

    Write-Output "==> Publishing $tag"

    # gh writes to stderr when the release doesn't exist (the expected case
    # here), which under $ErrorActionPreference = "Stop" would otherwise be
    # promoted into a terminating error — so relax it just for this check.
    $previousErrorPreference = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    gh release view $tag --repo pedroespinal/RubikGo 2>$null | Out-Null
    $releaseAlreadyExists = ($LASTEXITCODE -eq 0)
    $ErrorActionPreference = $previousErrorPreference

    if ($releaseAlreadyExists) {
        throw "GitHub release $tag already exists. Bump the version (scripts/build_release.ps1) before publishing again."
    }

    $status = git status --porcelain
    if ($status) {
        Write-Output "==> Committing pending changes"
        git add -A
        git commit -m "Release $tag"
        if ($LASTEXITCODE -ne 0) {
            throw "git commit failed."
        }
    }
    else {
        Write-Output "==> Nothing to commit, working tree already clean"
    }

    Write-Output "==> Pushing to origin main"
    git push origin main
    if ($LASTEXITCODE -ne 0) {
        throw "git push failed."
    }

    Write-Output "==> Creating GitHub release $tag"
    gh release create $tag $apkPath `
        --repo pedroespinal/RubikGo `
        --title "RubikGo $tag" `
        --generate-notes

    if ($LASTEXITCODE -ne 0) {
        throw "gh release create failed."
    }

    Write-Output "==> Done. https://github.com/pedroespinal/RubikGo/releases/tag/$tag"
}
finally {
    Pop-Location
}
