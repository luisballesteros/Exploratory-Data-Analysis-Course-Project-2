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
## Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California fips == "06037".
# Which city has seen greater changes over time in motor vehicle emissions?
SCC_filter <- data.frame(SCC$SCC, SCC$Short.Name)
vehicle <- filter(SCC_filter , grepl('vehicle', SCC.Short.Name, 
                                     ignore.case = TRUE))
Maryland_California <- subset(NEI, (fips == 24510 |  fips == "06037"))
MCV<- Maryland_California %>% filter(SCC %in% vehicle$SCC.SCC)
str(MCV)
# str(Maryland_California)
png(file="plot6.png")

Maryland <- subset(NEI, fips == "24510")
California <- subset(NEI, fips == "06037")
emission_Maryland <- with(Maryland, tapply(Emissions, year, sum))
emission_California <- with(California, tapply(Emissions, year, sum))
par(mfrow = c(2,1))
barplot(emission_Maryland/1e3, 
        main = "Baltimor City PM2.5 emission from emissions from motor vehicle sources for year",
        xlab="Year", ylab="Total PM2.5 (Thousands tons)")
barplot(emission_California/1e3, 
        main = "Los Angeles County PM2.5 emission from emissions from motor vehicle sources for year",
        xlab="Year", ylab="Total PM2.5 (Thousands tons)")
dev.off()