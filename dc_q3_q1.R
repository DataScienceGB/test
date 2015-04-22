fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,dest="./data/survey.csv",method="curl")
survey<-read.csv("./data/survey.csv")

#create Logical vector of households > than 10 acres and more than 10,000 sales
agricultureLogical=(survey$ACR==3 & survey$AGS==6)
#use wich(agricultureLogical) to show first three values
head (which(agricultureLogical))

