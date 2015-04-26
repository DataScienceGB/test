#Using amazon to download stockprice and get times data sampled
#how many values were collected in 2012
#how many were collected in Mondays in 2012

library(quantmmd)
amzn=getSymbols("AMZN",auto.assign=FALSE)
sampleTimes=index(amzn)

#On 2012
table(format(sampleTimes,"%Y")=="2012")

#FALSE  TRUE 
# 1842   250

#On Mondays 2012
table(format(sampleTimes,"%a %Y")=="lun 2012")
#FALSE  TRUE 
# 2045    47 

