library(sqldf)

#Read Activity
actdf=read.csv("./activity.csv",stringsAsFactors=F)

#average days by interval
act_avg=sqldf("select  interval,avg(steps) as Steps from actdf where steps!='NA' group by interval")

#create a new data set with to fill missing values
actdf_imputed=actdf

#impute NA values using average steps by interval
#actdf1$steps[isna]=act_avg$Steps
#Select those rows having na values with is.na and assign them the averege value of its interval
actdf_imputed$steps[is.na(actdf$steps)]=act_avg$Steps

#summarize steps by day
act_grp=sqldf("select date, sum(steps) as Steps from actdf_imputed group by date")

#Create Steps histogram
hist(act_grp$Steps,col="red",main="Total number of steps taken per day", xlab="Steps taken a day")

#Calculate Mean and Median steps taken per day
print(c(mean(act_grp$Steps),median(act_grp$Steps)))

