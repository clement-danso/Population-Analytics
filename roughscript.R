library(readxl)
library(dplyr)

# Established data sources

unicef_maternal_df <- read.csv("01_rawdata/fusion_GLOBAL_DATAFLOW_UNICEF_1.0_.MNCH_ANC4+MNCH_SAB..csv")
#

#

u5mr_status_df <- read_excel("01_rawdata/On-track and off-track countries.xlsx")

population_df <- read_excel("01_rawdata/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx", skip = 16)
#data cleaning: remove metadata rows, clean col names,

View(population_df)
str(population_df)

## merging the dataset:
# ISO3 identified as the merge key: present in all 3 datasets
