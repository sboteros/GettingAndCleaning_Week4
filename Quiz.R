# Week 4 Quiz
# Getting and cleaning data course
# Data science specialization
# Santiago Botero S.
# sboteros@unal.edu.co
# 2019/06/22
# Encoding: UTF-8

# Configuración general
directorio <- "C:/Users/sbote/OneDrive/Documentos/DataScienceSpecialization/3 Getting and cleaning data/Week4/GettingAndCleaning_Week4"
setwd(directorio)

if (!dir.exists("./data/")) {dir.create("./data/")}

paquetes <- c("dplyr", "tidyr", "quantmod", "lubridate")
for (i in paquetes) {
  if (!require(i, character.only = TRUE)) {
    install.packages(i)
  }
  library(i, character.only = TRUE)
}
rm(list = c("paquetes", "i"))

# 1. The American Community Survey distributes downloadable data about United
# States communities. Download the 2006 microdata survey about housing for the
# state of Idaho using download.file() from here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv and load
# the data into R. The code book, describing the variable names is here:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# Apply strsplit() to split all the names of the data frame on the characters
# "wgtp". What is the value of the 123 element of the resulting list?

  if (!file.exists("./data/idaho.csv")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",
                  "./data/idaho.csv")
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf",
                  "./data/idaho.pdf", method = "curl")
  }
  idaho <- read.csv("./data/idaho.csv") %>% tbl_df %>% print
  idaho1 <- strsplit(names(idaho), "wgtp")
  idaho1[[123]]
  
# 2. Load the Gross Domestic Product data for the 190 ranked countries in this
# data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# Remove the commas from the GDP numbers in millions of dollars and average
# them. What is the average? Original data sources:
# http://data.worldbank.org/data-catalog/GDP-ranking-table
  
  if (!file.exists("./data/gdp.csv")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",
                  "./data/gdp.csv")
  }
  gdp <- read.csv("./data/gdp.csv", header = FALSE, skip = 5,
                  na.strings = "", stringsAsFactors = FALSE) %>%
    tbl_df %>%
    select(country = V1, ranking = V2, countryNames = V4, gdp = V5) %>%
    mutate(ranking = as.numeric(ranking),
           gdp = gsub(",", "", gdp),
           gdp = as.numeric(gdp)) %>%
    na.omit %>%
    print
  
  summarize(gdp, mean(gdp))

# 3. In the data set from Question 2 what is a regular expression that would
# allow you to count the number of countries whose name begins with "United"?
# Assume that the variable with the country names in it is named countryNames.
# How many countries begin with United?
# grep("*United",countryNames), 2
# grep("United$",countryNames), 3
# grep("*United",countryNames), 5
 length(grep("^United",gdp$countryNames))

# 4. Load the Gross Domestic Product data for the 190 ranked countries in this
# data set: https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv Load
# the educational data from this data set:
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# Match the data based on the country shortcode. Of the countries for which the
# end of the fiscal year is available, how many end in June? Original data
# sources: http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats
 
 if (!file.exists("./data/education.csv")) {
   download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv",
                 "./data/education.csv")
 }
 education <- read.csv("./data/education.csv") %>% tbl_df %>% print

 merged <- merge(gdp, education, by.x = "country", by.y = "CountryCode") %>%
   tbl_df %>% print
 
 # The end of fiscal year is in Special.Notes
 length(grep("^(fiscal year end: june)", merged$Special.Notes, ignore.case = TRUE))
 
# 5. You can use the quantmod (http://www.quantmod.com/) package to get
# historical stock prices for publicly traded companies on the NASDAQ and NYSE.
# Use the following code to download data on Amazon's stock price and get the
# times the data was sampled.
 
  amzn <- getSymbols("AMZN",auto.assign=FALSE)
  sampleTimes <- index(amzn)
  
# How many values were collected in 2012? How many values were collected on
# Mondays in 2012?
  length(sampleTimes[year(sampleTimes) == 2012])
  length(sampleTimes[year(sampleTimes) == 2012 & 
                       wday(sampleTimes, week_start = 1) == 1])
  