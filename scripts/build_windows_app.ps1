# Build a portable Moleku dist folder on Windows (PyInstaller + mcrg.spec).
# Mirrors scripts/build_mac_app.sh. Use a dedicated conda/mamba env (see
# README / .github/workflows/release.yml) so the bundle does not pull optional
# heavy packages from a "base" Anaconda install.

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
Set-Location $Root

$Py = if ($env:PYTHON) { $env:PYTHON } else { "python" }
$DistSuffix = $env:MOLEKU_DIST_SUFFIX
$AppName = if ($env:MOLEKU_APP_NAME) { $env:MOLEKU_APP_NAME } else { "Moleku" }

function Test-PythonDeps {
    & $Py -c "import rdkit, PyInstaller" 2>$null | Out-Null
    return $LASTEXITCODE -eq 0
}

if (-not (Test-PythonDeps)) {
    Write-Host "Need Python with rdkit and pyinstaller on PATH (e.g. a conda-forge env)."
    Write-Host "Example:"
    Write-Host "  mamba create -y -n moleku-build -c conda-forge python=3.11 rdkit pandas pillow numpy openpyxl reportlab pyinstaller"
    Write-Host "  mamba activate moleku-build"
    Write-Host "  pip install customtkinter matplotlib"
    Write-Host '  $env:PYTHON = "python"; scripts\build_windows_app.ps1'
    exit 1
}

function Install-AdmetLocalStack {
    Write-Host "Ensuring ADMET local build stack..."
    & $Py -m pip install --upgrade `
        "setuptools<81" `
        "pyinstaller-hooks-contrib>=2026.4" `
        "torch==2.2.2" `
        "admet-ai==1.3.1" `
        py4j `
        customtkinter `
        matplotlib `
        openpyxl `
        reportlab
    if ($LASTEXITCODE -ne 0) { throw "pip install failed while ensuring the ADMET local build stack" }
}

function Copy-LegalFiles {
    param([string]$TargetDir)
    if (-not (Test-Path $TargetDir)) { return }
    if (Test-Path (Join-Path $Root "LICENSE")) {
        Copy-Item (Join-Path $Root "LICENSE") (Join-Path $TargetDir "LICENSE") -Force
    }
    if (Test-Path (Join-Path $Root "NOTICE")) {
        Copy-Item (Join-Path $Root "NOTICE") (Join-Path $TargetDir "NOTICE") -Force
    }
}

function Get-MolekuVersion {
    $content = Get-Content (Join-Path $Root "pyproject.toml") -Raw
    if ($content -match 'version\s*=\s*"([^"]+)"') { return $Matches[1] }
    return "0.0.0"
}

function Find-InnoSetupCompiler {
    if ($env:ISCC -and (Test-Path $env:ISCC)) { return $env:ISCC }
    $candidates = @(
        "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe",
        "C:\Program Files (x86)\Inno Setup 6\ISCC.exe",
        "C:\Program Files\Inno Setup 6\ISCC.exe"
    )
    foreach ($c in $candidates) { if (Test-Path $c) { return $c } }
    return $null
}

Write-Host "Building Windows app:"
& $Py -c "import sys; print('  python:', sys.executable)"

# Keep ADMET local available inside the frozen app with a stack PyInstaller
# can package reliably.
Install-AdmetLocalStack

Remove-Item -Recurse -Force -ErrorAction SilentlyContinue "dist\Moleku", "build\mcrg"

& $Py scripts\generate_icons.py
& $Py -m PyInstaller --clean --noconfirm mcrg.spec
if ($LASTEXITCODE -ne 0) { throw "PyInstaller build failed" }

$DistPath = "dist\Moleku"
if ($DistSuffix) {
    $NewDistPath = "dist\$AppName-$DistSuffix"
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $NewDistPath
    Move-Item $DistPath $NewDistPath
    $DistPath = $NewDistPath
}

Copy-LegalFiles -TargetDir $DistPath

Write-Host ""
Write-Host "Listo. Ejecutable en:"
Write-Host "  $Root\$DistPath\Moleku.exe"
Write-Host "(Empaqueta con: Compress-Archive -Path '$DistPath' -DestinationPath 'dist\Moleku-Windows.zip')"

# Build the friendly installer (Setup.exe) when Inno Setup is available and
# the standard (non-suffixed) onedir layout was produced — packaging\windows\Moleku.iss
# expects dist\Moleku\.
if (-not $DistSuffix) {
    $InnoCompiler = Find-InnoSetupCompiler
    if ($InnoCompiler) {
        $Version = Get-MolekuVersion
        Write-Host ""
        Write-Host "Building installer with Inno Setup (v$Version)..."
        & $InnoCompiler "/DMyAppVersion=$Version" "packaging\windows\Moleku.iss"
        if ($LASTEXITCODE -ne 0) { throw "Inno Setup compile failed" }
        Write-Host "Instalador: $Root\dist\Moleku-Setup-$Version.exe"
    } else {
        Write-Host ""
        Write-Host "Inno Setup (ISCC.exe) no encontrado; se omite el instalador .exe."
        Write-Host "Instalalo desde https://jrsoftware.org/isinfo.php si lo quieres generar."
    }
}
