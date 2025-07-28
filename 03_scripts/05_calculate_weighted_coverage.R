library(dplyr)
library(readr)

# Load the merged dataset
merged_df <- read_csv("04_output/merged_data.csv")

# Calculate population-weighted coverage by track status
weighted_coverage <- merged_df %>%
  group_by(track_status) %>%
  summarise(
    # Population-weighted ANC4 coverage
    anc4_weighted_avg = weighted.mean(anc4_coverage, w = births_2022, na.rm = TRUE),
    anc4_countries = sum(!is.na(anc4_coverage)),
    
    # Population-weighted SBA coverage  
    sba_weighted_avg = weighted.mean(sba_coverage, w = births_2022, na.rm = TRUE),
    sba_countries = sum(!is.na(sba_coverage)),
    
    # Summary statistics
    total_countries = n(),
    total_births_2022 = sum(births_2022, na.rm = TRUE),
    total_births_millions = round(sum(births_2022, na.rm = TRUE) / 1000000, 1),
    
    .groups = 'drop'
  ) %>%
  # Round percentages to 1 decimal place
  mutate(
    anc4_weighted_avg = round(anc4_weighted_avg, 1),
    sba_weighted_avg = round(sba_weighted_avg, 1)
  )

# Display results
print("=== POPULATION-WEIGHTED COVERAGE RESULTS ===")
print(weighted_coverage)


#### Further insights #####

# Creating a more detailed breakdown
detailed_breakdown <- merged_df %>%
  group_by(track_status) %>%
  summarise(
    # ANC4 Analysis
    anc4_weighted_coverage = round(weighted.mean(anc4_coverage, w = births_2022, na.rm = TRUE), 1),
    anc4_simple_avg = round(mean(anc4_coverage, na.rm = TRUE), 1),
    anc4_countries = sum(!is.na(anc4_coverage)),
    anc4_births_covered = sum(births_2022[!is.na(anc4_coverage)], na.rm = TRUE),
    
    # SBA Analysis  
    sba_weighted_coverage = round(weighted.mean(sba_coverage, w = births_2022, na.rm = TRUE), 1),
    sba_simple_avg = round(mean(sba_coverage, na.rm = TRUE), 1),
    sba_countries = sum(!is.na(sba_coverage)),
    sba_births_covered = sum(births_2022[!is.na(sba_coverage)], na.rm = TRUE),
    
    # Overall
    total_countries = n(),
    total_births = sum(births_2022, na.rm = TRUE),
    
    .groups = 'drop'
  ) %>%
  # Convert births to millions for readability
  mutate(
    anc4_births_millions = round(anc4_births_covered / 1000000, 1),
    sba_births_millions = round(sba_births_covered / 1000000, 1),
    total_births_millions = round(total_births / 1000000, 1)
  )



# Create a summary table for presentation
summary_table <- weighted_coverage %>%
  select(
    track_status,
    anc4_weighted_avg,
    anc4_countries,
    sba_weighted_avg, 
    sba_countries,
    total_countries,
    total_births_millions
  ) %>%
  rename(
    `Track Status` = track_status,
    `ANC4 Coverage (%)` = anc4_weighted_avg,
    `ANC4 Countries` = anc4_countries,
    `SBA Coverage (%)` = sba_weighted_avg,
    `SBA Countries` = sba_countries,
    `Total Countries` = total_countries,
    `Total Births (Millions)` = total_births_millions
  )

# Calculate the difference between on-track and off-track
if(nrow(weighted_coverage) == 2) {
  on_track <- weighted_coverage[weighted_coverage$track_status == "on-track", ]
  off_track <- weighted_coverage[weighted_coverage$track_status == "off-track", ]
  
  print("\n=== COVERAGE GAPS ===")
  print(paste("ANC4 Gap (On-track - Off-track):", 
              round(on_track$anc4_weighted_avg - off_track$anc4_weighted_avg, 1), 
              "percentage points"))
  print(paste("SBA Gap (On-track - Off-track):", 
              round(on_track$sba_weighted_avg - off_track$sba_weighted_avg, 1), 
              "percentage points"))
}

# Save results
write_csv(weighted_coverage, "04_output/population_weighted_coverage.csv")


