corr <- function(directory, threshold = 0) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'threshold' is a numeric vector of length 1 indicating the
        ## number of completely observed observations (on all
        ## variables) required to compute the correlation between
        ## nitrate and sulfate; the default is 0

        ## Return a numeric vector of correlations

fpath=directory
 
ldata=list.files(fpath) ## Lista todos los archivos de la ruta

cumple=0                ## Conteo de monitores que cumple criterio
lodata=length(ldata)    ## numero de archivos a leer
cr=c()

  for (i in 1:lodata) {   ## para todo el vector solicitado
    ndata=paste0(fpath,"/",ldata[i])
    df1<-read.csv(ndata)
    sel<-complete.cases(df1) #Obtiene sólo los casos completos sin NAs
    df1<-df1[sel,]           #Copia sólo los casos completos
    nobs=nrow(df1)           #Obtiene  el conteo de casos para un ID
    if (nobs<=threshold)     #Si no es mayor al limite regrea al for
        next 
    else { 
       cumple<-cumple+1         #contador de cumplimientos para armar vector
       cr[cumple]= cor(df1$sulfate,df1$nitrate)
    }
   } ##End For i
  # if (length(cr))
  #   round(cr,5)
  # else
     cr    
} ##END

