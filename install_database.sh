#!/bin/bash
# Download required databases for the workflow

set -e

echo "======================================"
echo "Downloading Required Databases"
echo "======================================"

# Create database directory
mkdir -p resources/databases/kraken2_standard
# Create database directory
# 1. Download MiniKraken2 standard database (8GB)
echo "Downloading MiniKraken2 standard database..."

wget ftp://ftp.ccb.jhu.edu/pub/data/kraken2_dbs/old/minikraken2_v2_8GB_201904.tgz -P resources/databases/kraken2_standard #download the database

echo "======================================"
echo "COMPLETED DOWNLOAD"
echo "======================================"

tar xfvz resources/databases/kraken2_standard/minikraken2_v2_8GB_201904.tgz -C resources/databases/kraken2_standard/ --strip-components=1

echo "======================================"
echo "Downloading Required Databases"
echo "======================================"

rm -fr resources/databases/kraken2_standard/minikraken2_v2_8GB_201904.tgz

# 2. Update ABRicate databases
echo "Updating ABRicate databases..."
abricate --setupdb
abricate-get_db --db card --force
abricate-get_db --db resfinder --force
abricate-get_db --db ncbi --force
echo "✓ ABRicate databases updated"

# 3. Download Krona taxonomy
echo "Updating Krona taxonomy..."
ktUpdateTaxonomy.sh
echo "✓ Krona taxonomy updated"

echo "======================================"
echo "All databases downloaded successfully!"
echo "======================================"
echo ""
echo "Database sizes:"
du -sh resources/databases/kraken2_standard
echo ""
echo "You can now run the workflow."
##Place your HMM files in "resources/databases"
