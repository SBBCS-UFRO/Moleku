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
  <a href="https://github.com/SBBCS-UFRO/Moleku/releases">
    <img alt="Release" src="https://img.shields.io/github/v/release/SBBCS-UFRO/Moleku?display_name=tag">
  </a>
  <a href="https://doi.org/10.5281/zenodo.22255681">
    <img alt="DOI" src="https://zenodo.org/badge/DOI/10.5281/zenodo.22255681.svg">
  </a>
  <img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-white">
  <img alt="Python" src="https://img.shields.io/badge/Python-3.11-3776AB">
  <img alt="Platforms" src="https://img.shields.io/badge/platform-Windows%20%7C%20macOS%20%7C%20Linux-lightgrey">
</p>

<p align="center">
  <a href="https://github.com/SBBCS-UFRO/Moleku">Repository</a> ·
  <a href="https://github.com/SBBCS-UFRO/Moleku/releases">Releases</a> ·
  <a href="https://doi.org/10.5281/zenodo.22255681">Zenodo</a> ·
  <a href="https://github.com/SBBCS-UFRO/Moleku/issues">Issues</a> ·
  <a href="CITATION.cff">Citation</a>
</p>

---

# Moleku

**Moleku** is an open-source desktop cheminformatics platform for reproducible virtual library generation and early-stage molecular prioritization through **multicomponent reactions (MCRs)**.

The software integrates reaction-centered enumeration with practical cheminformatics utilities in a single graphical environment. Its purpose is to reduce fragmented workflows based on scripts, notebooks, spreadsheets, and external services while preserving a traceable record of generated candidates, excluded attempts, prioritization decisions, and exported results.

Moleku **1.0.0** includes three curated three-component MCR workflows:

| Workflow | Short name | Role in Moleku |
| --- | --- | --- |
| Biginelli reaction | **Biginelli** | Virtual library generation using the implemented Biginelli transformation |
| Groebke–Blackburn–Bienaymé reaction | **GBB** | Virtual library generation using the implemented GBB transformation |
| Gewald reaction | **Gewald** | Virtual library generation using the implemented Gewald transformation |

> **Scientific scope.** Moleku performs deterministic **in silico** enumeration using curated reaction SMARTS. A generated and RDKit-sanitized product is not evidence of experimental reaction success, synthetic feasibility, reaction yield, biological activity, or wet-lab validation.

## Key features

- Desktop graphical workflow for virtual library generation without routine scripting.
- Curated Biginelli, GBB, and Gewald reaction workflows.
- Input quality control for tabular reagent libraries and SMILES.
- Auditable enumeration retaining successful and unsuccessful reaction attempts.
- Molecular standardization before descriptor and identifier calculations.
- Physicochemical characterization including MW, LogP, TPSA, HBA, HBD, QED, Fsp3, rotatable bonds, heavy atoms, ring count, molar refractivity, and stereochemical metadata.
- Drug-likeness rules including Lipinski, Ghose, Veber, Egan, and Muegge.
- PAINS and Brenk structural-alert assessment.
- Moleku heuristic physicochemical prioritization score.
- First-seen InChIKey-based duplicate tracking.
- Integrated local ADMET analysis through ADMET-AI.
- Research-oriented export and reproducibility bundles.
- Packaged Windows, macOS, and Linux release assets.

## Software workflow

