library(sqldf)

#Read Activity
actdf=read.csv("./activity.csv",stringsAsFactors=F)

#summarize steps by day
act_grp=sqldf("select date, sum(steps) as Steps from actdf where steps!='NA' group by date")

#convert to Date type
act_grp$date=paste(act_grp$date,"00:00:00")
act_grp$date=strptime(act_grp$date,"%Y-%m-%d %H:%M:%S")

#Create Steps histogram
hist(act_grp$Steps,col="red",main="Total number of steps taken per day", xlab="Steps taken a day")

#Calculate Mean and Median steps taken per day
mean(act_grp$Steps)
median(act_grp$Steps)

