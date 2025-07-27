#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#                             UNICEF - Consultancy assessment
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#
#  LAST UPDATE : July 27, 2025
#  AUTHOR: Antoine Vuillot (antoine.vuillot@outlook.fr)
#  PURPOSE: import indicators from UNICEF data warehouse
#_______________________________________________________________________________


######################################################################################################## START :)

# Define query URL generated on https://sdmx.data.unicef.org/webservice/data.html# : ANC4 and SBA indicators for entire world, entire period
## Note it would have also been possible to download data directly (https://data.unicef.org/resources/data_explorer/unicef_f/?ag=UNICEF&df=GLOBAL_DATAFLOW&ver=1.0&dq=.MNCH_ANC4+MNCH_SAB.&startPeriod=2018&endPeriod=2022)
## However using an API request ensures we have the latest version of the data (e.g if modifications were done to values of past indicators of interest)
url = "https://sdmx.data.unicef.org/ws/public/sdmxapi/rest/data/UNICEF,GLOBAL_DATAFLOW,1.0/.MNCH_ANC4+MNCH_SAB.?format=csv&labels=both"

# Import data
data_unicef_raw = read.csv(url)

# Clean data : 
## select relevant variables and rename
## restrict to 2018-2022 period and country-level indicators (ISO3 code)
## Keep the most recent value for both indicators
## pivot to wide format
data_unicef_clean = data_unicef_raw %>% 
  # Select variables
  select(REF_AREA ,Geographic.area, INDICATOR, TIME_PERIOD, OBS_VALUE) %>% 
  # Rename
  rename("country_iso3" = "REF_AREA",
         "country_name" = "Geographic.area",
         "year" = "TIME_PERIOD",
         "indicator" = "INDICATOR",
         "value" = "OBS_VALUE") %>%  
  # Restrict data
  filter(year >= 2018 & year <= 2022 & str_length(country_iso3) == 3) %>% 
  # Keep only the most recent, non-NA estimate
  group_by(country_iso3, indicator) %>% 
  filter(is.na(value) == F) %>% 
  filter(year == max(year)) %>% 
  ungroup() %>% 
  # Remove year : not useful any more
  select(-year) %>% 
  # Pivot to wide format (1 row per country, 2 indicators)
  pivot_wider(names_from = "indicator",
              values_from = "value") %>% 
  # Rename indicators 
  rename("anc4" = "MNCH_ANC4",
         "sab" = "MNCH_SAB")
  
# Save data
fwrite(x = data_unicef_raw,
          file = "data/01_raw/data_unicef_anc4_sab_raw.csv")
fwrite(x = data_unicef_clean,
          file = "data/02_clean/data_unicef_anc4_sab_clean.csv")


# Remove useless objects in the environnement
rm(data_unicef_clean, data_unicef_raw, url)

######################################################################################################## END :D