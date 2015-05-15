#Have total emissions from PM2.5 decreased in the Baltimore City, 
#  Maryland (fips == 24510) from 1999 to 2008? 
#Use the base plotting system to make a plot answering this question.

library(sqldf)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")

# Group Emissions by year
NEI_grp=sqldf("select year, (sum(Emissions)/1000) as sum_Emissions from NEI 
                where fips='24510' group by year")

#Plot to show
png(file="plot2.png",width = 480, height = 480)
with (NEI_grp, 
       plot(year,sum_Emissions, type="b",
             main="Baltimore City
                   PM2.5 Emissions from 1999 to 2008"
             ,ylab="Yearly Thousands of Tons PM2.5 Emissions",pch=10
             ,col="green")
      )
tend<-lm(sum_Emissions~year,NEI_grp)
abline(tend,lwd="2",col="blue")
legend("topright",legend=c("PM2.5 Emissions","Emissions Trend"),col=c("green","blue"), lty=1)
dev.off()

