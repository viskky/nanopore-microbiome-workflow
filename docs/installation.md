# Installation Guide

## Prerequisites

- Linux/Unix operating system (tested on Ubuntu 20.04/22.04)
- Conda or Mamba package manager
- 100+ GB free disk space
- Internet connection for database downloads

## Step 1: Install Conda/Mamba

If you don't have Conda installed:
```bash
# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc

# Install Mamba (faster than conda)
conda install -n base -c conda-forge mamba
```

## Step 2: Clone Repository
```bash
git clone https://github.com/{yourusername}/nanopore-workflow.git
cd nanopore-workflow
```

## Step 3: Create Conda Environment
```bash
# Create environment from file
conda env create -f environment.yml -n nanopore-workflow

# Activate environment
conda activate nanopore-workflow

# Verify installation
snakemake --version
```

## Step 4: Download Databases

**Warning**: This will download ~50GB of data and may take several hours.
```bash
bash install_database.sh
```

### Manual Database Setup (if automatic download fails)

**Kraken2 Database:**
```bash
mkdir -p resources/databases/kraken2_standard
kraken2-build --standard --db resources/databases/kraken2_standard --threads 8
```

**ABRicate Databases:**
```bash
abricate --setupdb
abricate --list
```

**Phage HMM Profiles:**

```
Place your Protein (Domain/Family) HMM file in the directory resources/databases/
```

## Step 5: Test Installation
```bash
# Dry run to test workflow
snakemake -n

# Run with test data (if available)
snakemake --cores 2 --use-conda
```

## Troubleshooting

### Issue: Conda environment creation fails

**Solution**: Try creating environment with mamba:
```bash
mamba env create -f environment.yml -n nanopore-workflow
```

### Issue: Database download fails

**Solution**: Download databases manually following instructions above.

### Issue: Permission denied errors

**Solution**: Ensure you have write permissions:
```bash
chmod +x resources/databases/download_databases.sh
chmod +x scripts/*.py
chmod +x scripts/*.R
```

## HPC-Specific Installation

If running on an HPC cluster:
```bash
# Load required modules
module load conda
module load snakemake

# Create environment in your home directory
conda env create -f environment.yml --prefix $HOME/conda/envs/nanopore-workflow

# Activate
conda activate $HOME/conda/envs/nanopore-workflow
```

## Verification

Verify all tools are installed:
```bash
fastqc --version
porechop --version
flye --version
prokka --version
abricate --version
kraken2 --version
```

All commands should return version numbers without errors.
