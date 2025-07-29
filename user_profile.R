# UNICEF Population Analytics Assessment - User Profile Setup
# This script ensures the project can run on any machine

# Set working directory to project root
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
}
library(rstudioapi)

# Try to set working directory to project root
tryCatch({
  setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
}, error = function(e) {
  # If running from command line, try to set to current directory
  cat("Setting working directory to current location...\n")
})

# Function to check and install required packages
setup_environment <- function() {
  cat("=== UNICEF Population Analytics - Environment Setup ===\n")
  
  # Required packages
  required_packages <- c(
    "tidyverse",    # Data manipulation and visualization
    "readxl",       # Read Excel files
    "ggplot2",      # Advanced plotting
    "dplyr",        # Data manipulation
    "tidyr",        # Data tidying
    "readr",        # Fast file reading
    "stringr",      # String manipulation
    "lubridate",    # Date handling
    "knitr",        # Report generation
    "rmarkdown",    # R Markdown support
    "scales",       # Scale functions for ggplot2
    "viridis"       # Color palettes
  )
  
  cat("Checking required packages...\n")
  
  # Check which packages are missing
  missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
  
  if (length(missing_packages) > 0) {
    cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
    install.packages(missing_packages, dependencies = TRUE)
  } else {
    cat("SUCCESS: All required packages are already installed.\n")
  }
  
  # Load all packages
  cat("Loading packages...\n")
  for (package in required_packages) {
    library(package, character.only = TRUE)
  }
  
  cat("SUCCESS: All packages loaded successfully.\n")
}

# Function to check data files
check_data_files <- function() {
  cat("\nChecking data files...\n")
  
  required_files <- c(
    "01_rawdata/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx",
    "01_rawdata/fusion_GLOBAL_DATAFLOW_UNICEF_1.0_.MNCH_ANC4+MNCH_SAB..csv",
    "01_rawdata/On-track and off-track countries.xlsx"
  )
  
  missing_files <- c()
  for (file in required_files) {
    if (!file.exists(file)) {
      missing_files <- c(missing_files, file)
    }
  }
  
  if (length(missing_files) > 0) {
    cat("WARNING: Missing required data files:\n")
    for (file in missing_files) {
      cat("   -", file, "\n")
    }
    cat("Please ensure all data files are in the correct locations.\n")
    return(FALSE)
  } else {
    cat("SUCCESS: All required data files found.\n")
    return(TRUE)
  }
}

# Function to create output directories
create_directories <- function() {
  cat("\nCreating output directories...\n")
  
  dirs_to_create <- c("04_output", "utils")
  
  for (dir in dirs_to_create) {
    if (!dir.exists(dir)) {
      dir.create(dir, recursive = TRUE)
      cat("SUCCESS: Created directory:", dir, "\n")
    } else {
      cat("SUCCESS: Directory exists:", dir, "\n")
    }
  }
}

# Function to check system requirements
check_system_requirements <- function() {
  cat("\nChecking system requirements...\n")
  
  # Check R version
  r_version <- R.version.string
  cat("R version:", r_version, "\n")
  
  # Check if pandoc is available (for R Markdown)
  tryCatch({
    if (rmarkdown::pandoc_available()) {
      cat("SUCCESS: Pandoc is available for report generation.\n")
    } else {
      cat("WARNING: Pandoc not found. Install pandoc for R Markdown report generation.\n")
      cat("   On Ubuntu/Debian: sudo apt install pandoc\n")
      cat("   On macOS: brew install pandoc\n")
      cat("   On Windows: Download from https://pandoc.org/installing.html\n")
    }
  }, error = function(e) {
    cat("WARNING: Could not check pandoc availability. Install pandoc for R Markdown support.\n")
  })
  
  # Check available memory
  tryCatch({
    memory_info <- memory.size()
    if (memory_info > 1000) {
      cat("SUCCESS: Sufficient memory available:", round(memory_info, 1), "MB\n")
    } else {
      cat("WARNING: Low memory available:", round(memory_info, 1), "MB\n")
    }
  }, error = function(e) {
    cat("INFO: Memory check not available on this system.\n")
  })
}

# Main setup function
setup_user_profile <- function() {
  cat("Setting up user profile for UNICEF Population Analytics...\n\n")
  
  # Run all setup functions
  setup_environment()
  create_directories()
  data_ok <- check_data_files()
  check_system_requirements()
  
  if (data_ok) {
    cat("\nSUCCESS: Environment setup complete! You're ready to run the analysis.\n")
    cat("Next step: Run 'source(\"run_project.R\")' to execute the complete workflow.\n")
  } else {
    cat("\nERROR: Setup incomplete. Please address the missing data files before proceeding.\n")
  }
}

# Run setup if this script is sourced
if (!interactive()) {
  setup_user_profile()
} else {
  cat("To set up your environment, run: setup_user_profile()\n")
} 