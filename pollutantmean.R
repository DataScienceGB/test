pollutantmean <- function (directory, pollutant,id=1:332) {
        ## 'directory' is a character vector of length 1 indicating
        ## the location of the CSV files

        ## 'pollutant' is a character vector of length 1 indicating
        ## the name of the pollutant for which we will calculate the
        ## mean; either "sulfate" or "nitrate".

        ## 'id' is an integer vector indicating the monitor ID numbers
        ## to be used

        ## Return the mean of the pollutant across all monitors list
        ## in the 'id' vector (ignoring NA values)

        ## Recibe los argumentos como los pide el ejercicio
        ## y los renombra a los usados durante la programacion
fpath=directory
element=pollutant
lodata=id
 
ldata=list.files(fpath) ## Lista todos los archivos de la ruta
flag=1                  ## permite crear un DF vacio y luego concatenar
  for (i in lodata) {   ## para todo el vector solicitado
    ndata=paste0(fpath,"/",ldata[i])
    df1<-read.csv(ndata)
    if (flag==1) {
        dft=df1
        flag=0
    } 
    else {
        dft<-rbind(dft,df1)
    }
  }
  round(mean(dft[,element],na.rm=TRUE),3)  ## obtiene la media de la columna indicada
} ##END
