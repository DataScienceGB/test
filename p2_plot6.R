## Compare emissions from motor vehicle sources in Baltimore City 
## with emissions from motor vehicle sources in Los Angeles County, California
##   (fips == "06037"). 
##  Which city has seen greater changes over time in motor vehicle emissions?


library(sqldf)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC<- readRDS("./data/Source_Classification_Code.rds")

# Group Emissions by year 
# Selects only those comming from Vehicles in Baltimore Area
#             and LA, Ca Area
# After inspecting different columns i Selected Level.Three to look out 
# for Vehicles considering "all of them are motorized"
# there is a "Motor Vehicles" value, however it doesn't have data for Baltimore

NEI_grp=sqldf('select year, case fips 
                              when "24510" then "Baltimore City"
                              when "06037" then "Los Angeles County"
                            end as fips
                ,(sum(Emissions)) as sum_Emissions 
                from NEI 
                where SCC IN  (select SCC
                   from SCC where
                      "SCC.Level.Three" like "%Vehicles%"
                 )
                and fips in( "24510","06037")
                group by year,fips')
rm(NEI)
rm(SCC)

#Plot to show
png(file="plot6.png",width = 480, height = 480)
p<-qplot(year,sum_Emissions,data=NEI_grp,
          facets=.~fips,
          geom=c("point","smooth"),
                method="lm",color=year)+
            theme_bw(base_family="Arial")+
            labs(title="Baltimore/Los Angeles Motor Vehicles Emissions")+ 
            labs(y="Motor Vehicles Emissions (Tons)",x="Year")

print(p)
dev.off()
