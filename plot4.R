library(sqldf)

#load data

pc <- read.csv2.sql("./data/household_power_consumption.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')

#add a date-time varialbe to DF 
datetime<-paste(pc$Date,pc$Time)
pc$Datetime<-strptime(datetime,"%d/%m/%Y %H:%M:%S")

png(file="plot4.png",width = 480, height = 480)
#Set 2 rows 2 columns of plots
par(mfrow=c(2,2))

#plot  Globa Active Power vs date
plot(pc$Datetime,pc$Global_active_power,ylab="Global Active Power",xlab="",type="l")

#plot  Voltage vs date
with(pc,
plot(Datetime,Voltage,ylab="Voltage",type="l")
)

#plot Sub metering
plot(pc$Datetime,pc$Sub_metering_1,ylab="Energy sub metering", xlab="",type="l")
par(new=T)
plot(pc$Datetime,pc$Sub_metering_2,ylab="",xlab="",type="l",col="red",ylim=range(pc$Sub_metering_1))
par(new=T)
plot(pc$Datetime,pc$Sub_metering_3,ylab="",xlab="",type="l",col="blue",ylim=range(pc$Sub_metering_1))
#bty removes box from legend
legend("topright",legend=colnames(pc)[grep('Sub*',colnames(pc))],col=c("black","red","blue"), lty=1,bty="n")

#plot  Global Reactive Power vs date
with(pc,
plot(Datetime,Global_reactive_power,type="l")
)
dev.off()

