library(janitor)
library(readr)  
library(dplyr)  

anc4_sba_df <- read.csv("01_rawdata/fusion_GLOBAL_DATAFLOW_UNICEF_1.0_.MNCH_ANC4+MNCH_SAB..csv")

# Clean the col_names - remove everything after first dot
colnames(anc4_sba_df) <- sub("\\..*", "", colnames(anc4_sba_df))
colnames(anc4_sba_df) <- janitor::make_clean_names(colnames(anc4_sba_df))   #for snake_case

View(anc4_sba_df)

# Filter for ANC4 and SBA coverage estimates from 2018 to 2022
# Use the most recent estimate within this range per country
anc4_sba_filtered <- anc4_sba_df %>%
  filter(time_period >= 2018 & time_period <= 2022) %>%
  filter(grepl("^[A-Z]{3}:", ref_area)) %>%  # Only keeping 3-letter country codes- purposely to filter out countries and not regions
  group_by(ref_area, indicator) %>%
  slice_max(time_period, n = 1, with_ties = FALSE) %>%
  ungroup()

View(anc4_sba_filtered)

# Save cleaned and filtered data
write_csv(anc4_sba_filtered, "02_cleaned/anc4_sba_cleaned.csv")

