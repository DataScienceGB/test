library(sqldf)
library(R.utils)

#Check for file existance
# if exists then load it else
#if not exists bring it from source and inflate it and load it
#overwrite inflated file if exists

csv_storm_file="./data/repdata_data_StormData.csv"
bz2_storm_file="./data/repdata_data_StormData.csv.bz2"

if (file.exists(csv_storm_file) ) {
  stormdf=read.csv(csv_storm_file,stringsAsFactors=F)
}
else  if (!file.exists(bz2_storm_file)) {
       fileUrl<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
       download.file(fileUrl,dest=bz2_storm_file,method="curl")
       stormdf=read.csv(bunzip2(bz2_storm_file,overwrite=T,remove=F),stringsAsFactors=F) 
} 

#summarize damage by event type
health_grp=sqldf("select EVTYPE,count(*) as N, sum(FATALITIES+INJURIES) as health_impact 
                  from stormdf 
                  where (FATALITIES+INJURIES)!='NA' 
                  group by EVTYPE")


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

econ_grp=sqldf("select EVTYPE,
               count(*) as N, 
                sum(
                   (PROPDMG*PROPDMGEXP) + 
                   (CROPDMG*CROPDMGEXP)
                  ) as econ_impact 
                from stormdf 
                where (PROPDMG+CROPDMG)!='NA' 
                group by EVTYPE"
               )

#convert to Date type
#stormdf$BGN_DATE=paste(act_grp$date,"00:00:00")
stormdf$BGN_DATE=strptime(stormdf$BGN_DATE,"%m/%d/%Y %H:%M:%S")

#Create Steps histogram
hist(act_grp$Steps,col="red",main="Total number of steps taken per day", xlab="Steps taken a day")

#Calculate Mean and Median steps taken per day
mean(act_grp$Steps)
median(act_grp$Steps)

