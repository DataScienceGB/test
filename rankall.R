rankall <- function(outcome, num = "best") {
## Read outcome data from csv
## Check that state and outcome are valid
## For each state, find the hospital of the given rank
## Return a data frame with the hospital names and the
## (abbreviated) state name

## If an invalid state value function should throw  message “invalid state”. 
## If an invalid outcome value is passed throw message “invalid outcome”. 

## Variables to use:
##  [2] "Hospital.Name" 
##  [11] "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
##  [17] "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
##  [23] "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia" 


##Read data
df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

## Check valid outcome
if (!validate_outcome(outcome))
     stop("invalid outcome")

## Check valid num
 if (num != "worst" && num!="best" && is.character(num))
     stop("invalid rank")

## Check valid  num count
## returns NA in case num is lager than hospitals count in a state
if (num != "worst" && num!="best")
  if (!is.numeric(num))
    return(NA)

## Select nth hospital
## Call best hostpital using the apropiate column number)
   outcome_name<-c("ha","hf","pn")
   #outcome_measure<-c(11,17,23)
   outcome_measure<-c(
        "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
        "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
        "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
   names(outcome_measure)<-outcome_name

   if (outcome=="heart attack")
      out=nth_hospitals(df,outcome_measure["ha"],num)
   if (outcome=="heart failure")
      out=nth_hospitals(df,outcome_measure["hf"],num)
   if (outcome=="pneumonia")
      out=nth_hospitals(df,outcome_measure["pn"],num)
   out

}

nth_hospitals<-function(df,measure,num) {
## recieves dataframe, 
##          the column number( measure) to work with
##          position to return (num)
## returns hospital name (variable 2) having the nth measure value
##         and state abbreviation
  
   ## Selects only selected state information
   ##sel<-df$State==state
   ## gets min value for a selected measure in a particular state, eliminates NA
   ##if (num=="best") 
   ##    nth_val<-min(as.numeric(df[[measure]][sel]),na.rm=TRUE)
   ##else if (num=="worst")
   ##        nth_val<-max(as.numeric(df[[measure]][sel]),na.rm=TRUE)
   ##else  if (num>=0) 

   ##Selects only the state,hospital name and the measure columns
   df<-df[,c("State","Hospital.Name",measure)]

   ## adds a column to set up the hospital position
   df$pos=0

   ## dicards NA values
   sel=!is.na(as.numeric(df[[measure]]))
   df<-df[sel,]
   ##Sorts based state, measure and hospital name
   df<-df[ order(df["State"],as.numeric(df[[measure]]), df["Hospital.Name"]),]
   
   ## ranks using State and measure
   lst<-tapply(as.numeric(df[[measure]]),df$State,function (x) rank(x,ties.method="first"))

   ##converts list to vector and Copy calculated Rank to DF$pos
   ##df$pos=data.frame(matrix(unlist(lst),nrow=nrow(df),byrow=T),stringsAsFactors=FALSE)
   df$pos=as.vector(matrix(unlist(lst),nrow=nrow(df),byrow=T))

  ## Gets the max value for each state to handle worst case scenarios
  lst2<-tapply(as.numeric(df$pos),df$State,function (x) max(x) )
  df$Max<-lst2[df[,"State"]]

  if (num=="best")
      num<-1

  if (num=="worst")
     ## If worst case, then set pos to Max to retreive worst
     sel2<-df$pos==df$Max
  else {
     #if ( num > df$Max )
     #   df$Hospital.Name
     ##Selects the position of each state
     sel2<-df$pos==num 
  }

  ##if (sum(df$State==state)<num)  

  #Copy Selected rows to df
  df<-df[sel2,c("Hospital.Name","State")]

  return(df)
           
}

nth <-function(df,num) {
## sort state data dataframe using the indicated measure
##  returns the nposition hospital for every state

   #df<-df[ order(as.numeric(df[[measure]]), df["Hospital.Name"]),]

   return(df)

}



validate_outcome<-function(outcome) {
## takes an outcome name and compare it to the valid list
## if exists then returns 1 otherwise returns 0

valid_outcome<-c("heart attack","heart failure","pneumonia")

sum(outcome==valid_outcome)

}
