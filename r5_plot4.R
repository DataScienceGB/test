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
act_week=sqldf("select interval,(case is_weekend
                              when 1 then 'weekend'
                              else     'weekday'
                             end) as week_fact, avg(steps) as Steps 
                 from actdf_imputed 
                 group by interval,is_weekend"
               )
#converts new column to a factor
act_week$week_fact=as.factor(act_week$week_fact)
#act_week$date=paste(act_week$date,"00:00:00")
#act_week$date=strptime(act_week$date,"%Y-%m-%d %H:%M:%S")

#load ggplot2
library(ggplot2)

#Create  weekday vs weekend comparission chart
p<-ggplot(act_week,aes(x=interval,y=Steps))+
            geom_line(color="blue",)+ 
            facet_wrap(~ week_fact,ncol=1)+ 
            theme_bw(base_family="Arial")+
            labs(y="Number of steps",x="Interval")+
            theme(strip.background = element_rect(colour = "black", fill = "orange"))

print(p)


