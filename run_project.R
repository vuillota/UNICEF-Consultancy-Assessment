#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#
#                             UNICEF - Consultancy assessment
#
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
#
#  LAST UPDATE : July 27, 2025
#  AUTHOR: XXX
#  PURPOSE: main script to define session parameters, import packages, and call individual scripts
#_______________________________________________________________________________


######################################################################################################## START :)


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Setting up R session  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Start environment : restore from the lockfile
#renv::init()

# Clean the workspace
rm(list=ls()) 
# Set the same seed for reproducibility
set.seed(2025)


##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
##  ~ Download and install packages  ----
##~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Please restore the project environment
#renv::restore()

list_packages <- c("tidyverse", "ARTofR", "openxlsx", "data.table", "quarto", "here",
                  "ggplot2", "RColorBrewer", "dplyr", "knitr", "renv", "rmarkdown")

# If the package is not installed, then install it 
if (!require("pacman")) install.packages("pacman")

# Load the packages 
pacman::p_load(list_packages, character.only = TRUE, install = TRUE)

# Take a snapshot of the environment, must be done by initial author of the script to ensure reproducibility
#renv::snapshot()


##~~~~~~~~~~~~~~~~~~~~~~
##  ~ Call scripts  ----
##~~~~~~~~~~~~~~~~~~~~~~

# Import UNICEF data using API
source("scripts/1-import_unicef_data.R")
# Create analysis data by combining mortality status, population data and ANC4/SAB indicators from UNICEF data
source("scripts/2-create_analysis_data.R")
# Compute coverage of both indicators
source("scripts/3-pop-weighted-coverage.R")
# Issue report by calling Rmarkdown script
rmarkdown::render('scripts/4-report.Rmd', output_dir = 'report', output_file = "report_anc4_sba.pdf")


######################################################################################################## END :D