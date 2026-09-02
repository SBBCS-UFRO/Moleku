<p align="center">
  <img src="images/moleku_logo.png" alt="Moleku" width="760">
</p>

<p align="center">
  <strong>Reproducible virtual library generation and prioritization through multicomponent reactions.</strong>
</p>

<p align="center">
  Open-source desktop cheminformatics software for reaction-based molecular enumeration,
  physicochemical prioritization, local ADMET analysis, and research-ready export.
</p>

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/version-v1.0.0-ff7a00">
  <img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-white">
  <img alt="Python" src="https://img.shields.io/badge/Python-3.11-3776AB">
  <img alt="Platforms" src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey">
  <img alt="MCR workflows" src="https://img.shields.io/badge/MCR%20workflows-3-ff7a00">
</p>

<p align="center">
  <a href="https://github.com/pipelzm/Moleku">Repository</a>
  ·
  <a href="https://sbbcs-ufro.github.io/moleku-page/">Website</a>
  ·
  <a href="https://github.com/pipelzm/Moleku/issues">Issues</a>
  ·
  <a href="CITATION.cff">Citation</a>
</p>

---

# Moleku

**Moleku** is an open-source desktop platform for reproducible virtual library generation and early-stage molecular prioritization through **multicomponent reactions (MCRs)**.

The software integrates reaction-centered enumeration with practical cheminformatics utilities in a single graphical environment. Its purpose is to reduce fragmented workflows built from scripts, notebooks, spreadsheets, and external services while preserving a traceable record of both generated candidates and excluded reaction attempts.

Moleku v1.0.0 focuses on three curated three-component reaction workflows:

| Workflow | Short name | Role in Moleku |
| --- | --- | --- |
| Biginelli reaction | **Biginelli** | Dihydropyrimidinone/thione-oriented virtual library generation |
| Groebke–Blackburn–Bienaymé reaction | **GBB** | Imidazo-fused heterocycle-oriented virtual library generation |
| Gewald reaction | **Gewald** | Aminothiophene-oriented virtual library generation |

> Moleku performs deterministic **in silico** enumeration using curated reaction SMARTS. A generated and RDKit-sanitized product must not be interpreted as experimental reaction success, synthetic feasibility, reaction yield, biological activity, or experimental validation.

## Highlights

- **Desktop-first workflow** — graphical operation without requiring users to maintain code for routine enumeration.
- **Reaction-centered generation** — curated Biginelli, GBB, and Gewald workflows.
- **Input quality control** — reagent-table parsing, SMILES checks, and explicit handling of incompatible inputs.
- **Auditable enumeration** — complete attempted-library records with generated products and explicit failure reasons.
- **Molecular standardization** — cleanup, parent-fragment selection, neutralization, and sanitization where applicable.
- **Physicochemical characterization** — MW, LogP, TPSA, HBA, HBD, QED, Fsp3, rotatable bonds, heavy atoms, ring count, molar refractivity, and related metadata.
- **Drug-likeness rules** — Lipinski, Ghose, Veber, Egan, Muegge, and configurable aggregate logic.
- **Structural alerts** — PAINS and Brenk assessments.
- **Heuristic prioritization** — the **Moleku heuristic physicochemical prioritization score** for internal candidate ranking.
- **Duplicate detection** — first-seen InChIKey-based tracking while preserving the complete audit table.
- **Integrated local ADMET** — ADMET-AI-based prediction without a web API in the audited v1.0.0 macOS bundle.
- **Research-ready export** — tabular, structure, figure, report, conformer, and bundled outputs with provenance metadata.

---

## Software workflow

```text
Reactant tables / SMILES
          │
          ▼
     Input quality control
          │
          ▼
 Select MCR workflow
 Biginelli / GBB / Gewald
          │
          ▼
 Cartesian enumeration
          │
          ▼
 Reaction SMARTS + RDKit
          │
          ├──────────────► explicit non-generation / failure record
          │
          ▼
 Generated + sanitized product
          │
          ▼
 Standardization + descriptors
          │
          ▼
 Drug-likeness rules + alerts
          │
          ▼
 Moleku heuristic prioritization
          │
          ▼
 InChIKey deduplication
          │
          ▼
 Results / ADMET / export
```

The complete evaluated library is retained for auditability; prioritized views are provided for candidate inspection and downstream analysis.

---

## Main workspaces

### Engine

The **Engine** workspace handles reaction configuration, reagent loading, quality control, combinatorial enumeration, standardization, and candidate classification.

### Results

The **Results** workspace provides:

