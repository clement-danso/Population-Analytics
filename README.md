# UNICEF Population Analytics Assessment

## Project Overview
This repository contains the analysis of UNICEF population and maternal health data, focusing on ANC4+ coverage, skilled birth attendance (SBA), and under-5 mortality rates across countries.

## Project Structure
```
Population-Analytics/
├── 01_rawdata/          # Original UNICEF datasets
├── 02_cleaned/          # Processed and cleaned datasets
├── 03_scripts/          # R scripts for data processing and analysis
├── 04_output/           # Generated reports and visualizations
├── utils/               # Utility functions and helpers
├── main.R               # Master script to run entire workflow
└── README.md            # This file
```

## Data Sources
- **Population Data**: WPP2022 demographic indicators
- **Health Indicators**: UNICEF MNCH ANC4+ and SBA coverage data
- **Country Classifications**: On-track/off-track status for maternal health targets

## Workflow
1. **Data Loading & Cleaning** (`03_scripts/01-03_*.R`)
   - Load raw datasets
   - Clean and standardize variables
   - Handle missing values and outliers

2. **Data Integration** (`03_scripts/04_merge_datasets.R`)
   - Merge cleaned datasets
   - Create analysis-ready dataset

3. **Analysis** (`03_scripts/05_calculate_weighted_coverage.R`)
   - Calculate weighted coverage metrics
   - Perform statistical analysis

4. **Reporting** (`03_scripts/06_generate_report.R`)
   - Generate visualizations
   - Create final report

## Reproducibility
- All scripts are numbered for sequential execution
- `main.R` orchestrates the entire workflow
- Clear documentation of data transformations
- Version-controlled code and data

## Getting Started
1. Clone this repository
2. Install required R packages (see `utils/requirements.R`)
3. Run `main.R` to execute the complete analysis
4. Check `04_output/` for results

## Dependencies
- R 4.0+
- tidyverse
- readxl
- ggplot2
- dplyr

## License
This work is part of a UNICEF assessment and should not be redistributed without permission.
