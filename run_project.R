# UNICEF Population Analytics Assessment - Complete Workflow Execution
# This script runs the entire analysis pipeline from raw data to final report

# Load user profile and setup environment
cat("=== UNICEF Population Analytics Assessment ===\n")
cat("Initializing complete workflow execution...\n\n")

# Source the user profile to ensure environment is ready
source("user_profile.R")

# Run environment setup (only if not already done)
if (!exists("environment_setup_complete")) {
  setup_user_profile()
  environment_setup_complete <- TRUE
}

# Function to run scripts with error handling and progress tracking
run_script_with_progress <- function(script_path, step_name) {
  cat("\n" + "="*50 + "\n")
  cat("STEP:", step_name, "\n")
  cat("Running:", script_path, "\n")
  cat("="*50 + "\n")
  
  start_time <- Sys.time()
  
  tryCatch({
    source(script_path)
    end_time <- Sys.time()
    duration <- round(as.numeric(difftime(end_time, start_time, units = "secs")), 1)
    cat("SUCCESS: COMPLETED", step_name, "(", duration, "seconds)\n")
    return(TRUE)
  }, error = function(e) {
    cat("ERROR in", step_name, ":\n")
    cat("   Error message:", e$message, "\n")
    cat("   Script:", script_path, "\n")
    return(FALSE)
  })
}

# Function to check if output files were created
check_outputs <- function() {
  cat("\n" + "="*50 + "\n")
  cat("VERIFYING OUTPUTS\n")
  cat("="*50 + "\n")
  
  expected_outputs <- c(
    "02_cleaned/population_cleaned.csv",
    "02_cleaned/anc4_sba_cleaned.csv", 
    "02_cleaned/u5mr_status_cleaned.csv",
    "04_output/merged_data.csv",
    "04_output/population_weighted_coverage.csv"
  )
  
  missing_outputs <- c()
  for (file in expected_outputs) {
    if (file.exists(file)) {
      file_size <- file.size(file)
      cat("SUCCESS:", file, "(", round(file_size/1024, 1), "KB)\n")
    } else {
      cat("ERROR:", file, "(MISSING)\n")
      missing_outputs <- c(missing_outputs, file)
    }
  }
  
  return(length(missing_outputs) == 0)
}

# Function to generate maternal health report from R Markdown
generate_maternal_health_report <- function() {
  cat("\n" + "="*50 + "\n")
  cat("GENERATING MATERNAL HEALTH REPORT\n")
  cat("="*50 + "\n")
  
  tryCatch({
    # Check if R Markdown file exists
    if (!file.exists("03_scripts/06_generate_maternal_health_report.Rmd")) {
      cat("ERROR: R Markdown template not found. Creating basic report...\n")
      create_basic_report()
      return(FALSE)
    } else {
      cat("INFO: Rendering comprehensive maternal health report...\n")
      rmarkdown::render("03_scripts/06_generate_maternal_health_report.Rmd", 
                       output_format = "html_document",
                       output_dir = "04_output",
                       quiet = FALSE)
    }
    
    if (file.exists("04_output/06_generate_maternal_health_report.html")) {
      file_size <- file.size("04_output/06_generate_maternal_health_report.html")
      cat("SUCCESS: Report generated: 06_generate_maternal_health_report.html (", round(file_size/1024, 1), "KB)\n")
      return(TRUE)
    } else {
      cat("ERROR: Report generation failed\n")
      return(FALSE)
    }
  }, error = function(e) {
    cat("ERROR: Error generating report:", e$message, "\n")
    return(FALSE)
  })
}

# Function to generate final report (kept for compatibility)
generate_final_report <- function() {
  return(generate_maternal_health_report())
}

# Function to create a basic report if template is missing
create_basic_report <- function() {
  cat("Creating basic analysis summary...\n")
  
  # Read the weighted coverage data
  if (file.exists("04_output/population_weighted_coverage.csv")) {
    coverage_data <- read_csv("04_output/population_weighted_coverage.csv")
    
    # Create simple HTML report
    html_content <- paste0(
      "<!DOCTYPE html>",
      "<html><head><title>UNICEF Maternal Health Analysis</title></head>",
      "<body><h1>UNICEF Population Analytics Assessment</h1>",
      "<h2>Key Findings</h2>",
      "<p>Analysis completed successfully. Check the CSV files in 04_output/ for detailed results.</p>",
      "<h3>Population-Weighted Coverage Results:</h3>",
      "<pre>", capture.output(print(coverage_data)), "</pre>",
      "<p><em>Report generated on ", Sys.Date(), "</em></p>",
      "</body></html>"
    )
    
    writeLines(html_content, "04_output/maternal_health_report.html")
  }
}

