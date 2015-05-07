library(sqldf)

#load data
pc <- read.csv2.sql("./data/household_power_consumption.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')

#plot histogram
#use red color

png(file="plot1.png" ,width = 480, height = 480)
hist(pc$Global_active_power,main="Global Active Power",xlab="Global Active Power (kilowatts)" ,col="red")
dev.off()


