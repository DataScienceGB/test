complete <- function(directory, id = 1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used
        
        ## Return a data frame of the form:
        ## id nobs
        ## 1  117
        ## 2  1041
        ## ...
        ## where 'id' is the monitor ID number and 'nobs' is the
        ## number of complete cases

fpath=directory
lodata=id
 
ldata=list.files(fpath) ## Lista todos los archivos de la ruta
flag=1                  ## permite crear un DF vacio y luego concatenar
  for (i in lodata) {   ## para todo el vector solicitado
    ndata=paste0(fpath,"/",ldata[i])
    df1<-read.csv(ndata)
    sel<-complete.cases(df1) #Obtiene sólo los casos completos sin NAs
    df1<-df1[sel,]           #Copia sólo lso casos completos
    nobs=nrow(df1)            #Obtiene  el conteo de casos para un ID
    id=i                      #Copia para usar el nombre ID en el DF
    df1<-data.frame(id,nobs)   #Crea un DF con ID y Conteo
    if (flag==1) {
        dft= data.frame(id,nobs)
        flag=0
    } 
    else {
        dft<-rbind(dft,df1)
    }
  }
  dft                 ##regresa el DF resultante
} ##END
