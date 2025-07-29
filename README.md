# UNICEF Population Analytics Assessment

## Repository Structure

This repository is organized to ensure clear separation of raw data, processing scripts, and outputs:

```
Population-Analytics/
├── 01_rawdata/                    # Original UNICEF datasets
├── 02_cleaned/                    # Processed and cleaned datasets  
├── 03_scripts/                    # R scripts for data processing and analysis
├── 04_output/                     # Generated reports and visualizations
├── utils/                         # Utility functions and helpers
├── user_profile.R                 # Environment setup and validation
├── run_project.R                  # Complete workflow execution
└── README.md                      # This file
```

## Purpose of Each Folder and File

### **01_rawdata/**
Contains the original UNICEF datasets in their unmodified form:
- `WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx` - UN population projections
- `fusion_GLOBAL_DATAFLOW_UNICEF_1.0_.MNCH_ANC4+MNCH_SAB..csv` - Maternal health indicators
- `On-track and off-track countries.xlsx` - SDG 3.1 country classifications

### **02_cleaned/**
Stores processed datasets ready for analysis:
- `population_cleaned.csv` - Cleaned population data with standardized variables
- `anc4_sba_cleaned.csv` - Processed maternal health coverage indicators
- `u5mr_status_cleaned.csv` - Standardized country classification data

### **03_scripts/**
Sequential R scripts that perform the complete analysis:
- `01_load_clean_population.R` - Loads and cleans UN population data
- `02_load_clean_anc4_sba.R` - Processes maternal health indicators
- `03_load_u5mr_classification.R` - Handles country classifications
- `04_merge_datasets.R` - Combines all cleaned datasets
- `05_calculate_weighted_coverage.R` - Performs population-weighted analysis
- `06_generate_report.R` - Creates visualizations and reports

### **04_output/**
Contains all analysis results and final outputs:
- `merged_data.csv` - Complete integrated dataset
- `population_weighted_coverage.csv` - Key coverage metrics and findings
- `maternal_health_report.html` - Professional analysis report with visualizations

### **utils/**
Helper files and utilities:
- Contains additional utility functions and configuration files

### **user_profile.R**
Environment setup script that ensures the project can run on any machine:
- Installs and loads required R packages
- Validates data files are present
- Checks system requirements (R version, pandoc, memory)
- Creates necessary directories

### **run_project.R**
Master execution script that runs the complete analysis workflow:
- Orchestrates all analysis scripts in sequence
- Provides progress tracking and error handling
- Generates final report and outputs
- Verifies all expected files are created

## Instructions to Reproduce the Analysis

### Prerequisites
- R 4.0+ installed on your system
- Git for cloning the repository
- Internet connection for package installation

### Step-by-Step Reproduction

1. **Clone the repository**
   ```bash
   git clone <your-repository-url>
   cd Population-Analytics
   ```

2. **Set up the environment**
   ```r
   source("user_profile.R")
   setup_user_profile()
   ```

3. **Run the complete analysis**
   ```r
   source("run_project.R")
   ```

4. **Access the results**
   - Open `04_output/maternal_health_report.html` for the complete analysis report
   - Check `04_output/population_weighted_coverage.csv` for key findings
   - Review `04_output/merged_data.csv` for the complete dataset

### Expected Outputs
After successful execution, you will have:
- Cleaned datasets in `02_cleaned/`
- Analysis results in `04_output/`
- Professional HTML report with visualizations
- Population-weighted coverage analysis comparing on-track vs off-track countries

### Troubleshooting
- If packages are missing, run `setup_user_profile()` to install dependencies
- If pandoc is not found, install it for your operating system
- Ensure all data files are present in `01_rawdata/` directory
- Check console output for specific error messages

---

*This work was completed as part of a UNICEF assessment. Please respect the data usage guidelines.*
