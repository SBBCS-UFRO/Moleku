#!/usr/bin/env bash
# Package a built Moleku.app into a friendly drag-to-Applications .dmg.
# Run scripts/build_mac_app.sh first to produce the .app bundle.

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script only runs on macOS (needs hdiutil)."
  exit 1
fi

APP_PATH="${1:-dist/Moleku.app}"
DMG_PATH="${2:-dist/Moleku-macOS.dmg}"
VOL_NAME="${MOLEKU_DMG_VOLNAME:-Moleku}"

if [[ ! -d "$APP_PATH" ]]; then
  echo "App bundle not found: $APP_PATH"
  echo "Build it first: PYTHON=... bash scripts/build_mac_app.sh"
  exit 1
fi

STAGE_DIR="$(mktemp -d)"
trap 'rm -rf "$STAGE_DIR"' EXIT

cp -R "$APP_PATH" "$STAGE_DIR/"
ln -s /Applications "$STAGE_DIR/Applications"

rm -f "$DMG_PATH"
hdiutil create -volname "$VOL_NAME" -srcfolder "$STAGE_DIR" -ov -format UDZO "$DMG_PATH"

echo ""
echo "Listo: $ROOT/$DMG_PATH"
