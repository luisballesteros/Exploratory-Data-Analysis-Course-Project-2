library(plyr)
library(datasets)
library(ggplot2)
library(dplyr)

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
## Question 5
# How have emissions from motor vehicle sources changed from 1999–2008 
# in Baltimore City?
SCC_filter <- data.frame(SCC$SCC, SCC$Short.Name)
vehicle <- filter(SCC_filter , grepl('vehicle', SCC.Short.Name, 
                                     ignore.case = TRUE))
Maryland <- subset(NEI, fips == 24510)
Maryland_vehicle <- Maryland %>% filter(SCC %in% vehicle$SCC.SCC)
str(vehicle )
png(file="plot5.png")
emission_year <- with(Maryland_vehicle, tapply(Emissions, year, sum))
barplot(emission_year, main = "Total Baltimore City PM2.5 emission from from vehicle for year",
        xlab="Year", ylab="Total PM2.5 (tons)")
dev.off()
