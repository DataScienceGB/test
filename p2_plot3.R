##Of the four types of sources indicated by the type 
## (point, nonpoint, onroad, nonroad) variable, which of these four sources 
##  have seen decreases in emissions from 1999–2008 for Baltimore City? 
##  Which have seen increases in emissions from 1999–2008? 
## Use the ggplot2 plotting system to make a plot answer this question.

library(sqldf)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")

# Group Emissions by year in Baltimore
NEI_grp=sqldf("select year, type,(sum(Emissions)/100) as sum_Emissions 
                from NEI 
                where fips='24510' 
                group by year,type")
rm(NEI)

#Plot to show
png(file="plot3.png",width = 480, height = 480)
p<-qplot(year,sum_Emissions,data=NEI_grp,facets=.~type,geom=c("point","smooth"),method="lm",color=type)+ labs(title="Baltimore City Emissions by Type")+labs(y="PM2.5 Emissions (100's of Tons)",x="Year")

print(p)
dev.off()
