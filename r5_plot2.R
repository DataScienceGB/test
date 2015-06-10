library(sqldf)

#Read Activity
actdf=read.csv("./activity.csv",stringsAsFactors=F)

#average days by interval
act_avg=sqldf("select  interval,avg(steps) as Steps from actdf where steps!='NA' group by interval")

#convert to Date type
#act_grp$date=paste(act_grp$date,"00:00:00")
#act_grp$date=strptime(act_grp$date,"%Y-%m-%d %H:%M:%S")

#Create  create timeline
plot(act_avg$interval,act_avg$Steps,type="l",col="blue",main="Average number of steps by interval", ylab="Average steps taken by interval",xlab="5-minute day interval")

#Calculate maximum 5-minute interval across all days
sqldf("select interval, max(Steps) from act_avg group by interval order by 2 desc limit 1")
