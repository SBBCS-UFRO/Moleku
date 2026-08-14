# Changelog

## 1.1.3

- Linux desktop build: `Moleku-Linux.AppImage` (`scripts/build_appimage.sh`, `packaging/linux/Moleku.desktop`), smoke test (`scripts/smoke_test_linux_app.sh`), and packaging docs (`packaging/linux/README.md`).
- `release.yml` now builds Linux on a `ubuntu-latest` runner (under a virtual display via Xvfb) and publishes `Moleku-Linux.AppImage` alongside the macOS/Windows assets — no local Linux machine needed.

## 1.1.2

- Windows installer: `Moleku-Setup-<version>.exe` (Inno Setup), with Start Menu shortcuts, optional desktop icon, per-user or all-users install, and a proper uninstaller. `scripts/build_windows_app.ps1` builds it automatically when Inno Setup is available.
- macOS: `Moleku-macOS.dmg` drag-to-Applications disk image (`scripts/build_mac_dmg.sh`), alongside the existing plain zip.
- `release.yml` builds and publishes both new assets on tagged releases.

## 1.1.1

- Windows desktop build: PyInstaller packaging (`scripts/build_windows_app.ps1`), smoke test, and packaging docs (`packaging/windows/README.md`).
- `release.yml` now builds and publishes `Moleku-Windows.zip` alongside the macOS artifact on tagged releases.

## 1.0.0

- Initial public desktop release of `Moleku`.
- Support for flexible SMILES parsing across canonical, aromatic, stereochemical, and RDKit-compatible CXSMILES styles.
- Native macOS application bundles for both Apple Silicon and Intel.
- Apache 2.0 licensing with bundled `LICENSE` and `NOTICE`.
- Updated in-app `Guide` content, examples, and reaction-ready packs for supported workflows.
- Inline clarification of Ideal criterion and threshold behavior in the engine.
- Integrated `ADMET` tab with local prediction workflow, searchable candidate review, and export support.
- Local `ADMET` runtime packaging fixes for bundled execution on macOS.
- `3D ZIP` and `ADMET CSV` export selection workflows for Ideal sets or manually selected candidates.
- Improved multilingual UI coverage across `Guide` and `ADMET`.
- Publication-oriented exports and reproducible research bundle support.
- Regression tests and packaging scripts for cross-architecture macOS delivery.

