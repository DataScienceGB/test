#load data
#pc<-read.csv2("./data/power_comsumption_feb2007.txt",stringsAsFactors=FALSE,na.strings="?",dec=".",colClasses=c("Date","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

#pc<-read.csv2("./data/power_comsumption_feb2007.txt",stringsAsFactors=FALSE,na.strings="?",dec=".",colClasses=c("Date","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))
library(sqldf)
pc <- read.csv2.sql("./data/power_comsumption_feb2007.txt", sql = 'select * from file where Date in ("1/2/2007","2/2/2007")')


## Q3
# regular expression to count number of countries whose name starts with "United",
#how may are them. 
#gdp[grep("^United",gdp$X.3),"X.3"]
#[1] "United States"        "United Kingdom"       "United Arab Emirates"

## Q4
## Load educational data
#Match with GDP pased on country shortcode
#For those having fiscal year available how may end in June
#mergeData[grep("Fiscal year end: [j|J]une",mergeData$Special.Notes),c("Long.Name","Special.Notes")]
#nrow(mergeData[grep("Fiscal year end: [j|J]une",mergeData$Special.Notes),c("Long.Name","Special.Notes")])
#[1] 13


#country<-read.csv("./data/country.csv",stringsAsFactors=FALSE)
#mergeData=merge(country,gdp,by.x="CountryCode",by.y="X",all=TRUE)


#library('plyr')
#ddply(sortData,.(Income.Group),summarize,mean=mean(X.1,na.rm=T))
#          Income.Group      mean
#1                            NaN
#2 High income: nonOECD  91.91304
#3    High income: OECD  32.96667
#4           Low income 133.72973
#5  Lower middle income 107.70370
#6  Upper middle income  92.13333
#7                 <NA> 131.00000


##Q5
##Cut data into 5 Quantile Groups
## how many countries in the high rank are in lower_midleIncome==5
##sortData$RankGroups=cut(sortData$X.1,breaks=quantile(sortData$X.1,na.rm=T,c(.2,.4,.6,.8,1)))
#sortData$RankGroups=cut(sortData$X.1,breaks=quantile(sortData$X.1,na.rm=T,probs=seq(0,1,.2))

##Table Income.Group vs RankGroups
#table(sortData$Income.Group,sortData$RankGroups)
#                       (1,38.8] (38.8,76.6] (76.6,114] (114,152] (152,190]
#                              0           0          0         0         0
#  High income: nonOECD        4           5          8         4         2
#  High income: OECD          17          10          1         1         0
#  Low income                  0           1          9        16        11
#  Lower middle income         5          13         12         8        16
#  Upper middle income        11           9          8         8         9

