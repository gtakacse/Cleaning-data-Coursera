'''
The following script creates a tidy dataset from the Smartphone dataset that
later can be used for analysis.
In the final dataset, only the columns with mean and standard deviation measures 
are included, and the test and the train datasets are merged. The final output is
saved as a test file.
Datasets are downloaded from: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
The original dataset can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
'''

#Read in the test dataset
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt")

#Read in the list of column headers from features.txt
features <- read.table("./UCI HAR Dataset/features.txt")
headers <- as.character(features[,2])
#Associate the headers with the test_data table
names(test_data) <- headers

#Get the subject IDs for the test dataset
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
#Give sensible names to the column headers
names(subject_test) <- "subject"

#Create a list of the column names referring to mean and standard deviation measures
selected_index <- sort(c(grep("std", headers), grep("mean", headers))) 

#Extract only the mean and the std measures from the test data frame
subset_test <- test_data[,selected_index]

#Read in activity labels and bind the data to the test dataset
test_label <- read.table("./UCI HAR Dataset/test/y_test.txt")
#Assciate the activity types with the numbers
act_lab <- read.table("./UCI HAR Dataset/activity_labels.txt")
act_lab <- as.character(act_lab$V2)
test_label$V1 <- factor(test_label[,1], levels = c(1:6), labels=act_lab)
names(test_label) <- "activity"
#Bind to the dataset
subset_test <- cbind(test_label,subset_test)
#Associate the subject IDs with rows of excerpt of the test data frame
subset_test <- cbind(subject_test, subset_test)

#The train dataset
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt")
#Updating header names for the train dataset
names(train_data) <- headers
#Extract only the mean and the std measures from the train data frame
subset_train <- train_data[,selected_index]

#Read in the activity types and the associate them with the appropriate labels
train_label <- read.table("./UCI HAR Dataset/train/y_train.txt")
#Assciate the activity types with the numbers
train_label$V1 <- factor(train_label[,1], levels = c(1:6), labels=act_lab)
names(train_label) <- "activity"
#Bind to the data set
subset_train <- cbind(train_label,subset_train)

#Get the subject IDs for the train dataset
subject_train <-read.table("./UCI HAR Dataset/train/subject_train.txt")
#Give sensible names to the subject column
names(subject_train) <- "subject"
#Add a subject column to the train subset of the data frame
subset_train <- cbind(subject_train,subset_train)

#Merges the training and the test sets to create one dataset.
merged_data <- merge(subset_train, subset_test, all=T)

#Save the output as a text file
write.table(merged_data, "./UCI HAR Dataset/tidy_dataset.txt",  row.name=FALSE)
