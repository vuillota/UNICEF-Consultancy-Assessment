#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#                             UNICEF - Consultancy assessment
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#
#  LAST UPDATE : July 27, 2025
#  AUTHOR: XXX
#  PURPOSE: from the combined dataset, compute the population-weighted coverage of ANC4 and SAB for each mortality-category of countries
#_______________________________________________________________________________


######################################################################################################## START :)

# Import combined dataset
data_combined = fread(file = "data/02_clean/data_combined.csv")

# Compute population-weigthed coverage at mortality-status level
data_cover = data_combined %>%
  # Create status "on-track" and "off-track" groups
  mutate(group = case_when(status == "Achieved" | status == "On Track" ~ "On-track",
                           status == "Acceleration Needed" ~ "Off-track")) %>% 
  # For each status group, compute weights then population-weighted coverage
  # We also compute number of countries and total population for each group (used in report)
  group_by(group) %>% 
  mutate(weight = pop_proj_2022/sum(pop_proj_2022, na.rm = T)) %>% 
  summarize(across(.cols = c("anc4", "sba"),
                   .fns = ~ sum(.x * weight, na.rm = T)),
            n_countries = n(),
            tot_pop_2022 = sum(pop_proj_2022*1000, na.rm = T)) %>% 
  ungroup()

# Save the data
fwrite(x = data_cover,
       file = "data/03_final/data_2022pop-weighted-coverage_anc4_sba_mortality-class.csv")

# Remove useless objects
rm(data_combined, data_cover)

######################################################################################################## END :D