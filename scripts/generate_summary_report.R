#!/usr/bin/env Rscript
# Generate HTML summary report

library(rmarkdown)
library(tidyverse)
library(DT)
library(plotly)

# This would be called by a final snakemake rule
# Template would be in docs/report_template.Rmd

args <- commandArgs(trailingOnly = TRUE)
output_dir <- args[1]

# Read all results
amr_data <- read_tsv(file.path(output_dir, "amr/combined_amr_report.tsv"))
cis_phage_data <- read_tsv(file.path(output_dir, "cis_phage/combined_cis_phage_report.tsv"))

# Generate plots and tables
# ... (customizable based on your needs)

# Render markdown report
rmarkdown::render(
  input = "docs/report_template.Rmd",
  output_file = file.path(output_dir, "final_summary_report.html"),
  params = list(
    amr = amr_data,
    cis_phage = cis_phage_data
  )
)
