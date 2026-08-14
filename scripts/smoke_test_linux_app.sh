#!/usr/bin/env bash
# Smoke test the frozen Linux build: launch the PyInstaller onedir binary
# under a virtual display, verify it stays running, then stop it. Mirrors
# scripts/smoke_test_mac_app.sh / smoke_test_windows_app.ps1. Requires a
# reachable X display (e.g. Xvfb) via $DISPLAY.

set -euo pipefail

BIN_PATH="${1:-dist/Moleku/Moleku}"
if [[ ! -x "${BIN_PATH}" ]]; then
  echo "Executable not found: ${BIN_PATH}"
  exit 1
fi

"${BIN_PATH}" &
PID=$!
sleep 5

if ! kill -0 "${PID}" 2>/dev/null; then
  echo "Smoke test failed: $(basename "${BIN_PATH}") exited early."
  exit 1
fi

kill "${PID}"
sleep 1

echo "Smoke test OK: $(basename "${BIN_PATH}") launched and stayed running."
