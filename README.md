The script - run_analysis.R - was developed and run with the following platform and software:

- MacBook computer running MacOS 15.1
- RStudio 1.2.5019
- R version 3.6.1

To run the script, the first step is to download the data set zip file from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

and unzip the file to the directory where the script resides. A folder named "UCI HAR Dataset" will result and contain the following files:

- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.

training data set:

- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'train/subject_train.txt': Each row identifies the subject performed the activity 

test data set
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'test/subject_test.txt'

When run, the script will read in data from these files as input to create a tidy data set. The script will perform the following steps to process the data it reads in from these files:

1. Merging the training and the test sets to create one data set
2. Selecting only the measurements for the mean and standard deviation variables
3. Labeling the activities in the data set with descriptive names
4. Renaming the variables of the data set with appropriate and descriptive names
5. From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.

The result of running the script is a tidy data set, which will be saved as a text file - "mean_tidydata.txt" in the working directory. (please see the CodeBook for detail)
