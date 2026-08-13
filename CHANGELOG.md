# Changelog

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

