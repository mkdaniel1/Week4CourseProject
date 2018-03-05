library(tidyr)
library(data.table)

## Download course files
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir.create("GettingandCleaningData")
coursemat <- file.path(getwd(),"GettingandCleaningData/coursemat.zip")
download.file(url,coursemat)

## Unzip course files
setwd(file.path(getwd(),"GettingandCleaningData"))
unzip("coursemat.zip")

# Load raw txt files
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")

## Load mean and standard deviation
meananddev <- grep(".*mean.*|.*std.*", features[,2])
meananddev_names <- features[meananddev,2]

## Clean up column names
meananddev_names = as.character(gsub('-mean', 'Mean', meananddev_names))
meananddev_names = as.character(gsub('-std', 'Std', meananddev_names))
meananddev_names <- as.character(gsub('[-()]', '', meananddev_names))

## Load train dataset
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")[meananddev]
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, y_train, X_train)

## Load test dataset
X_test <- read.table("UCI HAR Dataset/test/X_test.txt")[meananddev]
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, y_test, X_test)

## merge data tables and label
DataSet <- rbind(train, test)
colnames(DataSet) <- c("Subject", "Activity", meananddev_names)

## turn column data into factors for Activities and Subjects
DataSet$Activity <- factor(DataSet$Activity, levels = activity_labels[,1], labels = activity_labels[,2])
DataSet$Subject <- as.factor(DataSet$Subject)

## Create final clean data table
DataSetGather <- gather(DataSet, variable, value, -Subject, -Activity)
DataSetMean <- dcast(DataSetGather, Subject + Activity ~ variable, mean)

## Ouput .txt file
setwd("..")
write.table(DataSetMean, "tidy.txt", row.names = FALSE, quote = FALSE)




