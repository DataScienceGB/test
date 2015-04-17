library("data.table")
##fileUrl<-"http://www.cpc.ncep.noaa.gov/data/indices/wksst8110.for"
fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
download.file(fileUrl,dest="./data/num.txt",method="curl")
tab<-read.fwf("./data/num.txt",skip=4, widths=c(10,5,4,4,5,4,4,5,4,4,5,4,4))
sum(tab$V6)

