library(sqldf)
library(ggplot2)

#Check for file existance
# if exists then load it else
#if not exists bring it from source and inflate it and load it
#overwrite inflated file if exists

csv_storm_file="./data/repdata_data_StormData.csv"
bz2_storm_file="./data/repdata_data_StormData.csv.bz2"

if (file.exists(bz2_storm_file) ) {
  stormdf=read.csv(bz2_storm_file,stringsAsFactors=F)
} else { if (!file.exists(bz2_storm_file)) {
       fileUrl<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
       download.file(fileUrl,dest=bz2_storm_file,method="curl")
       stormdf=read.csv(bz2_storm_file,stringsAsFactors=F) 
       } 
}
#Convert PROPDMG and CROPDMG to same "scale"(usd)
stormdf[!(stormdf$PROPDMGEXP %in% c("b","B","k","K","m","M")),"PROPDMGEXP"] = "1"
stormdf[stormdf$PROPDMGEXP %in% c("k","K"),"PROPDMGEXP"] = "1000"
stormdf[stormdf$PROPDMGEXP %in% c("m","M"),"PROPDMGEXP"] = "1000000"
stormdf[stormdf$PROPDMGEXP %in% c("b","B"),"PROPDMGEXP"] = "1000000000"

stormdf[!(stormdf$CROPDMGEXP %in% c("b","B","k","K","m","M")),"CROPDMGEXP"] = "1"
stormdf[stormdf$CROPDMGEXP %in% c("k","K"),"CROPDMGEXP"] = "1000"
stormdf[stormdf$CROPDMGEXP %in% c("m","M"),"CROPDMGEXP"] = "1000000"
stormdf[stormdf$CROPDMGEXP %in% c("b","B"),"CROPDMGEXP"] = "1000000000"

#Convert Strings to Numeric values
stormdf$PROPDMGEXP=as.numeric(stormdf$PROPDMGEXP)
stormdf$CROPDMGEXP=as.numeric(stormdf$CROPDMGEXP)

#summarize health_impact by event type
health_grp=sqldf("select EVTYPE,count(*) as number_of_events, sum(FATALITIES+INJURIES) as total_impact,
                   avg(FATALITIES+INJURIES) as impact_by_event 
                  from stormdf 
                  where (FATALITIES+INJURIES)!='NA' 
                  group by EVTYPE
                  order by 3 desc limit 10")

 sqldf("select sum(total_impact) as Total_Impact, 
               case EVTYPE when 'TORNADO' then 'T'
                           else 'NT' end as grp 
        from health_grp 
        group by case EVTYPE when 'TORNADO' then 'T' 
                             else 'NT' end")



econ_grp=sqldf("select EVTYPE,
               count(*) as number_of_events, 
                sum(
                   (PROPDMG*PROPDMGEXP) + 
                   (CROPDMG*CROPDMGEXP)
                  ) as econ_impact ,
                avg(
                   (PROPDMG*PROPDMGEXP) + 
                   (CROPDMG*CROPDMGEXP)
                  ) as econ_impact_by_event
                from stormdf 
                where (PROPDMG+CROPDMG)!='NA' 
                group by EVTYPE
                order by 3 desc limit 10"
               )
 
p<-ggplot(health_grp,aes(x=interval,y=Steps))+
            geom_line(color="blue",)+ 
            facet_wrap(~ week_fact,ncol=1)+ 
            theme_bw(base_family="Arial")+
            labs(y="Number of steps",x="Interval")+
            theme(strip.background = element_rect(colour = "black", fill = "orange"))

print(p)


#convert to Date type
#stormdf$BGN_DATE=paste(act_grp$date,"00:00:00")
stormdf$BGN_DATE=strptime(stormdf$BGN_DATE,"%m/%d/%Y %H:%M:%S")

#Create Steps histogram
hist(act_grp$Steps,col="red",main="Total number of steps taken per day", xlab="Steps taken a day")

#Calculate Mean and Median steps taken per day
mean(act_grp$Steps)
median(act_grp$Steps)