```text
Reactant tables / SMILES
          │
          ▼
     Input quality control
          │
          ▼
 Select reaction workflow
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

The complete evaluated library is retained for auditability, while prioritized views are available for candidate inspection and downstream analysis.

## Main workspaces

### Engine

The **Engine** workspace handles reaction selection, reagent loading, input quality control, combinatorial enumeration, product standardization, descriptor calculation, prioritization, and classification.

### Results

The **Results** workspace provides complete and prioritized result tables, search and filtering, 2D structure inspection, physicochemical descriptors, stereochemical metadata, InChIKey identifiers, duplicate tracking, Ideal / Discard / All views, exploratory visualizations, and export controls.

### ADMET

The **ADMET** workspace supports pasted SMILES, import from the Results workspace, selected-structure inspection, local prediction, metadata merging, and tabular or structure-oriented export.

### Guide and About

Integrated **Guide** and **About** sections provide in-application usage guidance, software information, and project context.

## Input format

Reaction components are imported from tabular files containing molecular identifiers and SMILES. At minimum, reaction-ready tables should provide:

```text
NAME
SMILES
```

Moleku treats **SMILES syntactic validity** and **reaction-template compatibility** as separate criteria. A parseable molecule may therefore still be incompatible with a selected reaction SMARTS.

Example input packs and templates are maintained in:

```text
examples/
```

## Candidate prioritization

Successfully generated products can be evaluated using Lipinski, Ghose, Veber, Egan, and Muegge drug-likeness rules, including aggregate Any / All logic.

### Moleku heuristic physicochemical prioritization score

For a successfully generated and sanitized product, RDKit-derived MW, MolLogP, and TPSA are first rounded to two decimal places. Moleku 1.0.0 then evaluates:

```text
S = clip[0,100](
    round(
        100
        - 0.05 × |MW - 350|
        - 8 × |MolLogP - 2.5|
        - 0.10 × |TPSA - 90|,
        1
    )
)
```

The score is an author-defined deterministic **heuristic physicochemical prioritization measure**. It is not a probability, reaction-compatibility measure, reaction-yield predictor, synthetic-feasibility score, biological-activity predictor, ADMET score, toxicity predictor, or experimental-success estimate.

## Integrated local ADMET

Moleku 1.0.0 integrates **ADMET-AI 1.3.1** through its local in-process Python API.

The frozen macOS integration audit used:

| Component | Frozen value |
| --- | --- |
| Moleku | 1.0.0 |
| Python | 3.11.16 |
| ADMET-AI | 1.3.1 |
| Chemprop | 1.6.1 |
| Chemfunc | 1.0.12 |
| PyTorch | 2.2.2 |
| RDKit | 2026.03.1 |
| SciPy | 1.13.1 |
| scikit-learn | 1.9.0 |
| pandas | 2.1.4 |
| NumPy | 1.26.4 |

The frozen backend exposes 31 classification endpoints, 10 regression endpoints, and eight RDKit physicochemical descriptors: **49 distinct property values** in total. ADMET-AI also returns one DrugBank-approved reference percentile for each property, producing **98 numeric backend columns**.

The 98 columns are therefore not 98 independent predictive models.

The audited integration runs locally, does not require a web API, and preserves backend numeric values without Moleku-side rounding or numeric transformation.

ADMET outputs are intended for **in silico prioritization** and do not constitute experimental confirmation of pharmacokinetic or toxicological behavior.

## Validation summary

### Chemical correctness

```text
Biginelli: 5 reference transformations
GBB:       5 reference transformations
Gewald:    5 reference transformations
Total:    15 / 15 exact standard InChIKey matches
```

### Cross-platform reproducibility

The controlled reference panel produced identical structural outputs across the tested Windows, macOS, and Linux environments.

### Biginelli end-to-end evaluation

The frozen manuscript-scale Biginelli experiment evaluated **1,680 combinations**.

| Quantity | Count |
| --- | ---: |
| Attempted combinations | 1,680 |
| Generated and RDKit-sanitized products | 588 |
| Reaction-template non-generation outcomes | 1,092 |
| Ideal before deduplication | 573 |
| Generated products rejected by Lipinski | 15 |
| Duplicate generated rows | 21 |
| Unique prioritized Ideal candidates | 552 |
| Descriptor errors | 0 |

The 1,092 non-generation outcomes corresponded exactly to combinations containing historically retained second-slot candidate/control entries that were incompatible with the implemented Biginelli reaction template.

### ADMET integration reproducibility

A frozen five-compound probe was evaluated through the direct ADMET-AI backend and the Moleku integration layer. Moleku preserved the backend numeric output exactly, with a maximum absolute difference of **0.0**. A second independently initialized model instance reproduced the same predictions exactly.

### Related-software evaluation

Moleku was evaluated alongside **RDKit** as a technical enumeration baseline, **DataWarrior** as a graphical functional comparison, and **Synt-On** as a complementary synthon-centered workflow. These comparisons characterize workflow behavior and implementation differences and are not claims of universal superiority.

## Desktop releases

Packaged Moleku 1.0.0 builds are available from the GitHub [Releases](https://github.com/SBBCS-UFRO/Moleku/releases) page for:

- Windows
- macOS
- Linux

Desktop release packages bundle the runtime components required by their corresponding platform.

## Source installation

For source-based use, a Python 3.11 environment is recommended. A conda-forge environment is preferred because RDKit packaging varies between operating systems.

```bash
mamba create -y -n moleku -c conda-forge   python=3.11 rdkit pandas pillow numpy openpyxl reportlab

