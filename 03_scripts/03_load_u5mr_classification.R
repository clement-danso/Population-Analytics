library(readr)
library(dplyr)


u5mr_status_df <- read_excel("01_rawdata/On-track and off-track countries.xlsx")

# clean the col_names, changing to lower case + snake_case for consistency
u5mr_status_df <- u5mr_status_df %>% 
  clean_names()

#classify countries as 'on-track' or 'off-track'
u5mr_status_df <- u5mr_status_df %>%
  mutate(
    u5mr_class = if_else(
      tolower(status_u5mr) %in% c("achieved", "on track"),
      "on-track",
      "off-track"
    )
  )

# Save cleaned data
write_csv(u5mr_status_df, "02_cleaned/u5mr_status_cleaned.csv")

str(u5mr_status_df)
View(u5mr_status_df)

