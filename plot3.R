library(sqldf)

#load data

pc <- read.csv2.sql("./data/power_comsumption.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')

#add a date-time varialbe to DF 
datetime<-paste(pc$Date,pc$Time)
pc$Datetime<-strptime(datetime,"%d/%m/%Y %H:%M:%S")


#plot histogram
#png(file="plot3.png",width = 480, height = 480)

plot(pc$Datetime,pc$sub_metering_1,ylab="Energy sub metering", xlab="",type="l")

#dev.off()

