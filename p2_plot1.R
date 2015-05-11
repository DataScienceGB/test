library(sqldf)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")

# Group Emissions by year
NEI_grp=sqldf("select year, (sum(Emissions)/1000) as sum_Emissions from NEI group by year")

#Plot to show
png(file="plot1.png",width = 480, height = 480)
with (NEI_grp,
       plot(year,sum_Emissions, type="b",
             main="PM2.5 Emissions from 1999 to 2008"
             ,ylab="Yearly Thousands of Tons PM2.5 Emissions",pch=15
             ,col="blue")
      )
tend<-lm(sum_Emissions~year,NEI_grp)
abline(tend,lwd="2",col="black")
dev.off()