# Main workflow execution
main_workflow <- function() {
  cat("Starting UNICEF Population Analytics Assessment\n")
  cat("This will execute the complete data pipeline from raw data to final report.\n\n")
  
  # Step 1: Data Loading and Cleaning
  cat("PHASE 1: DATA LOADING AND CLEANING\n")
  step1_success <- TRUE
  
  step1_success <- step1_success && run_script_with_progress(
    "03_scripts/01_load_clean_population.R", 
    "Population Data Loading & Cleaning"
  )
  
  step1_success <- step1_success && run_script_with_progress(
    "03_scripts/02_load_clean_anc4_sba.R", 
    "ANC4/SBA Data Loading & Cleaning"
  )
  
  step1_success <- step1_success && run_script_with_progress(
    "03_scripts/03_load_u5mr_classification.R", 
    "U5MR Classification Loading & Cleaning"
  )
  
  if (!step1_success) {
    cat("\nERROR: PHASE 1 FAILED. Stopping workflow.\n")
    return(FALSE)
  }
  
  # Step 2: Data Integration
  cat("\nPHASE 2: DATA INTEGRATION\n")
  step2_success <- run_script_with_progress(
    "03_scripts/04_merge_datasets.R", 
    "Dataset Merging"
  )
  
  if (!step2_success) {
    cat("\nERROR: PHASE 2 FAILED. Stopping workflow.\n")
    return(FALSE)
  }
  
  # Step 3: Analysis
  cat("\nPHASE 3: ANALYSIS\n")
  step3_success <- run_script_with_progress(
    "03_scripts/05_calculate_weighted_coverage.R", 
    "Population-Weighted Coverage Analysis"
  )
  
  if (!step3_success) {
    cat("\nERROR: PHASE 3 FAILED. Stopping workflow.\n")
    return(FALSE)
  }
  
  # Step 4: Report Generation
  cat("\nPHASE 4: REPORT GENERATION\n")
  step4_success <- generate_maternal_health_report()
  
  # Verify outputs
  outputs_ok <- check_outputs()
  
  # Generate final report
  report_ok <- generate_final_report()
  
  # Final summary
  cat("\n" + "="*60 + "\n")
  cat("WORKFLOW EXECUTION SUMMARY\n")
  cat("="*60 + "\n")
  
  if (step1_success && step2_success && step3_success && outputs_ok && report_ok) {
    cat("SUCCESS! Complete workflow executed successfully.\n\n")
    cat("OUTPUTS CREATED:\n")
    cat("   • Cleaned datasets in 02_cleaned/\n")
    cat("   • Analysis results in 04_output/\n")
    cat("   • Final report: 04_output/maternal_health_report.html\n\n")
    cat("KEY FINDINGS:\n")
    cat("   • Population-weighted coverage analysis completed\n")
    cat("   • Coverage gaps between on-track and off-track countries calculated\n")
    cat("   • Professional report with visualizations generated\n\n")
    cat("Next steps:\n")
    cat("   • Open 04_output/maternal_health_report.html to view results\n")
    cat("   • Check 04_output/population_weighted_coverage.csv for key metrics\n")
    cat("   • Review 04_output/merged_data.csv for complete dataset\n")
    
    return(TRUE)
  } else {
    cat("WARNING: WORKFLOW COMPLETED WITH ISSUES\n\n")
    cat("Some steps may have failed or outputs may be missing.\n")
    cat("Check the output above for specific error messages.\n")
    cat("Review the generated files in 04_output/ directory.\n")
    
    return(FALSE)
  }
}

# Execute the workflow
if (!interactive()) {
  success <- main_workflow()
  if (success) {
    cat("\nSUCCESS: UNICEF Assessment workflow completed successfully!\n")
  } else {
    cat("\nERROR: Workflow completed with issues. Please review the output above.\n")
  }
} else {
  cat("To run the complete workflow, execute: main_workflow()\n")
}
