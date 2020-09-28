library("data.table")

#Save file in that folder



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

# Aggregate by sum the total emissions by year
TotalEmissions <- aggregate(Emissions ~ year,NEI, sum)

barplot(
  (TotalEmissions$Emissions)/10^6,
  names.arg=TotalEmissions$year,
  xlab="Year",
  ylab="PM2.5 Emissions (10^6 Tons)",
  main="Total PM2.5 Emissions From All US Sources"
)


## Saving to file
dev.copy(png, file="plot1.png", height=480, width=480)
dev.off()