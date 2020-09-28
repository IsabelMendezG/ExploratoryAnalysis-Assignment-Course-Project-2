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

#How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

vehicles <- grepl("vehicle", SCC$SCC.Level.Two, ignore.case=TRUE)
vehicles_SCC <- SCC[vehicles,]$SCC
vehicles_NEI <- NEI[NEI$SCC %in% vehicles_SCC,]

#(fips == "24510") as Plot2
BaltimoreVehicles_NEI <- vehicles_NEI[vehicles_NEI$fips=="24510",]

ggp <- ggplot(BaltimoreVehicles_NEI,aes(factor(year),Emissions)) +
  geom_bar(stat="identity",fill="#95C11F",width=0.9) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Motor Vehicle Source Emissions in Baltimore from 1999-2008"))
print(ggp)

## Saving to file
dev.copy(png, file="plot5.png", height=480, width=480)
dev.off()