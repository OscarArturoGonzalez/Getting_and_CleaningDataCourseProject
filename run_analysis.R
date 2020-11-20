# Project

## Files are in the folderUCI HAR Dataset. Then we get the list of the files.

path_rf <- file.path("." , "UCI HAR Dataset") 
files <-list.files(path_rf, recursive=TRUE)
files

## Read data from the files into the variables. We read the activity files

dataActivityTest  <- read.table(file.path(path_rf, "test" , "y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path(path_rf, "train", "y_train.txt"),header = FALSE)

## Read the subject files

dataSubjectTrain <- read.table(file.path(path_rf, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest  <- read.table(file.path(path_rf, "test" , "subject_test.txt"),header = FALSE)

## Read features file

dataFeaturesTest  <- read.table(file.path(path_rf, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path(path_rf, "train", "X_train.txt"),header = FALSE)

## Look at the properties of the variables

str(dataActivityTest)
str(dataActivityTrain)
str(dataSubjectTrain)
str(dataSubjectTest)
str(dataFeaturesTest)
str(dataFeaturesTrain)

## Merge the sets to create one data set (training and test)

## Concatenate the data tables by rows

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

## Set names to variables

names(dataSubject)<-c("SUBJECT")
names(dataActivity)<- c("ACTIVITY")
dataFeaturesNames <- read.table(file.path(path_rf, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

## Merge columns to get the data frame for all data

dataMerge <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataMerge)

## Extract the measurements (mean and standard deviation only by row)

## Subset the name of features by measurements on the mean and standard deviation

subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

## Subset the data frame Data by the names of features

selectedNames<-c(as.character(subdataFeaturesNames), "SUBJECT", "ACTIVITY" )
Data<-subset(Data,select=selectedNames)

## Check the result

str(Data)

## Descriptive activity names to name the activities in the data set

## Read descriptive activities from “activity_labels.txt”

activityLabels <- read.table(file.path(path_rf, "activity_labels.txt"),header = FALSE)

## Factorize variable activity in the data frame Data using the names of descriptive activity
Data$activity<-factor(Data$activity,labels=activityLabels[,2])

## Check result

head(Data$activity,30)

## Label the data set with descriptive variable names using descriptive names. 

names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Check results

names(Data)

## Create independent tidy data set 
## Tidy data set will be created with the average of 
## each variable for each activity and each subject based on the data set above.

library(plyr);
Data2<-aggregate(. ~subject + activity, Data, mean)
Data2<-Data2[order(Data2$subject,Data2$activity),]
write.table(Data2, file = "tidydata.txt",row.name=FALSE)

## Create README.md
library(knitr)
#knit2html("codeBook.Rmd")
#knit2html("run_analysis.R", output ="codeBook.Rmd")
knit("run_analysis.R", output = "README.md")

sink('codeBook.md')
names(Data)
sink()
