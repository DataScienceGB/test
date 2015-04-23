#Download files
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
download.file(fileUrl,dest="./data/gdp.csv",method="curl")
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
download.file(fileUrl,dest="./data/country.csv",method="curl")

#load data
gdp<-read.csv("./data/gdp.csv",skip=4,nrows=190,stringsAsFactors=FALSE)
#converts to numeric the X.4 (gdp) Value as  it cames formatted with comas
gdp=mutate(gdp,gdp_num=as.numeric((gsub(",","",X.4))))
country<-read.csv("./data/country.csv",stringsAsFactors=FALSE)
mergeData=merge(country,gdp,by.x="CountryCode",by.y="X",all=TRUE)

#Sort by gdp_num to get desired position
sortData=arrange(mergeData,(gdp_num))
#Show 13th row
sortData[13,c("CountryCode","Long.Name")]

#show number of unmatched rows;extract this number from total number of rows  in sortData := 189
#Compared via unique expression  in matching columns and result set SSD code is not present for match



## Q4
library('plyr')
ddply(sortData,.(Income.Group),summarize,mean=mean(X.1,na.rm=T))
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
sortData$RankGroups=cut(sortData$X.1,breaks=quantile(sortData$X.1,na.rm=T,probs=seq(0,1,.2))

##Table Income.Group vs RankGroups
table(sortData$Income.Group,sortData$RankGroups)
#                       (1,38.8] (38.8,76.6] (76.6,114] (114,152] (152,190]
#                              0           0          0         0         0
#  High income: nonOECD        4           5          8         4         2
#  High income: OECD          17          10          1         1         0
#  Low income                  0           1          9        16        11
#  Lower middle income         5          13         12         8        16
#  Upper middle income        11           9          8         8         9

