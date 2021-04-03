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
## Question 4
# Across the United States, how have emissions from coal combustion-related
# sources changed from 1999–2008?
SCC_filter <- data.frame(SCC$SCC, SCC$Short.Name)
coal <- filter(SCC_filter , grepl('coal', SCC.Short.Name, ignore.case = TRUE))
NEI_coal <- NEI %>% filter(SCC %in% coal$SCC.SCC)
str(coal)
png(file="plot4.png")
emission_year <- tapply(NEI_coal$Emissions, NEI_coal$year, sum)
barplot(emission_year/1e3, main = "Total USA PM2.5 emission from from coal combustion-related for year",
        xlab="Year", ylab="Total PM2.5 (Thousands tons)")
dev.off()
