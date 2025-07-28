library(dplyr)
library(readr)

# Load the cleaned datasets
anc4_sba_cleaned <- read_csv("02_cleaned/anc4_sba_cleaned.csv")
population_cleaned <- read_csv("02_cleaned/population_cleaned.csv") 
u5mr_status_cleaned <- read_csv("02_cleaned/u5mr_status_cleaned.csv")

# Merge all cleaned datasets
merged_df <- anc4_sba_cleaned %>%
  left_join(population_cleaned, by = "iso3_code") %>%
  left_join(u5mr_status_cleaned, by = "iso3_code") %>%
  # Keep only countries with complete essential data
  filter(
    !is.na(track_status),           # Must have track status
    !is.na(births_2022),            # Must have birth data for weighting
    (!is.na(anc4_coverage) | !is.na(sba_coverage))  # Must have at least one coverage metric
  ) %>%
  # Select final columns
  select(
    iso3_code,
    ref_area,                       # Country name from ANC4/SBA data
    country_name,                   # Country name from population data  
    country_official_name,          # Official name from U5MR data
    track_status,
    time_period,
    anc4_coverage,
    sba_coverage,
    births_2022,
    births_2022_thousands,
    population_2022_thousands
  )

# Check merge results
print(paste("Final merged dataset has", nrow(merged_df), "rows"))
print("Countries by track status:")
print(table(merged_df$track_status, useNA = "ifany"))
print(paste("Countries with ANC4 data:", sum(!is.na(merged_df$anc4_coverage))))
print(paste("Countries with SBA data:", sum(!is.na(merged_df$sba_coverage))))

# Save final merged dataset
write_csv(merged_df, "04_output/merged_data.csv")

View(merged_df)