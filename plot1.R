#load data
library(sqldf)

pc <- read.csv2.sql("./data/power_comsumption_feb2007.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')

#plot histogram
png(file="plot1.png")
hist(pc$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)" ,col="red")
#dev.copy(png,file="plot1.png")
dev.off()


