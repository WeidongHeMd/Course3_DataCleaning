# run_analysis.R
# 
# The script cleans the data set by the following steps:
# 
# 1. Merging the training and the test sets to create one data set
# 2. Selecting only the measurements for the mean and standard deviation variables
# 3. Labeling the activities in the data set with descriptive names
# 4. Renaming the variables of the data set with appropriate and descriptive names
# 5. From the data set in step 4, creating a second, independent tidy data set with the average of each variable 
#    for each activity and each subject.
# 
# Here are the data for this project:
# "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
# 
# The data set from above url first was downloaded, and unzipped. A folder named "UCI HAR Dataset" was saved
# in the working directory. The folder contains the following used in the anlysos:
#
# - 'features.txt': List of all features.
# - 'activity_labels.txt': Links the class labels with their activity name.
# training data set
# - 'train/X_train.txt': Training set.
# - 'train/y_train.txt': Training labels.
# - 'train/subject_train.txt': Each row identifies the subject performed the activity 
# test data set
# - 'test/X_test.txt': Test set.
# - 'test/y_test.txt': Test labels.
# - 'test/subject_test.txt'

# Output: 
# the script will generate a tidy data set, which is saved as a text file: "mean_tidydata.txt". 
# The data set contains the average of each varaible for each activity and each subject

# set working directory
setwd("~/Documents/datascience/jhu/unit3/unit3_prog_assignment")

# loading the data for activity lables and feature names
activity <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                       col.names = c("Id", "Label"))
feature <- read.table("./UCI HAR Dataset/features.txt", 
                       col.names = c('Id', 'Feature'))

# generate the test data set with subject and activity columns added
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                           col.names = 'Subject')
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                            col.names = 'Activity')
data_test <- read.table("./UCI HAR Dataset/test/x_test.txt", 
                        col.names = feature$Feature)
# test data set
test <- cbind(subject_test, activity_test, data_test)

# generate the training data set with subject and activity columns added
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",
                            col.names = 'Subject')
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                             col.names = 'Activity')
data_train <- read.table("./UCI HAR Dataset/train/x_train.txt",
                         col.names = feature$Feature)
# training data set
train <- cbind(subject_train, activity_train, data_train)

# 1. Merging the two data set
merged <- rbind(test, train)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

library(dplyr)
merged <- tbl_df(merged)
tidydata <- select(merged, Subject, Activity, contains("mean"), contains("std"))

# 3. Uses descriptive activity names to name the activities in the data set
tidydata$Activity <- factor(tidydata$Activity, 
                                 levels = activity$Id,
                                 labels = activity$Label)

# 4. Appropriately labels the data set with descriptive variable names.
vars <- names(tidydata)
vars <- gsub("\\.+", "", vars)  # omit the "." or "..."
vars <- gsub("^t", "Time", vars) 
vars <- gsub("^f", "Frequency", vars)
vars <- gsub("^anglet", "AngleTime", vars)
vars <- gsub("^angle", "Angle", vars)
vars <- gsub("gravity", "Gravity", vars)
vars <- gsub("mean", "Mean", vars)
vars <- gsub("std", "Std", vars)

# relabel the variables of the dataset
names(tidydata) <- vars

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable 
#    for each activity and each subject.

mean_tidydata <- tidydata %>%
    group_by(Activity, Subject) %>%
    summarise_all(list(mean))

# save the result to file 
write.table(mean_tidydata,"mean_tidydata.txt", row.names = FALSE, quote = FALSE)

