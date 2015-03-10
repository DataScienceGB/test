f<-function() {
fpath="./specdata/"
ldata=list.files(fpath)
lodata=1:2
element="sulfate"
flag=1
  for (i in lodata) {
    ndata=paste0(fpath,ldata[i])
    print(i)
    df1<-read.csv(ndata)
    print(nrow(df1))
    if (flag==1) {
        dft=df1
    } 
    else {
        flag=0
        dft<-rbind(dft,df1)
    }
  }
  nrow(dft)
  mean(dft[,element],na.rm=TRUE)
}
