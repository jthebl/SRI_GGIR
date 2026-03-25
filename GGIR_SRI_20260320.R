###############################################################################
###############################################################################
###                                                                         ###
###       GGIR Package for SWIFT SRI Calculation                            ###
###       Author: Joey Hebl, Senior Clinical Research Assistant             ###
###               Oregon Institute of Occupational Health Sciences          ###
###               Circadian Lab, Dr. Nicole Bowles Lab                      ###
###       Contact: heblj@ohsu.edu                                           ###
###       Created: 03.01.2026                                               ###
###       Date of Current Draft: 03.05.2026                                 ###
###                                                                         ###
###############################################################################
###############################################################################


# Resources ---------------------------------------------------------------

# For GGIR general package description:
#   https://wadpac.github.io/GGIR/articles/chapter1_WhatIsGGIR.html
#   chrome-extension://efaidnbmnnnibpcajpcglclefindmkaj/https://cran.r-project.org/web/packages/GGIR/GGIR.pdf






# GGIR Parameters to consider --------------------------------------------------

## idloc : defines the location of the relevant file id (e.g. the id of the particular participant to whom the file belongs) see
#           this link for description of parameter: https://wadpac.github.io/GGIR/articles/GGIRParameters.html?q=relyonguider#input-argumentsparameters-overview

## windowsizes : three values to define non-wear detection time-related parameters

## nonWearEdgeCorrection : accounts for possible artifactual movement at the end of collection period 
#                             when it is typical for participants to remove the device; this can be changed 
#                             if needed: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#implausible-wear-at-the-beginning-and-end-of-the-recording

## data_masking_strategy : parameter that allows you to define a period of the collected data that should be excluded (due to artifacts
#                           related to non-wear transportation of the device for example); see helper parameters below and also
#                           this link for further details: https://wadpac.github.io/GGIR/articles/chapter5_StudyProtocol.html#selectingmasking-the-data
##    hrs.del.start : related to above parameter; the number of hours to delete at start of recording period
##    hrs.del.end : related two above parameter; the number of hours to delete at end of recording period

## do.imp : parameter that you can use to disable the imputation process described in Resources. Recommended to not change this
#           unless doing controlled studies where sensor is known to be worn throughout the experiment. 
#           Link: https://wadpac.github.io/GGIR/articles/chapter6_DataImputation.html#imputation-of-invalid-epoch-data

## includedaycrit : parameter allows user to define the required number of valid hours in calendar day. Can provide two values with
#                     first value used in part 2 and second value in part 5

## HASPT.algo : indicate what algorithm to be used for sleep period detection (default = HDCZA, and uses z-angle as described by van Hees 2018)

## HASIB.algo : indicate what algorithm to use to define Sustained Inactivity Bouts (default = vanHees2015)
#               Link: https://wadpac.github.io/GGIR/articles/chapter8_SleepFundamentalsSibs.html#sib-vanhees2015

## SRI1_smoothing_wsize_hrs : for SRI calculation, defines the windowsize for smoothening detected SIB.
#                             Link: https://wadpac.github.io/GGIR/articles/SleepRegularityIndex.html#sri1-as-stored-in-ggir-part-4

## SRI1_smoothing_frac : for SRI calculation, defines percentage threshold of smoothening window necessary to define window as sleep. 
#                             E.G. if window set to 1, and frac to 0.8, then any 1hr rolling window with 80% or more defined as SIB, then entire window defined
#                                   as sleep. 
#                             Link: https://wadpac.github.io/GGIR/articles/SleepRegularityIndex.html#sri1-as-stored-in-ggir-part-4

## do.parallel

## mode

##maxNcore







# GGIR Documentation-related Notes ----------------------------------------
#   Below is a list of items/parameters deemed relevant to consider for our purposes:

