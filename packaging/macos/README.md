# Moleku macOS release

`Moleku.app` is distributed as a portable macOS app bundle: no Python, RDKit, or other libraries need to be installed separately. Two distribution formats are produced from the same `.app`:

- `Moleku-macOS.dmg` — a disk image with `Moleku.app` next to an `Applications` symlink, for the familiar drag-to-Applications install. This is the recommended download for most users.
- `Moleku-macOS.zip` — a plain zip of the `.app`, for users who prefer to place it wherever they like without mounting a disk image.

An Intel variant is also available:

- `Moleku-macOS-x86_64.zip` for Intel Macs (built separately, see below)

## Local build

Use the dedicated build environment and PyInstaller spec:

```bash
PYTHON=/opt/anaconda3/envs/mcrg-build/bin/python bash "scripts/build_mac_app.sh"
```

The script also auto-detects the `mcrg-build` conda environment when it exists, so the older command below is accepted as well:

```bash
conda run -n mcrg-build env PYTHON=python bash "scripts/build_mac_app.sh"
```

That produces:

- `dist/Moleku.app`
- `dist/Moleku/` (onedir folder used by the `.app` bundle)

## Intel build from Apple Silicon

If you are on an Apple Silicon Mac and want an Intel-compatible bundle for older Macs, use:

```bash
chmod +x scripts/build_mac_intel_from_arm.sh
scripts/build_mac_intel_from_arm.sh
```

That script:

- creates an `osx-64` conda environment under Rosetta
- builds the `x86_64` PyInstaller `onedir`
- assembles `dist/Moleku-macOS-x86_64.app`
- packages `dist/Moleku-macOS-x86_64.zip`

If you are already on an Intel Mac, use `scripts/build_mac_app.sh` directly.

## Smoke test

Validate the double-click path on macOS before packaging:

```bash
chmod +x scripts/smoke_test_mac_app.sh
scripts/smoke_test_mac_app.sh "dist/Moleku.app"
```

The smoke test launches the bundle through LaunchServices, checks that the `Moleku` process stays alive, then quits it cleanly.

## DMG packaging

Create the drag-to-Applications disk image with:

```bash
chmod +x scripts/build_mac_dmg.sh
scripts/build_mac_dmg.sh "dist/Moleku.app" "dist/Moleku-macOS.dmg"
```

This wraps the `.app` in a staging folder next to an `Applications` symlink and calls `hdiutil create` (native to macOS, no extra tools needed).

## Zip packaging

Create the plain-zip artifact with:

```bash
cd dist
ditto -c -k --sequesterRsrc --keepParent "Moleku.app" "Moleku-macOS.zip"
```

For the Intel bundle:

```bash
cd dist
ditto -c -k --sequesterRsrc --keepParent "Moleku-macOS-x86_64.app" "Moleku-macOS-x86_64.zip"
```

## Security policy

- Default local builds are ad-hoc signed by PyInstaller and are suitable for internal testing or direct sharing.
- The Intel bundle assembled from `onedir` opens correctly via LaunchServices on Apple Silicon test machines, but `codesign --verify --strict` may still be less clean than a fully native PyInstaller-generated `.app`.
- Gatekeeper assessment (`spctl`) will reject the app until it is signed with a Developer ID certificate and notarized by Apple.
- For public distribution, enable the existing codesign/notarization block in `.github/workflows/release.yml` by configuring:
  - `MACOS_SIGN_IDENTITY`
  - `MACOS_CERT_P12`
  - `MACOS_CERT_PASSWORD`
  - `APPLE_ID`
  - `APPLE_APP_SPECIFIC_PASSWORD`
  - `APPLE_TEAM_ID`

Without notarization, users may need to use right click > Open the first time.
