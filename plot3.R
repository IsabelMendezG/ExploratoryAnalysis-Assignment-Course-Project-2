library("data.table")
library(ggplot2)



# Download archive file, if it does not exist
archiveFile <- "NEI_data.zip"
if(!file.exists(archiveFile)) {
  archiveURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  if(Sys.info()["sysname"] == "Darwin") {
    download.file(url=archiveURL,destfile=archiveFile,method="curl")
  } else {
    download.file(url=url,destfile=archiveFile)
  }
}
if(!(file.exists("summarySCC_PM25.rds") && 
     file.exists("Source_Classification_Code.rds"))) { unzip(archiveFile) }

# Load the data:
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


# Subset NEI data by Baltimore's fip.
BaltimoreNEI <- NEI[NEI$fips=="24510",]


# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a plot answer this question.

ggp <- ggplot(BaltimoreNEI,aes(factor(year),Emissions,fill=type)) +
  geom_bar(stat="identity") +
  theme_bw() + guides(fill=FALSE)+
  facet_grid(.~type,scales = "free",space="free") + 
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (Tons)")) + 
  labs(title=expression("PM"[2.5]*" Emissions, Baltimore City 1999-2008 by Source Type"))

print(ggp)

## Saving to file
dev.copy(png, file="plot3.png", height=480, width=480)
dev.off()