###   DATA QUALITY:
###     - Imputation of Time gaps 
###       Link: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#time-gaps-in-actigraph-gt3x-and-ad-hoc-csv-files
###         Time gaps in ActiGraph gt3x are considered non-wear by GGIR; GGIR imputes
###           gaps shorter than 90 minutes using last recorded value; gaps >90min
###           are imputed at epoch level. See data_quality_report.csv in QC folder
###           for specific description of this activity during analysis.
###         Also to important to note if the devices were set to 'idle sleep mode'
###           which has the device pause collection if it deems it is not being worn.
###           Best to disable this function if using the package to ensure a 
###           "raw" data source.
###     - Non-wear detection
###       Link: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#non-wear-detection
###         Non-wear determined in GGIR by looking at standard deviation and range
###         in raw acceleration signals. Std dev and value range calculated per
###         60min window starting every 15min (therefore producing overlapping ranges)
###         Each 15min classified multiple times; if non-wear criteria met for any 
###         overlapping window, the 15min window is labelled as non-wear. Size of
###         time window (60min) and time intervals (15min) are defined by parameters:
###         windowsizes, which has three values:
###         (1st value = , 2nd value = interval, 3rd value = window)
###     - Implausible wear data
###       Link: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#implausible-wear-at-the-beginning-and-end-of-the-recording
###         This bit was a bit confusing but interesting considerations; I think keeping
###         and leaving defaults is appropriate.
###     - Invalid data handling
###       Link: https://wadpac.github.io/GGIR/articles/chapter6_DataImputation.html#imputation-of-invalid-epoch-data
###         Whether because of predicted non-wear or cliipping (implausible high values) or from masking, these invalid periods are 
###           imputed at the epoch level (default is 5sec). The process is to take the "mean metric value corresponding
###           to the valid values from the same time in the day on other days in the recording...if the same time interval
###           is marked invalid across all recorded days, the value is imputed by zero."
###   Defining Sleep Periods
###   Link: https://wadpac.github.io/GGIR/articles/chapter8_SleepFundamentalsSibs.html
###     - Controversial topic when considering use of accelerometry for defining "sleep" given that non-movement is typically necessary but
###         not sufficient to truly define sleep (e.g. resting & reading). GGIR therefore utilizes the Sustained Inactivity Bouts (SIB) as 
###         the appropriate term, as opposed to purely "sleep". There are several algorithms for determining SIB and sleep period time detection.
###         Given the reported challenges with specifying the algorithms for Cole-Kripke (was method previously used in our lab) for GGIR, we are
###         using the default vanHees algorithms, given also that it is this team that has created and maintains the GGIR package. 
###   SRI
###   Link: https://wadpac.github.io/GGIR/articles/SleepRegularityIndex.html#what-is-sri
###     - SRI data can be found in part 4 csv report on sleep. Relevant parameters here, and described in parameters, are SRI_1_smoothing_wsize_hrs
###         and SRI1_smoothing_frac which define the number of hours and the fraction of epochs defined as SIB necessary to classify window as sleep for
###         SRI purposes. If these parameters are left as their defaults, then the SRI calculation is better interpreted as rest regularity index,
###         while defining these parameters and thus smoothening the data may better reflect a true indicator of sleep regularity. There is an 
###         experimental SRI-2 metric that accounts for probable naps, but this is not considered in our current analysis. 
###     - Link to output/parameter definitions: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#ggir-output


################################################################################


# Notes (Private) -------------------------------------------------------------------
# 03/20/2026
### Issue with timezone when runing parts 2-5, learned there is the parameter desiredtz to define
###   the timezone for the analysis, which should be set to that of the timezone in which the device
###   was used and collected data. 
# 03.16.2026
### Given correspondence with Taren Sanders on GitHub, the issue is a memory/processing 
###   thing with the missing/uncalculated values ("allocating vectors..."). Doing a 
###   first pass of the data for only part 1 and with maxNcores set to 3. Then will
###   run the function, and set mode to 2:5 to run the remaining functions at full
###   processing speed (i.e. maxNcores to default).
# 03.06.2026
### Ok, I think the error has been fixed and I think is based off of two thing:
###   (1) Best to have all data stored locally, i.e. not via the VPN or on an
###       external server.
###   (2) Downloading the GGIR package from Github as opposed to CRAN seems best.
###       This will have most updated bug fixes (uploading of package updates
###       to CRAN seems a bit delayed with the developers.)
### Having errors with "cannot access" or something with running the code on
###   the available SP1 .gt3x data. Trying to troubleshoot; currently downloading
###   GGIR from github as opposed to Github (there seems to be a delay with when
###   the maintenance team updates CRAN with their own updates/bug fixes.)
# 03.05.2026
### Finalizing review of relevant parameters in GGIR using the documentation; 
###   continuing the review started yesterday; relevant notes included in the 
###   resources section above.
# 03.04.2026
### The sleeplog was not working for the life of me... but then I just deleted
###   all the output files and ran it again and it worked. I need to review the
###   config bit again so that I don't need to delete everything and run it again
###   but rather be able to indicate what additions/edits are being made (e.g.
###   adding a sleep log) and run the GGIR() package just from there or just 
###   including those edits.
### Reviewing the documentation today on GGIR to get a full sense of what is to 
###   be considered. Below is a list of items that I feel relevant:
###   DATA QUALITY:
###     - Imputation of Time gaps 
###       Link: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#time-gaps-in-actigraph-gt3x-and-ad-hoc-csv-files
###         Time gaps in ActiGraph gt3x are considered non-wear by GGIR; GGIR imputes
###         gaps shorter than 90 minutes useing last recorded value; gaps >90min
###         are imputed at epoch level. See data_quality_report.csv in QC folder
###         for specific description of this activity during analysis.
###     - Non-wear detection
###       Link: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#non-wear-detection
###         Non-wear determined in GGIR by looking at standard deviation and range
###         in raw acceleration signals. Std dev and value range calculated per
###         60min window starting every 15min (therefore producing overlapping ranges)
###         Each 15min classified multiple times; if non-wear criteria met for any 
###         overlapping window, the 15min window is labelled as non-wear. Size of
###         time window (60min) and time intervals (15min) are defined by parameters:
###         windowsizes, which has three values:
###         (1st value = defines epoch length with default = 5sec, 2nd value = interval, 3rd value = window)
###     - Implausible wear data
###       Link: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#implausible-wear-at-the-beginning-and-end-of-the-recording
###         This bit was a bit confusing but interesting considerations; I think keeping
###         and leaving defaults is appropriate.
###     - Link to output/parameter definitions: https://wadpac.github.io/GGIR/articles/chapter3_QualityAssessment.html#ggir-output
# 03.03.2026
### We are going to test out this GGIR package 

