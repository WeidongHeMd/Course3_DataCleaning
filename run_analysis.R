# The script performs the analysis in the following major steps:
#
# Step 0: obtain the raw data from the data source
# Step 1: merge the training and test data sets 
# Step 2: Extracts only the measurements on the mean and 
#         standard deviation for each measurement.
# Step 3: creates a second, independent tidy data set with the average 
#         of each variable for each activity and each subject.
# 
#------------------
#
## Step 0 obtain the raw data
#
if(!dir.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/rawData.zip", method = "curl")
unzip("./data/rawData.zip",extdir="./data/")
#
## Step 1 Merge the training and test data sets
#
# to converted the numeric label to activity names
n <- length(dataCombinedLabel)
for(i in seq(n)){
    if(dataCombinedLabel[i]=="1"){
        dataCombinedLabel[i] <-"Walking"
    }else if(dataCombinedLabel[i]=="2"){
        dataCombinedLabel[i] <- "WALKING_UPSTAIRS"
    }else if(dataCombinedLabel[i]=="3"){
        dataCombinedLabel[i] <- "WALKING_DOWNSTAIRS"
    }else if(dataCombinedLabel[i]=="4"){
        dataCombinedLabel[i] <-"SITTING"
    }else if(dataCombinedLabel[i]=="5"){
        dataCombinedLabel[i]<-"STANDING"
    }else{
        dataCombinedLabel[i]<-"LAYING"
    }
}

# from X_test.txt, read in the test data set using read.fwf
widths <-c(16)*561
testData <- read.fwf("./data/X_test.txt", widths = widths, sep="")
dim(testData)

# from X_train.txt, read in the training data set using read.fwf
trainData <- read.fwf("./data/X_train.txt", widths = widths, sep="")
dim(trainData)

# merge the training and test datasets 
dataCombined <- rbind(testData,trainData)

# read the varialbe names of the test data from 'features.txt'; 
# use them for the names of the combined data set
varNames <- readLines("./data/features.txt")
names(dataCombined) <- varNames

#
# Step 2: create a sparate data set only containing the means and 
#         standard deviations of the measurements
# 
library(dplyr)
varSelected <- grep(".mean.|.std.", names(dataCombined), value = TRUE)
dataCombinedSelected <- select(dataCombined, varSelected)

# from "y_test.txt" read the labels for test and training data sets 
# and change the numeric labels to character ones
labelsTest <- readLines("./data/y_test.txt")
length(labelsTest)
labelsTrain <-readLines("./data/y_train.txt")
length(labelsTrain)
# merge the data lables of the two data sets
dataCombinedLabel <- c(labelsTest, labelsTrain)

# read and merge the subjects from "subject_test.txt" and "subject_train.txt"
subjectTest <- readLines("./data/subject_test.txt")
length(subjectTest)
subjectTrain <-readLines("./data/subject_train.txt")
length(subjectTrain)
# merge the data lables
dataCombinedSubject <- c(subjectTest, subjectTrain)

# Add Subject and Activity labels to the first two columns as factors to the new data set
dataCombinedSelected <- cbind(Subject=factor(dataCombinedSubject), 
                              Activity=factor(dataCombinedLabel), 
                              dataCombinedSelected)
#
## Step 3 creates a second, independent tidy data set with the average of 
#         each variable for each activity and each subject from 
#         the data set created in Step 2 above.
groups <- group_by(dataCombinedSelected, Subject, Activity)
varnames <- names(dataCombinedSelected)
n <- length(varnames)
averages <- as.data.frame(summarize(groups, mean(dataCombinedSelected[,3])))
for(i in seq(4,n)){
    temp <- summarize(groups, mean(dataCombinedSelected[,i]))
    averages <- cbind(averages, as.data.frame(temp)[,3])
}
names(averages) <- varnames
write.csv(averages, "averages.csv")
