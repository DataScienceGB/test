
##Across the United States, how have emissions from coal combustion-related 
## sources changed from 1999–2008?

library(sqldf)
library(ggplot2)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("./data/summarySCC_PM25.rds")
SCC<- readRDS("./data/Source_Classification_Code.rds")

# Group Emissions by year 
# Selects only those comming from Coal Combustion
NEI_grp=sqldf('select year, (sum(Emissions)/100) as sum_Emissions 
                from NEI 
                where SCC IN  (select SCC
                   from SCC where
                      "SCC.Level.One" like "%Combustion%"
                       and "EI.Sector" like "%Coal%"
                 )
                group by year')
rm(NEI)
rm(SCC)

#Plot to show
png(file="plot4.png",width = 480, height = 480)
p<-qplot(year,sum_Emissions,data=NEI_grp,
          geom=c("point","smooth"),
                method="lm",color=year)+
            theme_bw(base_family="Times")+
            labs(title="Global US Coal Combustion")+ 
            labs(y="Coal Combustion Emissions (100's of Tons)",x="Year")

print(p)
dev.off()
