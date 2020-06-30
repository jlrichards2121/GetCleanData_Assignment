---
title: "README"
author: "Luke"
date: "6/29/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Code and data transformation:

This analysis uses the dplyr library. 

Step 1: Download the data set

```{r eval=FALSE}
filename <- "zip_data.zip"

if(!file.exists(filename)){
        download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile=filename,method="curl")
}

if(!file.exists("UCI HAR Dataset")){
        unzip(filename)
}
```

Step 2: Read in the data, and rename the features to make the variable names practice descriptive labels. 

```{r eval=FALSE}
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
}
```

Step 3: Merge the data with row bind and column bind functions to create one massive data set.

```{r eval=FALSE}
## PART 1: Merge data sets
merged_test <- cbind(test_code,test_subj,test_dat)
merged_train <- cbind(train_code,train_subj,train_dat)
merged_dat <- rbind(merged_test,merged_train)
```

Step 4: Extract the data that contains the word "mean" or "std" in the title of the variable name

```{r eval=FALSE}
## PART 2: Extracts measurements on mean and standard deviation for each msrmnt
extracted_mean_std <- merged_dat[grep("mean|std",colnames(merged_dat)),]
```

Step 5: Create a tidy data set that provides a mean of all the variables for each subject and each activity. This uses the dplyr function to perform the action of pulling all variables, grouping them and ordering by subject first, then the code (or activity), and then using the summarise_all function to apply the function "mean" to all variables. This outputs a convenient 180x563 table.

```{r eval=FALSE}
## PART 5: Create Tidy Dataset with average of variables for activities and subj
tidy_dat <- merged_dat %>% group_by(subject,code) %>% summarise_all(mean)
write.table(tidy_dat, file = "tidy_data.txt")
```