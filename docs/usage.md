# Usage Guide

## Quick Start

### 1. Prepare Input Data

Place your FASTQ files in `data/raw/`:
```bash
mkdir -p data/raw
cp /path/to/your/sample*.fastq.gz data/raw/
```

### 2. Configure Workflow

Make sure file is renamed as sample1.fastq,...
Edit `config/sample_sheet.csv`:
```csv
sample_id,fastq_file,description
sample1,data/raw/sample1.fastq,Description of sample 1
sample2,data/raw/sample2.fastq,Description of sample 2
```

Edit `config/config.yaml` if needed (optional):
- Adjust thread counts based on your system
- Modify database paths
- Change quality thresholds

### 3. Run Workflow

**Local execution (single machine):**
```bash
snakemake --cores 8 --use-conda
```

**Cluster execution (SLURM):**
```bash
# Create SLURM profile
mkdir -p profiles/slurm

# Edit cluster configuration
nano profiles/slurm/config.yaml

# Run on cluster
snakemake --profile profiles/slurm --jobs 20 --use-conda
```

## Advanced Usage

### Dry Run

Test workflow without executing:
```bash
snakemake -n
```

### Run Specific Rules

Run only quality control:
```bash
snakemake --cores 4 --use-conda results/qc/multiqc_report.html
```

### Resume Failed Run

Snakemake automatically resumes from where it stopped:
```bash
snakemake --cores 8 --use-conda
```

### Clean Results

Remove all output files:
```bash
snakemake clean
```

## SLURM Cluster Configuration

Create `profiles/slurm/config.yaml`:
```yaml
cluster:
  mkdir -p logs/{rule} &&
  sbatch
    --partition={resources.partition}
    --cpus-per-task={threads}
    --mem={resources.mem_mb}
    --time={resources.time}
    --job-name=smk-{rule}-{wildcards}
    --output=logs/{rule}/{rule}-{wildcards}-%j.out
    --error=logs/{rule}/{rule}-{wildcards}-%j.err

default-resources:
  - partition=core
  - mem_mb=16000
  - time="24:00:00"

restart-times: 3
max-jobs-per-second: 10
max-status-checks-per-second: 1
local-cores: 1
latency-wait: 60
jobs: 100
keep-going: True
rerun-incomplete: True
printshellcmds: True
use-conda: True
```

## Resource Requirements

### Minimum Requirements
- CPU: 8 cores
- RAM: 32 GB
- Storage: 100 GB

### Recommended for Large Datasets
- CPU: 32+ cores
- RAM: 128+ GB
- Storage: 500 GB+

### Per-Sample Processing Time
- Quality control: 10-30 minutes
- Assembly: 1-4 hours
- Annotation: 30-60 minutes
- AMR detection: 5-15 minutes
- Taxonomic classification: 30-90 minutes

**Total per sample: 3-8 hours** (depending on data size and computing resources)

## Monitoring Progress

### Check workflow status
```bash
snakemake --summary
```

### View log files
```bash
tail -f results/logs/flye/sample1.log
```

### Check SLURM jobs
```bash
squeue -u $USER
```

## Troubleshooting

### Out of Memory Errors

Increase memory in config:
```yaml
resources:
  max_memory_gb: 256
```

### Timeout on Cluster

Increase time limits in SLURM profile or config.yaml

### Database Not Found

Ensure databases downloaded:
```bash
bash resources/databases/download_databases.sh
```

### Conda Environment Issues

Recreate environment:
```bash
conda env remove -n nanopore-workflow
conda env create -f environment.yml
```

## Output Files

All results are in `results/` directory:
