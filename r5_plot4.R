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

#Add a new column indicating if the date is a weekday or weekend 
#0,6 means sunday and saturday, therefore is_weekend=TRUE
actdf_imputed$is_weekend=(strftime(as.Date(actdf_imputed$date),'%w') %in% c(0,6))

#average steps by day
act_week=sqldf("select date,(case is_weekend
                              when 1 then 'weekend'
                              else     'weekday'
                             end) as week_fact, avg(steps) as Steps 
                 from actdf_imputed 
                 group by date,is_weekend"
               )
#converts new column to a factor
act_week$week_fact=as.factor(act_week$week_fact)
library(ggplot2)

#Create Steps histogram
#Calculate Mean and Median steps taken per day

