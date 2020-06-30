---
title: "Code Book"
author: "Luke"
date: "6/29/2020"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```
## Code Book for Wearable computing

# General
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals taccelerometerXYZ and tgyroscopeXYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyaccelerometerXYZ and tGravityaccelerometerXYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyaccelerometerJerkXYZ and tBodygyroscopeJerkXYZ). Also the magnitude of these threedimensional signals were calculated using the Euclidean norm (timeBodyaccelerometermagnitude, timeGravitimeyaccelerometermagnitude, timeBodyaccelerometerJerkmagnitude, timeBodygyroscopemagnitude, timeBodygyroscopeJerkmagnitude). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing frequencyBodyaccelerometerXYZ, frequencyBodyaccelerometerJerkXYZ, frequencyBodygyroscopeXYZ, frequencyBodyaccelerometerJerkmagnitude, frequencyBodygyroscopemagnitude, frequencyBodygyroscopeJerkmagnitude.

These signals were used to estimate variables of the feature vector for each pattern:  
'XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

timeBodyaccelerometerXYZ
timeGravityaccelerometerXYZ
timeBodyaccelerometerJerkXYZ
timeBodygyroscopeXYZ
timeBodygyroscopeJerkXYZ
timeBodyaccelerometermagnitude
timeGravityaccelerometermagnitude
timeBodyaccelerometerJerkmagnitude
timeBodygyroscopemagnitude
timeBodygyroscopeJerkmagnitude
frequencyBodyaccelerometerXYZ
frequencyBodyaccelerometerJerkXYZ
frequencyBodygyroscopeXYZ
frequencyBodyaccelerometermagnitude
frequencyBodyaccelerometerJerkmagnitude
frequencyBodygyroscopemagnitude
frequencyBodygyroscopeJerkmagnitude

The set of variables that were estimated from these signals are: 

mean: Mean value
std: Standard deviation
mad: Median absolute deviation 
max: Largest value in array
min: Smallest value in array
sma: Signal magnitude area
energy: Energy measure. Sum of the squares divided by the number of values. 
iqr: Interquartile range 
entropy: Signal entropy
arCoeff: Autorregresion coefficients with Burg order equal to 4
correlation: correlation coefficient between two signals
maxInds: index of the frequency component with largest magnitude
meanFreq: Weighted average of the frequency components to obtain a mean frequency
skewness: skewness of the frequency domain signal 
kurtosis: kurtosis of the frequency domain signal 
bandsEnergy: Energy of a frequency interval within the 64 bins of the FFT of each window.
angle: Angle between to vectors.

Additional vectors obtained by averaging the signals in a signal window sample. These are used on the angle variable:

gravityMean
timeBodyaccelerometerMean
timeBodyaccelerometerJerkMean
timeBodygyroscopeMean
timeBodygyroscopeJerkMean

# 'Code' Variable
The 'code' variable corresponds to the following activities:

1 WALKING
2 WALKING_UPSTAIRS
3 WALKING_DOWNSTAIRS
4 SITTING
5 STANDING
6 LAYING


# Tidy data set
This dataset was created for the Johns Hopkins Getting and Cleaning Data assignment. 

It uses the run_analysis.R function to create a tidy data set, which takes all of the data available in the UCI HAR Dataset and calculates a mean for all of the variables across the subject and activities (code).

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

# License and fair use
This section is copy-pasted from the original dataset README to comply with dataset use requirements

License:
Use of this dataset in publications must be acknowledged by referencing the following publication [1] 

[1] Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012

This dataset is distributed AS-IS and no responsibility implied or explicit can be addressed to the authors or their institutions for its use or misuse. Any commercial use is prohibited.

Jorge L. Reyes-Ortiz, Alessandro Ghio, Luca Oneto, Davide Anguita. November 2012.
