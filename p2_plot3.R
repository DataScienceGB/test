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
NEI_grp=sqldf("select year, type,(sum(Emissions)/1000) as sum_Emissions 
                from NEI 
                where fips='24510' 
                group by year,type")
rm(NEI)

#Plot to show
#png(file="plot1.png",width = 480, height = 480)
qplot(year,sum_Emissions,data=NEI_grp,facets=.~type,geom=c("point","smooth"))

#tend<-lm(sum_Emissions~year,NEI_grp)
#abline(tend,lwd="2",col="black")
#dev.off()

