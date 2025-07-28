# UNICEF Population Analytics Assessment - Master Script
# This script orchestrates the complete data analysis workflow

# Load required libraries
library(tidyverse)
library(readxl)
library(ggplot2)
library(dplyr)

# Set working directory to project root
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Create output directory if it doesn't exist
if (!dir.exists("04_output")) {
  dir.create("04_output")
}

# Function to run scripts with error handling
run_script <- function(script_path) {
  cat("Running:", script_path, "\n")
  tryCatch({
    source(script_path)
    cat("✓ Completed:", script_path, "\n")
  }, error = function(e) {
    cat("✗ Error in:", script_path, "\n")
    cat("Error message:", e$message, "\n")
  })
}

# Main workflow execution
cat("=== UNICEF Population Analytics Assessment ===\n")
cat("Starting analysis workflow...\n\n")

# Step 1: Data Loading and Cleaning
cat("Step 1: Loading and cleaning data...\n")
run_script("03_scripts/01_load_clean_population.R")
run_script("03_scripts/02_load_clean_anc4_sba.R")
run_script("03_scripts/03_load_u5mr_classification.R")

# Step 2: Data Integration
cat("\nStep 2: Integrating datasets...\n")
run_script("03_scripts/04_merge_datasets.R")

# Step 3: Analysis
cat("\nStep 3: Performing analysis...\n")
run_script("03_scripts/05_calculate_weighted_coverage.R")

# Step 4: Reporting
cat("\nStep 4: Generating report...\n")
run_script("03_scripts/06_generate_report.R")

cat("\n=== Analysis Complete ===\n")
cat("Check 04_output/ directory for results.\n")
