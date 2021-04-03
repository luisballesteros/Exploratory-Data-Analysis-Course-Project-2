library(plyr)
library(datasets)
library(ggplot2)

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
## Question 3
# Of the four types of sources indicated by the 
# type (point, nonpoint, onroad, nonroad) variable, which of these four sources 
# have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? Use the ggplot2 
# plotting system to make a plot answer this question.
Maryland <- subset(NEI, fips == 24510)

png(file="plot3.png")

g <- ggplot(Maryland, aes(x = year, y = Emissions))
g + geom_col(colour="deepskyblue1", fill="deepskyblue1") + 
  facet_grid(~ type) + 
  ggtitle("Maryland. Total PM2.5 emission from source type and year") + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5))
dev.off()