mamba activate moleku
pip install customtkinter matplotlib
```

For local ADMET functionality:

```bash
pip install admet-ai
```

Clone the repository:

```bash
git clone https://github.com/SBBCS-UFRO/Moleku.git
cd Moleku
```

Launch Moleku:

```bash
python mcrg_desktop.py
```

## Building

Moleku uses PyInstaller for packaged desktop distributions. The repository includes:

```text
mcrg.spec
```

General local build:

```bash
pyinstaller --clean --noconfirm mcrg.spec
```

For normal use, prefer the packaged assets distributed with the official GitHub release.

## Export formats

Depending on the active workflow and workspace, Moleku supports research-oriented exports including:

- CSV
- XLSX
- PDF
- PNG
- SVG
- SDF
- ZIP
- 3D conformer bundles
- Research Bundles

Research Bundles are designed to preserve provenance information such as run parameters, environment metadata, input hashes, and output artifacts.

## Citation

If you use **Moleku 1.0.0** in academic work, please cite the archived software release:

> **Moleku 1.0.0.** Zenodo. https://doi.org/10.5281/zenodo.22255681

Formal machine-readable citation metadata are provided in [`CITATION.cff`](CITATION.cff).

**Version-specific DOI:** https://doi.org/10.5281/zenodo.22255681  
**All-versions DOI:** https://doi.org/10.5281/zenodo.22255680

For reproducibility of the software version evaluated in a manuscript or analysis, cite the **version-specific DOI**.

## Authors

The current v1.0.0 Zenodo creator order is:

1. **Felipe Lizama**
2. **Carolyn Mayer**
3. **Carlos Arias**
4. **Daniel Ulloa**
5. **Abdiel Barra**
6. **Alejandro Castro-Alvarez**

Formal affiliations are maintained in [`CITATION.cff`](CITATION.cff).

## Funding

This work was supported by the **Agencia Nacional de Investigación y Desarrollo (ANID), Chile**, through **FONDECYT Regular Project 1251443**.

## Acknowledgements

The authors acknowledge **Universidad de La Frontera (UFRO)**, the **Laboratory of Structural Bioinformatics and Bioactive Compound Synthesis**, the **Center of Excellence in Translational Medicine (CEMT)**, the **Millennium Nucleus Bioproducts, Genomics and Environmental Microbiology (BioGEM)**, the **National Laboratory for High Performance Computing (NLHPC), Chile**, and the **Agencia Nacional de Investigación y Desarrollo (ANID), Chile**.

NLHPC provided access to high-performance computing infrastructure and server resources supporting computational stages of the project.

## License

Moleku is distributed under the **Apache License 2.0**.

See [`LICENSE`](LICENSE) and [`NOTICE`](NOTICE) for the complete terms and attribution information.

## Contact

For software issues, bug reports, or feature requests:

- [GitHub Issues](https://github.com/SBBCS-UFRO/Moleku/issues)

Scientific correspondence:

- **Alejandro Castro-Alvarez** — `alejandro.castro.a@ufrontera.cl`

Repository:

- https://github.com/SBBCS-UFRO/Moleku

Zenodo:

- https://doi.org/10.5281/zenodo.22255681

---

<p align="center">
  <strong>Moleku 1.0.0</strong><br>
  Reproducible MCR-based virtual library generation and molecular prioritization.
</p>
