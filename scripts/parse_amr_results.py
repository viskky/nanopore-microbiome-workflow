#!/usr/bin/env python3
"""
Parse and summarize ABRicate AMR detection results
"""

import pandas as pd
import sys

def parse_abricate(file_path):
    """Parse ABRicate output file"""
    try:
        df = pd.read_csv(file_path, sep='\t')
        if df.empty:
            return pd.DataFrame()
        return df
    except:
        return pd.DataFrame()

def main():
    # Input files from snakemake
    vfdb_file = snakemake.input.vfdb
    plasmidfinder_file = snakemake.input.plasmidfinder
    ncbi_file = snakemake.input.ncbi
    
    # Output file
    output_file = snakemake.output[0]
    
    # Parse all databases
    vfdb_df = parse_abricate(vfdb_file)
    plasmidfinder_df = parse_abricate(plasmidfinder_file)
    ncbi_df = parse_abricate(ncbi_file)
    
    # Add database column
    if not vfdb_df.empty:
        vfdb_df['DATABASE'] = 'VFDB'
    if not plasmidfinder_df.empty:
        plasmidfinder_df['DATABASE'] = 'PlasmidFinder'
    if not ncbi_df.empty:
        ncbi_df['DATABASE'] = 'NCBI'
    
    # Combine results
    combined = pd.concat([vfdb_df, plasmidfinder_df, ncbi_df], ignore_index=True)
    
    if combined.empty:
        # Create empty result file with header
        with open(output_file, 'w') as f:
            f.write("No AMR genes detected\n")
    else:
        # Select and rename columns
        summary = combined[['FILE', 'DATABASE', 'GENE', 'RESISTANCE', 
                           'COVERAGE', 'IDENTITY', 'ACCESSION']]
        summary.to_csv(output_file, sep='\t', index=False)
    
if __name__ == "__main__":
    main()
