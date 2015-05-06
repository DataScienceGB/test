library(sqldf)
library(dplyr)

#load data

pc <- read.csv2.sql("./data/power_comsumption_feb2007.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')
pc=mutate(pc,Date=as.Date($Date)
#plot histogram
#png(file="plot2.png")
plot(pc$Global_active_power,xlab=pc$Date,ylab="Global Active Power (kilowatts)" ,pch="")
lines(pc$Global_active_power)
#dev.copy(png,file="plot2.png")
#dev.off()


