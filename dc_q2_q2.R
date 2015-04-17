library("sqldf")
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
download.file(fileUrl,dest="./data/acs.csv",method="curl")
acs<-read.csv("./data/acs.csv")
sqldf("select pwgtp1 from acs where AGEP < 50")