- complete and prioritized result tables
- search and filtering
- 2D molecular structure inspection
- calculated physicochemical descriptors
- stereochemical metadata
- InChIKey identifiers and duplicate tracking
- Ideal / Discard / All views
- exploratory visualizations
- export controls

### ADMET

The **ADMET** workspace enables users to:

- paste SMILES directly
- import candidates from the Results workspace
- inspect a selected molecular structure
- run local ADMET predictions
- search previously analyzed candidates
- merge predictions with Moleku candidate metadata
- export ADMET tables for downstream analysis

### Guide and About

Integrated **Guide** and **About** workspaces provide in-application usage guidance, software information, and project context.

---

## Input format

Reaction components are loaded from tabular files containing, at minimum:

```text
NAME
SMILES
```

Supported tabular input paths in the application include formats such as CSV, TXT, XLSX, and other supported spreadsheet-compatible sources.

Before enumeration, Moleku performs input quality control. Syntactically valid SMILES and compatibility with a specific reaction template are treated as separate criteria.

Example datasets and reaction-ready templates are available in:

```text
examples/
```

---

## Candidate prioritization

For successfully generated products, Moleku calculates common physicochemical descriptors and supports configurable drug-likeness rules:

- Lipinski
- Ghose
- Veber
- Egan
- Muegge
- aggregate Any / All logic

### Moleku heuristic physicochemical prioritization score

Moleku v1.0.0 includes an author-defined deterministic score for internal prioritization:

```text
S = clip[0,100](
    100
    - 0.05 × |MW - 350|
    - 8 × |LogP - 2.5|
    - 0.10 × |TPSA - 90|
)
```

The implementation uses the frozen v1.0.0 rounding procedure and applies an explicit user-defined threshold before the selected drug-likeness rule.

The score is a **heuristic physicochemical prioritization measure**. It is not a probability, reaction-yield predictor, synthetic-feasibility score, biological-activity predictor, ADMET score, or experimentally calibrated model.

---

## Integrated local ADMET

Moleku v1.0.0 integrates **ADMET-AI 1.3.1** through the local in-process Python API.

The audited v1.0.0 macOS integration contains:

| Component | Audited value |
| --- | --- |
| ADMET-AI | 1.3.1 |
| Chemprop | 1.6.1 |
| Chemfunc | 1.0.12 |
| PyTorch | 2.2.2 |
| RDKit | 2026.03.1 |
| pandas | 2.1.4 |
| NumPy | 1.26.4 |

The frozen integration exposes:

- **31 classification endpoints**
- **10 regression endpoints**
- **8 RDKit physicochemical descriptors**
- **49 distinct properties in total**
- **49 corresponding DrugBank-approved reference percentiles**

This produces **98 numeric backend columns**, which must not be interpreted as 98 independent machine-learning models.

In the audited macOS bundle, execution was local and CPU-based. Moleku preserved the backend numeric predictions exactly and did not apply explicit numeric rounding before export.

ADMET outputs are intended for **in silico prioritization** and do not constitute experimental confirmation of pharmacokinetic or toxicological properties.

---

## Scientific and software validation

Moleku v1.0.0 has been evaluated using complementary software-centered tests.

### Chemical correctness

A controlled reference panel covered all three supported reaction workflows:

```text
Biginelli: 5 reference transformations
GBB:       5 reference transformations
Gewald:    5 reference transformations
Total:    15 / 15 exact standard InChIKey matches
```

### Cross-platform reproducibility

The controlled 15-case panel was reproduced on Windows, macOS, and Linux, yielding identical structural outputs for all tested products.

### Biginelli end-to-end evaluation

The frozen manuscript-scale Biginelli experiment evaluated **1,680 combinations**.

| Quantity | Count |
| --- | ---: |
| Attempted combinations | 1,680 |
| Generated and RDKit-sanitized products | 588 |
| Template non-generation outcomes | 1,092 |
| Ideal before deduplication | 573 |
| Generated products rejected by Lipinski | 15 |
| Duplicate generated rows | 21 |
| Unique prioritized Ideal candidates | 552 |
| Descriptor errors | 0 |

The 1,092 non-generation outcomes corresponded exactly to combinations containing historically retained second-slot candidate/control entries that were incompatible with the implemented Biginelli reaction template.

### Related-software evaluation

Moleku has also been evaluated alongside:

- **RDKit** as a direct technical reaction-enumeration baseline
- **DataWarrior** as a graphical functional comparison
- **Synt-On** as a synthon-centered complementary workflow

These comparisons characterize implementation behavior and workflow differences rather than claim universal superiority over other cheminformatics tools.

---

## Requirements

### Desktop builds

Moleku is being packaged as a desktop application for:

- Windows
- macOS
- Linux

