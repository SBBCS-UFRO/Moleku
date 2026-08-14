# Moleku Linux release

`Moleku-Linux.AppImage` is distributed as a self-contained AppImage: the user downloads one file, makes it executable, and runs it — no Python, RDKit, or other libraries need to be installed separately, and no root/install step is required.

## Local build

AppImages bundle native Linux binaries, so this has to be built *on Linux*
(a real machine, a VM, WSL2, or a CI runner like `ubuntu-latest` — it cannot
be cross-compiled from macOS or Windows).

Use a dedicated build environment and the shared PyInstaller spec, same as
the other platforms:

```bash
mamba create -y -n mcrg-build -c conda-forge python=3.11 rdkit pandas pillow numpy openpyxl reportlab pyinstaller tk
mamba activate mcrg-build
pip install customtkinter matplotlib
python scripts/generate_icons.py
pyinstaller --clean --noconfirm mcrg.spec
```

For the full build with local ADMET (`admet-ai`, `torch`, `py4j`), install
`torch` from the CPU-only wheel index explicitly. PyPI's default Linux
`torch` wheel pulls in the multi-gigabyte CUDA runtime even though this app
only needs CPU inference — installing plain `torch==2.2.2` here will produce
an AppImage well over GitHub's 2GB release-asset limit:

```bash
pip install "admet-ai==1.3.1" py4j
pip install "torch==2.2.2+cpu" --index-url https://download.pytorch.org/whl/cpu
```

That produces `dist/Moleku/` (onedir folder). Then build the AppImage:

```bash
chmod +x scripts/build_appimage.sh
scripts/build_appimage.sh
```

The script downloads `linuxdeploy` and `appimagetool` on first run (cached
under `dist/.appimage-tools/`), assembles an `AppDir` from `dist/Moleku/`
plus `packaging/linux/Moleku.desktop` and the app icon, and produces
`dist/Moleku-Linux.AppImage`.

If your environment has no FUSE available (common in containers/CI), force
extract-and-run mode instead of mounting:

```bash
export APPIMAGE_EXTRACT_AND_RUN=1
scripts/build_appimage.sh
```

## Smoke test

Tkinter needs a display; on a headless machine/CI, run it under a virtual
one (e.g. Xvfb):

```bash
sudo apt-get install -y xvfb
Xvfb :99 -screen 0 1280x1024x24 &
export DISPLAY=:99
chmod +x scripts/smoke_test_linux_app.sh
scripts/smoke_test_linux_app.sh "dist/Moleku/Moleku"
```

The smoke test launches the frozen binary, checks that the process stays
alive, then stops it.

## Notes

- The AppImage is unsigned; most desktop environments will run it without complaint once it's marked executable (`chmod +x Moleku-Linux.AppImage`).
- `.github/workflows/release.yml` builds this automatically and publishes `Moleku-Linux.AppImage` alongside the macOS/Windows assets whenever a `v*` tag is pushed — no local Linux machine needed for releases.
- **glibc compatibility**: AppImages require a target-system glibc at least as new as the one they were built against. CI intentionally pins the Linux build to the `ubuntu-22.04` runner (glibc 2.35) rather than `ubuntu-latest`, so the AppImage runs on Ubuntu 22.04+, Debian 12+, and comparable distros. Building locally on a newer distro (e.g. Ubuntu 24.04, glibc 2.39) raises that floor and will fail to launch on older-glibc systems with an error like `GLIBC_2.38 not found` — if broad compatibility matters, build on the oldest distro you need to support, not the newest one available.
