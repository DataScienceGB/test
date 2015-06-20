library(sqldf)
library(xtable)
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
#set impact to millions of usd
econ_grp$econ_impact=round(econ_grp$econ_impact/1000000 ,0)
 
p<-ggplot(health_grp,aes(x=reorder(EVTYPE, +total_impact),y=total_impact)) +
            geom_bar(stat="identity",fill=1:10) +
            scale_fill_manual(values=c(1:10)) + 
            coord_flip() +
            geom_text(aes(y=total_impact,ymax=total_impact, 
                           label=total_impact)
                           ,position= position_dodge(width=0.2), hjust=.5 ,
                            vjust=1.2,
                            size=rel(3),angle=90)+
            theme_bw(base_family = "Arial") +
            theme(panel.background = element_rect(fill = "lightblue"),
                  panel.grid.minor = element_line(linetype = "dotted")) +
            labs(title="Severe Weather Public Health Impact")+
            labs(y="Injuries + Fatalities" ,x="Event Type")
            

#print(p)

                           #label=round(econ_impact/1000000,2)
g<-ggplot(econ_grp,aes(x=reorder(EVTYPE, +econ_impact),y=econ_impact)) +
            geom_bar(stat="identity",fill=1:10) +
            scale_fill_manual(values=c(1:10)) +
            coord_flip() +
            geom_text(aes(y=econ_impact,ymax=econ_impact,
                           label= econ_impact)
                           ,position= position_dodge(width=0.2), hjust=.5 ,
                            vjust=1.2,
                            size=rel(3),angle=90)+
            theme_bw(base_family = "Arial") +
            theme(panel.background = element_rect(fill = "lightblue"),
                  panel.grid.minor = element_line(linetype = "dotted")) +
            labs(title="Severe Weather Economic Impact")+
            labs(y="Properties and Crops Damage (Millions of Dollars)" ,x="Event Type")


#print(g)

grid.arrange(g,p,nrow=2)


#Not used in porject but useful
#convert to Date type
#stormdf$BGN_DATE=strptime(stormdf$BGN_DATE,"%m/%d/%Y %H:%M:%S")


