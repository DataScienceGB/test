## How have emissions from motor vehicle sources changed 
##         from 1999–2008 in Baltimore City?

library(sqldf)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC<- readRDS("./data/Source_Classification_Code.rds")

# Group Emissions by year 
# Selects only those comming from Vehicles in Baltimore Area
# After inspecting different columns i Selected Level.Three to look out 
# for Vehicles considering "all of them are motorized"
# there is a "Motor Vehicles" value, however it doesn't have data for Baltimore
NEI_grp=sqldf('select year, (sum(Emissions)) as sum_Emissions 
                from NEI 
                where SCC IN  (select SCC
                   from SCC where
                      "SCC.Level.Three" like "%Vehicles%"
                 )
                and fips="24510"
                group by year')
rm(NEI)
rm(SCC)

#Plot to show
png(file="plot5.png",width = 480, height = 480)
p<-qplot(year,sum_Emissions,data=NEI_grp,
          geom=c("point","smooth"),
                method="lm",color=year)+
            theme_bw(base_family="Arial")+
            labs(title="Baltimore City Motor Vehicles Emissions")+ 
            labs(y="Motor Vehicles Emissions (Tons)",x="Year")

print(p)
dev.off()
