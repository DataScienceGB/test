library(sqldf)

#load data

pc <- read.csv2.sql("./data/household_power_consumption.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')

datetime<-paste(pc$Date,pc$Time)
pc$Datetime<-strptime(datetime,"%d/%m/%Y %H:%M:%S")


#plot histogram
png(file="plot2.png",width = 480, height = 480)
plot(pc$Datetime,pc$Global_active_power,ylab="Global Active Power (kilowatts)",xlab="",type="l")
dev.off()

