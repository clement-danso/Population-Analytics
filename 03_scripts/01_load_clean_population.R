library(readxl)
library(readr)
library(dplyr)
library(janitor)

# Load the population dataset, skipping the metadata section/rows, all columns text.
population_df <- read_excel("01_rawdata/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", skip = 16, col_types = "text")

# clean the col_names, changing to lower case + snake_case for consistency
population_df <- population_df %>% 
  clean_names()

#drop unnecessary columns

#filter to show country-level data
population_df <- population_df %>%
  filter(type=="Country/Area")

#check datatypes of colums and change where necessary:
# cols_to_numeric <- c(
#   "total_population_as_of_1_january_thousands",
#   "total_population_as_of_1_july_thousands",
#   "male_population_as_of_1_july_thousands",
#   "female_population_as_of_1_july_thousands",
#   "population_density_as_of_1_july_persons_per_square_km",
#   "population_growth_rate_percentage",
#   "births_thousands",
#   "total_deaths_thousands",
#   "crude_birth_rate_births_per_1_000_population",
#   "crude_death_rate_deaths_per_1_000_population",
#   "life_expectancy_at_birth_both_sexes_years",
#   "median_age_as_of_1_july_years"
# )
# 
# population_df[cols_to_numeric] <- lapply(population_df[cols_to_numeric], function(x) as.numeric(gsub(",", "", x)))

# Clean ISO codes: Ensure they're character type
iso_cols <- c("iso3_alpha_code", "iso2_alpha_code")
population_df[iso_cols] <- lapply(population_df[iso_cols], as.character)


View(population_df)


# Save cleaned data
write_csv(population_df, "02_cleaned/population_cleaned.csv")
