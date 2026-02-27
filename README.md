# Nanopore Microbiome Analysis Workflow

[![Snakemake](https://img.shields.io/badge/snakemake-≥7.0.0-brightgreen.svg)](https://snakemake.readthedocs.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platform](https://img.shields.io/badge/platform-linux-lightgrey)

## Overview

An automated Snakemake workflow for comprehensive analysis of nanopore-sequenced microbiome data, including:
- **Quality Control** (FastQC)
- **Adapter Trimming** (Porechop)
- **Genome Assembly** (Flye/MEGAHIT)
- **Assembly Quality Assessment** (QUAST)
- **Gene Annotation** (Prokka)
- **Antimicrobial Resistance (AMR) Detection** (ABRicate)
- **Phage-like Protein Detection** (HMMsearch)
- **Taxonomic Classification** (Kraken2)
- **Interactive Visualization** (KronaTools)

## Features

-  Fully automated workflow from FASTQ to results
-  Parallel processing for multiple samples
-  Conda environment management
-  HPC cluster support (SLURM)
-  Comprehensive quality control
-  Reproducible and version-controlled

## Quick Start
```bash
# Clone repository
git clone https://github.com/viskky/nanopore-workflow.git
cd nanopore-workflow

# Create conda environment
conda env create -f environment.yml -n nanopore-workflow
conda activate nanopore-workflow

# Download required databases
bash install_database.sh

# Edit configuration
nano config/config.yaml
nano config/sample_sheet.csv

# Run workflow (local)
snakemake --cores 8 --use-conda

# Run workflow (SLURM cluster)
snakemake --profile slurm --jobs 20 --use-conda
```

## Requirements

- Conda/Mamba
- Snakemake ≥7.0.0
- 50+ GB disk space for databases
- HPC cluster with SLURM (optional but recommended)

## Installation

See [installation.md](docs/installation.md) for detailed instructions.

## Usage

See [usage.md](docs/usage.md) for detailed usage instructions.

## Output

See [Results](results/) for detailed usage instructions


## License

MIT License - see [LICENSE](LICENSE) file.

## Contact

**Author**: Victor Betiku  
**Email**: victor.obetiku@gmail.com  
**GitHub**: [@viskky](https://github.com/viskky)

## Acknowledgments

Developed at Lund University for nanopore-based microbiome analysis.
