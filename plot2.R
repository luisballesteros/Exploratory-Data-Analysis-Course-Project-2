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
## Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# fips == "24510" from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.

Maryland <- subset(NEI, fips == 24510)

emission_year <- tapply(Maryland$Emissions, Maryland$year, sum)
# emission_year <- ddply(NEI, "year", summarise, total = sum(Emissions)/1e6)
# options(scipen=10)

png(file="plot2.png")
barplot(emission_year/1e6, main = "Maryland. Total PM2.5 emission from all sources for year",
        xlab="Year", ylab="Total PM2.5 (Millions tons)")
dev.off()