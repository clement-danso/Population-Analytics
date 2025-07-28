library(readxl)
library(readr)
library(dplyr)
library(janitor)

# Load the PROJECTIONS sheet to get 2022 data
population_df <- read_excel(
  "01_rawdata/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", 
  sheet = "Projections",
  skip = 16, 
  col_types = "text"
)

# Clean the column names
population_df <- population_df %>% 
  clean_names()

# Filter and clean data for 2022
population_df_cleaned <- population_df %>%
  filter(type == "Country/Area") %>%
  filter(year == "2022") %>%
  select(
    iso3_alpha_code,
    region_subregion_country_or_area, 
    births_thousands,          
    total_population_as_of_1_july_thousands
  ) %>%
  rename(
    iso3_code = iso3_alpha_code, # merge key
    country_name = region_subregion_country_or_area,
    births_2022_thousands = births_thousands,
    population_2022_thousands = total_population_as_of_1_july_thousands
  ) %>%
  # Handle parsing carefully
  mutate(
    births_2022_thousands = case_when(
      is.na(births_2022_thousands) ~ NA_real_,
      births_2022_thousands == "..." ~ NA_real_,
      births_2022_thousands == "" ~ NA_real_,
      TRUE ~ parse_number(births_2022_thousands)
    ),
    births_2022 = births_2022_thousands * 1000
  ) %>%
# Remove countries with missing birth data
#filter(!is.na(births_2022_thousands))

# Clean ISO codes
population_df_cleaned$iso3_code <- as.character(population_df_cleaned$iso3_code)

# Save cleaned data
write_csv(population_df_cleaned, "02_cleaned/population_cleaned.csv")

View(population_df_cleaned)