The final v1.0.0 release assets will be published under the GitHub **Releases** section after the platform-specific builds and checks are completed.

### Source / development environment

Because RDKit packaging varies across operating systems, a conda-forge environment is recommended.

```bash
mamba create -y -n moleku -c conda-forge \
  python=3.11 rdkit pandas pillow numpy openpyxl reportlab

mamba activate moleku

pip install customtkinter matplotlib
```

For local ADMET functionality:

```bash
pip install admet-ai
```

Clone the repository:

```bash
git clone https://github.com/pipelzm/Moleku.git
cd Moleku
```

Launch from source:

```bash
python mcrg_desktop.py
```

---

## Building the desktop application

The repository includes a PyInstaller specification:

```text
mcrg.spec
```

General local build:

```bash
pyinstaller --clean --noconfirm mcrg.spec
```

Platform-specific packaging helpers are maintained under:

```text
packaging/
scripts/
.github/workflows/
```

End users should prefer the signed/packaged assets published through GitHub Releases rather than building from source unless development or reproducibility work requires it.

---

## Export formats

Depending on the active workspace, Moleku supports research-oriented exports including:

- CSV
- XLSX
- PDF
- PNG
- SVG
- SDF
- ZIP conformer bundles
- Research Bundles

Research Bundles are intended to preserve provenance information such as run parameters, environment metadata, input hashes, and output artifacts.

---

## Repository structure

```text
Moleku/
├── .github/
│   └── workflows/
├── examples/
├── images/
│   └── moleku_logo.png
├── mcrg/
├── packaging/
├── scripts/
├── tests/
├── CHANGELOG.md
├── CITATION.cff
├── CONTRIBUTING.md
├── LICENSE
├── METHODS.md
├── NOTICE
├── QUICKSTART.md
├── README.md
├── SECURITY.md
├── TROUBLESHOOTING.md
├── mcrg.spec
├── mcrg_desktop.py
├── mcrg_entry.py
└── pyproject.toml
```

---

## Documentation

Additional documentation is maintained in the repository:

- [`QUICKSTART.md`](QUICKSTART.md) — condensed startup guide
- [`METHODS.md`](METHODS.md) — computational and methodological overview
- [`TROUBLESHOOTING.md`](TROUBLESHOOTING.md) — installation and runtime troubleshooting
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — contribution guidance
- [`SECURITY.md`](SECURITY.md) — security reporting policy
- [`CHANGELOG.md`](CHANGELOG.md) — version history

---

## Citation

If you use Moleku in academic work, please cite the software using the metadata in [`CITATION.cff`](CITATION.cff).

The definitive public release is intended to be:

```text
Moleku v1.0.0
```

A version-specific Zenodo DOI should be added to `CITATION.cff` after the v1.0.0 archival record is created.

The associated software manuscript is currently in preparation.

---

## Authors

Moleku v1.0.0 is associated with the following current manuscript author list:

1. **Felipe Lizama**
2. **Carlos Arias**
3. **Abdiel Barra**
4. **Carolyn Mayer**
5. **Daniel Ulloa**
6. **Alejandro Castro-Alvarez**

Author affiliations and citation metadata are maintained in [`CITATION.cff`](CITATION.cff).

---

## Funding

This work is supported by the **Agencia Nacional de Investigación y Desarrollo (ANID), Chile**, through **FONDECYT Regular Project 1251443**.

---

## Acknowledgements

The authors acknowledge:

- **Universidad de La Frontera (UFRO)**
- **Laboratory of Structural Bioinformatics and Bioactive Compound Synthesis**
- **Center of Excellence in Translational Medicine (CEMT)**
- **Millennium Nucleus Bioproducts, Genomics and Environmental Microbiology (BioGEM)**
- **National Laboratory for High Performance Computing (NLHPC), Chile**
- **Agencia Nacional de Investigación y Desarrollo (ANID), Chile**

NLHPC provided access to high-performance computing infrastructure and server resources used during computational stages of the project.

---

## License

Moleku is distributed under the **Apache License 2.0**.

See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) for the complete terms and attribution information.

---

## Contact

For software issues, bug reports, or feature requests:

- [GitHub Issues](https://github.com/pipelzm/Moleku/issues)

Scientific correspondence:

- **Alejandro Castro-Alvarez** — `alejandro.castro.a@ufrontera.cl`

Project links:

- Repository: https://github.com/pipelzm/Moleku
- Website: https://sbbcs-ufro.github.io/moleku-page/

---

<p align="center">
  <strong>Moleku v1.0.0</strong><br>
  Reproducible MCR-based virtual library generation and molecular prioritization.
</p>
