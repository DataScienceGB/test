library('jpeg')
url='https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg'
download.file(url,dest="./data/jeff.jpg",method="curl")
jeff<-readJPEG("./data/jeff.jpg",native=TRUE)
quantile(jeff,c(.30,.80))
##Fedora R produces the 638 difference in the 30th quantile Fedora answer=-15258512
## book answer -15259150 (book answer -638=fedora answer)

