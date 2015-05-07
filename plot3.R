library(sqldf)

#load data

pc <- read.csv2.sql("./data/power_comsumption.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')

#add a date-time varialbe to DF 
datetime<-paste(pc$Date,pc$Time)
pc$Datetime<-strptime(datetime,"%d/%m/%Y %H:%M:%S")


#plot histogram
png(file="plot3.png",width = 480, height = 480)

plot(pc$Datetime,pc$Sub_metering_1,ylab="Energy sub metering", xlab="",type="l")
par(new=T)
plot(pc$Datetime,pc$Sub_metering_2,ylab="",xlab="",type="l",col="red",ylim=range(pc$Sub_metering_1))
par(new=T)
plot(pc$Datetime,pc$Sub_metering_3,ylab="",xlab="",type="l",col="blue",ylim=range(pc$Sub_metering_1))

legend("topright",legend=colnames(pc)[grep('Sub*',colnames(pc))],col=c("black","red","blue"), lty=1)
dev.off()

