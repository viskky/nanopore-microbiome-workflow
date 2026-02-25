#!/usr/bin/env python3
"""
Combine individual sample reports into a single summary file
"""

import pandas as pd
import argparse
import sys

def combine_amr_reports(input_files, output_file):
    """Combine AMR detection reports"""
    dfs = []
    
    for file in input_files:
        try:
            df = pd.read_csv(file, sep='\t')
            if not df.empty:
                # Extract sample name from file path
                sample = file.split('/')[-1].replace('_amr_summary.tsv', '')
                df['SAMPLE'] = sample
                dfs.append(df)
        except:
            continue
    
    if dfs:
        combined = pd.concat(dfs, ignore_index=True)
        combined.to_csv(output_file, sep='\t', index=False)
    else:
        with open(output_file, 'w') as f:
            f.write("No AMR genes detected across all samples\n")

def combine_taxonomy_reports(input_files, output_file):
    """Combine taxonomy classification reports"""
    dfs = []
    
    for file in input_files:
        try:
            df = pd.read_csv(file, sep='\t')
            sample = file.split('/')[-2]  # Extract from directory name
            df['SAMPLE'] = sample
            dfs.append(df)
        except:
            continue
    
    if dfs:
        combined = pd.concat(dfs, ignore_index=True)
        combined.to_csv(output_file, sep='\t', index=False)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--input', nargs='+', required=True)
    parser.add_argument('--output', required=True)
    parser.add_argument('--report-type', choices=['amr', 'taxonomy'], required=True)
    
    args = parser.parse_args()
    
    if args.report_type == 'amr':
        combine_amr_reports(args.input, args.output)
    elif args.report_type == 'taxonomy':
        combine_taxonomy_reports(args.input, args.output)

if __name__ == "__main__":
    main()
