# UNICEF Population Analytics Assessment - Requirements
# This file lists all required R packages and installation instructions

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
  "rmarkdown"     # R Markdown support
)

# Function to install missing packages
install_missing_packages <- function() {
  missing_packages <- required_packages[!required_packages %in% installed.packages()[,"Package"]]
  
  if (length(missing_packages) > 0) {
    cat("Installing missing packages:", paste(missing_packages, collapse = ", "), "\n")
    install.packages(missing_packages, dependencies = TRUE)
  } else {
    cat("All required packages are already installed.\n")
  }
}

# Function to load all packages
load_all_packages <- function() {
  for (package in required_packages) {
    library(package, character.only = TRUE)
  }
  cat("All packages loaded successfully.\n")
}

# Run installation if this script is sourced
if (!interactive()) {
  install_missing_packages()
  load_all_packages()
} 