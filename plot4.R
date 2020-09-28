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


# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
combustion_Related <- grepl("comb", SCC$SCC.Level.One, ignore.case=TRUE)
coal_Related <- grepl("coal", SCC$SCC.Level.Four, ignore.case=TRUE) 
coal_Combustion <- (combustion_Related & coal_Related)
combustion_SCC <- SCC[coal_Combustion,]$SCC
combustion_NEI <- NEI[NEI$SCC %in% combustion_SCC,]

ggp <- ggplot(combustion_NEI,aes(factor(year),Emissions/10^5)) +
  geom_bar(stat="identity",fill="#597F57",width=0.75) +
  theme_bw() +  guides(fill=FALSE) +
  labs(x="year", y=expression("Total PM"[2.5]*" Emission (10^5 Tons)")) + 
  labs(title=expression("PM"[2.5]*" Coal Combustion Source Emissions Across US from 1999-2008"))

print(ggp)

## Saving to file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()