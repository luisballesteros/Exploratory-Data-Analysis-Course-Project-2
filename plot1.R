library(plyr)
library(datasets)

# Create data folder if it does not exist
if (!file.exists("data")) {
  dir.create("data")
}

# Download file to local "data" folder
fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
download.file(fileUrl, destfile = "./data/NEI_data.zip", method = "curl")
dateDownloaded <- date()
dateDownloaded 
# Unzip file in "data" directory
unzip(zipfile = "./data/NEI_data.zip", exdir = "./data")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("data/summarySCC_PM25.rds")
SCC <- readRDS("data/Source_Classification_Code.rds")
head(NEI)
str(NEI)
head(SCC)
str(SCC)
# transform variables to categorical 
NEI <- transform(NEI, fips = factor(fips), SCC = factor(SCC), 
                 Pollutant = factor(Pollutant), type = factor(type),
                 year = factor(year))
## Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 
# 2008? Using the base plotting system, make a plot showing the total PM2.5
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

emission_year <- tapply(NEI$Emissions, NEI$year, sum)
# emission_year <- ddply(NEI, "year", summarise, total = sum(Emissions)/1e6)
# options(scipen=10)

png(file="plot1.png")
barplot(emission_year/1e6, main = "Total PM2.5 emission from all sources for year",
        xlab="Year", ylab="Total PM2.5 (Millions tons)")
dev.off()