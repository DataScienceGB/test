fileUrl<-"https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
download.file(fileUrl,dest="./data/survey.csv",method="curl")
survey<-read.csv("./data/survey.csv")

#Apply strsplit() to split all the names of the DF on the characters "wgtp" what is the
#value of the 123 element of th resulting list
#Answer "" "15"
strsplit(colnames(survey),"wgtp",fixed=T)


