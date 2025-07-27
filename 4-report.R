## ----setup, include=FALSE----------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

# Clean the workspace
rm(list=ls()) 

# Download and install packages
list_packages <- c("tidyverse", "ARTofR", "openxlsx", "data.table", "here",
                  "ggplot2", "RColorBrewer", "dplyr", "knitr", "renv", "rmarkdown")

# If the package is not installed, then install it 
if (!require("pacman")) install.packages("pacman")
# Load the packages 
pacman::p_load(list_packages, character.only = TRUE, install = TRUE)

# Import the data
## here::here() is used so that paths are referred from project root
data_cover = read.csv(file = here::here("data/03_final/data_2022pop-weighted-coverage_anc4_sab_mortality-class.csv"))



## ----include = FALSE---------------------------------------------------------------------------------------------------
data_fig1 = data_cover %>%   
  # Rename for improved plotting
  rename("ANC4" = "anc4",
         "SAB" = "sab") %>% 
  # Remove useless variables
  #select(-c(n_countries, tot_pop_2022)) %>% 
  # Pivot longer for plotting
  pivot_longer(cols = c("ANC4", "SAB"),
               names_to = "indicator",
               values_to = "value") 

# Create the figure
fig1 = ggplot(data = data_fig1,
              aes(x = indicator, y = value, fill = group, label = round(value,1), group = group)) +
  geom_bar(position = "dodge", stat = "identity") +
  geom_text(aes(y = value+3),position = position_dodge(width=1)) +
  scale_fill_brewer(palette = "Blues") +
  labs(title = "Coverage of ANC4 and SAB across under-five mortality categories",
       subtitle = "On the period 2018-2022",
       x = "", y = "Population-weighted average",
       caption = paste0("Off-track (on-track) category covers ", data_fig1[data_fig1$group == "Off-track" & data_fig1$indicator == "ANC4",]$n_countries, " countries (", data_fig1[data_fig1$group == "On-track" & data_fig1$indicator == "ANC4",]$n_countries  ,") or ", format(data_fig1[data_fig1$group == "Off-track" & data_fig1$indicator == "ANC4",]$tot_pop_2022, big.mark = ",", digits = 0, scientific = F), " people (", format(data_fig1[data_fig1$group == "On-track" & data_fig1$indicator == "ANC4",]$tot_pop_2022, big.mark = ",", digits = 0, scientific = F),").\nANC4 : % of women (aged 15-49) with at least 4 antenatal care visits\nSAB : % of deliveries attended by skilled health personnel.\nFor both indicators we use the most recent available country estimate on the 2018-2022 period.\nIndicators are then aggrated using the 2022 projected population as weight. \nSources : UNICEF (population, ANC4 and SAB indicators, under-five mortality categories).")) +
  theme_minimal() +
  theme(plot.caption = element_text(hjust = 0),
        legend.title = element_blank())



## ----echo = FALSE, fig.align='center'----------------------------------------------------------------------------------
# Show the figure
fig1


