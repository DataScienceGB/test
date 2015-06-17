library(sqldf)
library(R.utils)

#Check for file existance
# if exists then load it else
#if not exists bring it from source and inflate it and load it
#overwrite inflated file if exists

csv_storm_file="./data/repdata_data_StormData.csv"
bz2_storm_file="./data/repdata_data_StormData.csv.bz2"

if (file.exists(csv_storm_file) {
  stormdf=read.csv(csv_storm_file,stringsAsFactors=F)
}
else
    if (!file.exists(bz2_storm_file)) {
       fileUrl<-"https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2"
       download.file(fileUrl,dest=bz2_storm_file,method="curl")
       stormdf=read.csv(bunzip2(bz2_storm_file,overwrite=T),stringsAsFactors=F)
     }


#summarize damage by event type
health_grp=sqldf("select EVTYPE, sum(FATALITIES+INJURIES) as health_impact from stormdf where (FATALITIES+INJURIES)!='NA' group by EVTYPE")
econ_grp=sqldf("select EVTYPE, sum(+INJURIES) as health_impact from stormdf where (FATALITIES+INJURIES)!='NA' group by EVTYPE")

#convert to Date type
act_grp$date=paste(act_grp$date,"00:00:00")
act_grp$date=strptime(act_grp$date,"%Y-%m-%d %H:%M:%S")

#Create Steps histogram
hist(act_grp$Steps,col="red",main="Total number of steps taken per day", xlab="Steps taken a day")

#Calculate Mean and Median steps taken per day
mean(act_grp$Steps)
median(act_grp$Steps)

