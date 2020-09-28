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

#Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips == "06037"). Which city has seen greater changes over time in motor vehicle emissions?

# Gather the subset of the NEI data which corresponds to vehicles
Baltimore_LA <- NEI[NEI$type=="ON-ROAD" & (NEI$fips=="24510" |NEI$fips=="06037"), ]
Baltimore_LA_annual <- aggregate(Emissions ~ year+fips, Baltimore_LA, sum)
Baltimore_LA_annual$year=as.factor(Baltimore_LA_annual$year)
Baltimore_LA_annual$fips[Baltimore_LA_annual$fips=="24510"]='Baltimore'
Baltimore_LA_annual$fips[Baltimore_LA_annual$fips=="06037"]='Los Angeles'

ggplot(Baltimore_LA_annual, aes(x=year,y=Emissions))+
  ggtitle(expression("Total PM"[2.5]*" Emission (Kilo-Tons)"))+
  geom_bar(aes(fill=year),width=.5,stat="identity")+facet_grid(.~fips)+
  theme(axis.text=element_text(color="red",size=10))+coord_flip()+
  theme(axis.title.x=element_text(color='black',vjust=-1),
        axis.title.y=element_text(color='black',vjust=1.5),
        plot.title=element_text(color="blue",size=12,vjust=1))



## Saving to file
dev.copy(png, file="plot6.png", height=480, width=480)
dev.off()