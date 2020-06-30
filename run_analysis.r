## Class 3 Asignment: Run Analysis
# Analysis to download, load into memory, merge, and clean a data set


#Download data and unzip
library(dplyr)

filename <- "zip_data.zip"

if(!file.exists(filename)){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=filename,method="curl")
}

if(!file.exists("UCI HAR Dataset")){
        unzip(filename)
}

# # load data
# if(length(grep("UCI HAR Dataset",getwd()))==0){
#         setwd("./UCI HAR Dataset")
# }

# General Names/Lables
features <- read.table("./UCI HAR Dataset/features.txt")
features$V2 <- tolower(features$V2)
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

## PART 3 and 4

# Cleanup feature names
features$V2 <- gsub("^t", "time",features$V2)
features$V2 <- gsub("acc", "accelerometer",features$V2)
features$V2 <- gsub("gyro", "gyroscope",features$V2)
features$V2 <- gsub("mag", "magnitude",features$V2)
features$V2 <- gsub("^f", "frequency",features$V2)
features$V2 <- gsub("-|,|\\()","",features$V2)

# Test data
test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt",col.names="subject")
test_dat <- read.table("./UCI HAR Dataset/test/X_test.txt",col.names = features$V2)
test_code <- read.table("./UCI HAR Dataset/test/y_test.txt",col.names="code")

# Train data
train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
train_dat <- read.table("./UCI HAR Dataset/train/X_train.txt",col.names = features$V2)
train_code <- read.table("./UCI HAR Dataset/train/y_train.txt",col.names = "code")

## PART 1: Merge data sets
merged_test <- cbind(test_code,test_subj,test_dat)
merged_train <- cbind(train_code,train_subj,train_dat)
merged_dat <- rbind(merged_test,merged_train)

## PART 2: Extracts measurements on mean and standard deviation for each msrmnt
extracted_mean_std <- merged_dat[grep("mean|std",colnames(merged_dat)),]

## PART 5: Create Tidy Dataset with average of variables for activities and subj
tidy_dat <- merged_dat %>% group_by(subject,code) %>% summarise_all(mean)
write.table(tidy_dat, file = "tidy_data.txt")
