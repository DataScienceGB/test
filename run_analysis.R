run_analysis<-function () {
#load libraries needed
library(data.table)

#Read test data
data_test<-read.table("./data/Dataset/test/X_test.txt")
label_test<-read.table("./data/Dataset/test/y_test.txt")
subject_test<-read.table("./data/Dataset/test/subject_test.txt")

#Read train data
data_train<-read.table("./data/Dataset/train/X_train.txt")
label_train<-read.table("./data/Dataset/train/y_train.txt")
subject_train<-read.table("./data/Dataset/train/subject_train.txt")

#Requirement 1: Merge data sets to create 1 data set
data_mix<-rbind(data_train,data_test)
label_mix<-rbind(label_train,label_test)
subject_mix<-rbind(subject_train,subject_test)
## End Requirement 1


#Requirement 3: Use Descriptive Names: Assign column names to datasets 

nset<-read.table("./data/Dataset/features.txt")
colnames(data_mix)<-nset[,2]

## End requirement3

#Requirement 2: Extracts only the measurements on the mean and standard deviation for each measurement.
## uses grep function to selects columns having mean and std
sel=grep('mean|std',colnames(data_mix))
data_mix<-data_mix[,c(sel)]

#Requirement 4: Uses descriptive activity names to name the activities in the data set

nlabel<-read.table("./data/Dataset/activity_labels.txt",colClasses=c("integer","character"))

#var nlabel, has the mapping between numbers and activity labels
#  column V2 holds the names and V1 holds the numbers
##Loops for each kind of label (ii <-nlabel$V2 and sets the label on it
ii <-1
while (ii<=length(nlabel$V2)) {
   label_mix$activity_name[label_mix$V1==ii] <- nlabel$V2[nlabel$V1== ii]
   ii<-ii+1
}
colnames(subject_mix)<-c("SUBJECT")
##Attach subject and activity labels to data set
data_mix<-cbind(subject_mix["SUBJECT"],label_mix["activity_name"],data_mix)

## End Requirement 4

##Requierement 5
##From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

## split data in groups by activity_name and subject
## then use lapply to execute mean in each group
## columns 1 and 2 in data_mix are activity_name and subject, so are excluded from the mean
## write.table() using row.name=FALSE

out=sapply(split(data_mix[,3,563],list(data_mix$activity_name,data_mix$SUBJECT)),mean)
write.table(file="./data/req5.txt",out,row.name=FALSE)

}




