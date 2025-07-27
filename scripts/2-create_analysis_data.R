#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#                             UNICEF - Consultancy assessment
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#
#  LAST UPDATE : July 27, 2025
#  AUTHOR: Antoine Vuillot (antoine.vuillot@outlook.fr)
#  PURPOSE: create analysis dataset
#_______________________________________________________________________________


######################################################################################################## START :)

##~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Import the data  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~

# UNICEF data : SBA and ANC4 
data_unicef = fread("data/02_clean/data_unicef_anc4_sab_clean.csv")

# Under-five mortality classifcation
## Variables are renamed to match the other data
data_mort_class = read.xlsx(xlsxFile = "data/01_raw/On-track and off-track countries.xlsx", sheet = "Sheet1") %>% 
  rename("country_iso3" = "ISO3Code",
         "country_name" = "OfficialName",
         "status" = "Status.U5MR")

# Population data
## Import raw
## Note we start reading at row 17 where the table begins
data_pop_2022_raw = read.xlsx(xlsxFile = "data/01_raw/WPP2022_GEN_F01_DEMOGRAPHIC_INDICATORS_COMPACT_REV1.xlsx",
                          sheet = "Projections",
                          startRow = 17) 
## Clean population data
### Select relevant variables and rename
#### Note we take total population as of January 1st and not July 1st. This is arbitrary as nothing is said about that in the exercise document.
### filter to year 2022 and country (Type == "Country/Area)
### Remove useless variables
data_pop_2022_clean = data_pop_2022_raw %>% 
  select(`Region,.subregion,.country.or.area.*`, `ISO3.Alpha-code`, Type, Year, `Total.Population,.as.of.1.January.(thousands)`) %>% 
  filter(Type == "Country/Area" & Year == 2022) %>% 
  rename('country_name' = "Region,.subregion,.country.or.area.*",
         "country_iso3" = "ISO3.Alpha-code",
         "pop_proj_2022" = "Total.Population,.as.of.1.January.(thousands)") %>%
  select(-c(Year, Type))
    

##~~~~~~~~~~~~~~~~~~~~~~
##  ~ Combine data  ----
##~~~~~~~~~~~~~~~~~~~~~~

# We are interested by status-level aggregation
# Then we perform left join of population and ANC4/SBA data on country status
data_combined = data_mort_class %>% 
  left_join(data_unicef %>% select(-country_name), by = "country_iso3") %>% 
  left_join(data_pop_2022_clean %>% select(-country_name), by = "country_iso3")

# Save data
fwrite(x = data_combined,
       file = "data/02_clean/data_combined.csv")

######################################################################################################## END :D