library(janitor)
library(readr)  
library(dplyr)  
library(tidyr)    
library(stringr)

anc4_sba_df <- read.csv("01_rawdata/fusion_GLOBAL_DATAFLOW_UNICEF_1.0_.MNCH_ANC4+MNCH_SAB..csv")

# Clean the col_names - remove everything after first dot
colnames(anc4_sba_df) <- sub("\\..*", "", colnames(anc4_sba_df))
colnames(anc4_sba_df) <- janitor::make_clean_names(colnames(anc4_sba_df))   #for snake_case


# keeping only the essential columns
anc4_sba_cleaned <- anc4_sba_df %>%
  select(
    ref_area,           # Country info
    indicator,          # ANC4 vs SBA
    time_period,        # Year
    obs_value          # Coverage percentage
  ) %>%

  # Extract ISO3 code from ref_area (example: "AFG: Afghanistan" -> "AFG")
  mutate(iso3_code = str_extract(ref_area, "^[A-Z]{3}")) %>%
  
  # Only keeping 3-letter country codes- purposely to filter out countries and not regions
  filter(grepl("^[A-Z]{3}:", ref_area))  

View(anc4_sba_cleaned)

# Filter for ANC4 and SBA coverage estimates from 2018 to 2022
# Use the most recent estimate within this range per country
anc4_sba_filtered <- anc4_sba_cleaned %>%
  filter(time_period >= 2018 & time_period <= 2022) %>%
  group_by(ref_area, indicator) %>%
  slice_max(time_period, n = 1, with_ties = FALSE) %>%
  ungroup() %>%

  # Create separate columns for ANC4 and SBA
  pivot_wider(
    names_from = indicator,
    values_from = obs_value,
    names_prefix = "",
    id_cols = c(iso3_code, ref_area, time_period)
  ) %>%

  # Clean column names for ANC4 and SBA
  rename_with(~case_when(
    str_detect(., "MNCH_ANC4") ~ "anc4_coverage",
    str_detect(., "MNCH_SAB") ~ "sba_coverage",
    TRUE ~ .
  ))


View(anc4_sba_filtered)

# Save cleaned and filtered data
write_csv(anc4_sba_filtered, "02_cleaned/anc4_sba_cleaned.csv")