################################################################################
# Code Below -----
# Load Space --------------------------------------------------------------

# Clean
rm(list=ls())
gc()

# Set Working Directory
# setwd("X:/Research/OccHealthSci/shea_lab/00020553_SWIFT/SWIFT_Data/SWIFT_SleepRegularityIndex/GGIR") #set your working directory
# wd <- "X:/Research/OccHealthSci/shea_lab/00020553_SWIFT/SWIFT_Data/SWIFT_SleepRegularityIndex/GGIR" #set a variable equal to working directory

# Install Packages (not necessary if already installed; can always do this step if unsure)
install.packages("tidyverse")
install.packages("lubridate")
install.packages("remotes", dependencies = TRUE) 
remotes::install_github("wadpac/GGIR", dependencies = TRUE) #ensures GGIR downloaded from Github
...


# Load Packages
library(tidyverse) ##Good for manipulating data as you may need need
library(lubridate) ##Good for updating data related to date and time
library(GGIR) #GGIR package - version at time of drafting = 3.3-4



# The Code ----------------------------------------------------------------

# Define the file location that contains all the actigraphy files, ensuring that there are only acitgraphy files present.
# accel_dir <- "C:/Users/heblj/OneDrive - Oregon Health & Science University/Desktop/RawActigraphy_SP2"
accel_dir <- "E:/GGIR_SWIFT/SWIFT_SRI/"


## Mode 1 ------------------------------------------------------------------
### If you are working with a large dataset, best to run part 1 first, and also set
###   maxNcores to a lower value to save memory.

GGIR(datadir = accel_dir, ##file directory defined to this variable above.
     outputdir = "E:/GGIR_SWIFT/SWIFT_GGIR_Output/", ##output directory; must be different from datadir
     overwrite = TRUE, #will overwrite analysis of prior milestones/steps. I was having issuew with the default (FALSE) when trying to re-run after changing data sources.
     mode = 1, #only run the first part; most memory/computationally intensive
     maxNcores = 3, #limits number of 'workers' to preserve memory
     desiredtz = "America/Los_Angeles" ##Define the timezone (necessary if doing analysis in different timezone from devices)
     
     
     #=====================
     # Part 1 ----
     #=====================
     
     #=====================
     # Part 2 ----
     #=====================
     
     #=====================
     # Part 3 ----
     #=====================

     #=====================
     # Part 4 ----
     #=====================

     #=====================
     # Part 5 ----
     #=====================
)



# Modes 2:5 ---------------------------------------------------------------
### Now run the remaining parts given that the most computationally/memory intensive
###   part is complete. Reset the necessary parameters, as seen below. 

GGIR(datadir = accel_dir, ##file directory defined to this variable above.
     outputdir = "E:/GGIR_SWIFT/SWIFT_GGIR_Output/", ##output directory; must be different from datadir
     overwrite = TRUE, ##will overwrite analysis of prior milestones/steps. I was having issuew with the default (FALSE) when trying to re-run after changing data sources.
     mode = 2:5, ##run the remaining parts 
     maxNcores = 8, ##reset the workers to a larger value, though below my system's limit (which is I think 14-18?)
     
     #=====================
     # Part 1
     #=====================
     
     #=====================
     # Part 2
     #=====================
     idloc = 5, ##For our data, the participant id precedes the first space (i.e. " "), which this parameter defines

     #=====================
     # Part 3
     #=====================
     HASPT.algo = "HDCZA", #default detection method based on z-axis; see resources above and parameter description below
     HASIB.algo = "vanHees2015", #default SIB detection method; see resources above and parameter description below
     ignorenonwear = TRUE, #default setting; ignores non-wear periods from SIB detection
     
     SRI1_smoothing_wsize_hrs = 1, #number of hours that defines the smoothing window. See parameters above.
     SRI1_smoothing_frac = 0.8 #fraction of window that represents the floor for defining the window as sleep for SRI purposes; see parameters above. 
     #=====================
     # Part 4
     #=====================
     ##loglocation = "SleepLogFinalTesting.csv" # Can incorporate a sleeplog, though for our purposes of calculating SRI, this did not seem relevant
     
     #=====================
     # Part 5
     #=====================
)
