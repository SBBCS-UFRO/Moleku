# Smoke test the frozen Windows build: launch Moleku.exe, verify the process
# stays alive, then stop it cleanly. Mirrors scripts/smoke_test_mac_app.sh.

$ErrorActionPreference = "Stop"

$ExePath = if ($args.Count -gt 0) { $args[0] } else { "dist\Moleku\Moleku.exe" }
if (-not (Test-Path $ExePath)) {
    Write-Host "Executable not found: $ExePath"
    exit 1
}

$proc = Start-Process -FilePath $ExePath -PassThru
Start-Sleep -Seconds 5

if ($proc.HasExited) {
    Write-Host "Smoke test failed: $(Split-Path -Leaf $ExePath) exited early (exit code $($proc.ExitCode))."
    exit 1
}

Stop-Process -Id $proc.Id -Force
Start-Sleep -Seconds 1

Write-Host "Smoke test OK: $(Split-Path -Leaf $ExePath) launched and stayed running."
