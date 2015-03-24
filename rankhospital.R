rankhospital <- function(state, outcome, num = "best") {
## Read outcome data
## Check that state and outcome are valid
## Return hospital name in that state with the given rank
## 30-day death rate
## If an invalid state value function should throw  message “invalid state”. 
## If an invalid outcome value is passed throw message “invalid outcome”. 

## Variables to use:
##  [2] "Hospital.Name" 
##  [11] "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
##  [17] "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
##  [23] "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia" 


##Read data
df <- read.csv("outcome-of-care-measures.csv", colClasses = "character")

## Check valid state
if (!sum(df$State==state))  
    stop("invalid state")

## Check valid outcome
if (!validate_outcome(outcome))
     stop("invalid outcome")

## Check valid num
 if (num != "worst" && num!="best" && is.character(num))
     stop("invalid rank")

## Check valid  num count
## retunrs NA in case num is lager than hospitals count in a state
if (num != "worst" && num!="best" && !is.character(num))
if (sum(df$State==state)<num)  
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
      out=nth_hospital(df,state,outcome_measure["ha"],num)
   if (outcome=="heart failure")
      out=nth_hospital(df,state,outcome_measure["hf"],num)
   if (outcome=="pneumonia")
      out=nth_hospital(df,state,outcome_measure["pn"],num)
   out

}

nth_hospital<-function(df,state,measure,num) {
## recieves dataframe, state to check,
##          the column number( measure) to work with
##          position to return (num)
## returns hospital name (variable 2) having the nth measure value
  
   ## Selects only selected state information
   sel<-df$State==state
   ## gets min value for a selected measure in a particular state, eliminates NA
   if (num=="best") 
       nth_val<-min(as.numeric(df[[measure]][sel]),na.rm=TRUE)
   else if (num=="worst")
           nth_val<-max(as.numeric(df[[measure]][sel]),na.rm=TRUE)
   else  if (num>=0) 
               ##nth_val<-nth(as.numeric(df[[measure]][sel]),num)
             return(nth(df[sel,],measure,num))


   ## Selects only hospitals having the nth value in the measure
   sel2<-as.numeric(df[[measure]])==nth_val

   ## Joins both conditions
   sel3<-sel&sel2
   ## find outs and returns hospital name for particulare measure value
   return(min(as.character(df$Hospital.Name[sel3]),na.rm=TRUE))
           
}

nth <-function(df,measure,num) {
## sort state data dataframe using the indicated measure
##  returns the nposition hospital
   df<-df[ order(as.numeric(df[[measure]]), df["Hospital.Name"]),]
   return(df$Hospital.Name[num])

}



validate_outcome<-function(outcome) {
## takes an outcome name and compare it to the valid list
## if exists then returns 1 otherwise returns 0

valid_outcome<-c("heart attack","heart failure","pneumonia")

sum(outcome==valid_outcome)

}
