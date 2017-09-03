Getting and Cleaning Data Course Assignment

Instructions:
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names.
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Description of the DATA:
The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
======================================

- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

The dataset includes the following files:
=========================================

- 'README.txt'

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

The following files are available for the train and test data. Their descriptions are equivalent. 

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train.txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 

- 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the total acceleration. 

- 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window sample. The units are radians/second. 




In this project, you find:

run_analysis.R: the R-code run on the data set

TidyDFile.txt: the clean data extracted from the original data using run_analysis.R

CodeBook.md : the CodeBook 

README.md : the analysis of the code in run_analysis.R



run_analysis.R:
Assumed that data file was downloaded and extracted in the R current working directory

Load required packages

library(dplyr)

library(data.table)

library(tidyr)

Files in folder that will be used are:
test/subject_test.txt
train/subject_train.txt
test/X_test.txt
train/X_train.txt
test/y_test.txt
train/y_train.txt
features.txt - Names of column variables in the dataTable

activity_labels.txt - Links the class labels with their activity name.

Read the above files and create data tables.

# Read train data

Subject_TrainData <- tbl_df(read.table("./train/subject_train.txt"))

Activity_TrainData <- tbl_df(read.table("./train/Y_train.txt"))

TrainData <- tbl_df(read.table("./train/X_train.txt"))

# Read test data

Subject_TestData  <- tbl_df(read.table("./test/subject_test.txt"))

Activity_TestData  <- tbl_df(read.table("./test/Y_test.txt"))

TestData  <- tbl_df(read.table("./test/X_test.txt"))


Part 1 - Merge the training and the test sets to create one data set
We can use combine the respective data in training and test data sets corresponding to subject, activity and features. 

# merge the training and the test sets by row binding and rename variables "subject" and "activityNum"

oneSubjectData <- rbind(Subject_TrainData, Subject_TestData)

setnames(oneSubjectData, "V1", "subject")

oneActivityData <- rbind(Activity_TrainData, Activity_TestData)

setnames(oneActivityData, "V1", "activityNum")

#combine the training and test data

oneData <- rbind(TrainData, TestData)

Naming the columns
The columns in the features data set can be named 

# name variables according to feature 

FeaturesData <- tbl_df(read.table("./features.txt"))

setnames(FeaturesData , names(FeaturesData), c("featureNum", "featureName"))

colnames(oneData) <- FeaturesData$featureName

#column names for activity labels

activity_Labels <- tbl_df(read.table("./activity_labels.txt"))

setnames(activity_Labels, names(activity_Labels), c("activityNum","activityName"))

# Merge columns

allSubActData <- cbind(oneSubjectData, oneActivityData)

oneData <- cbind(allSubActData, oneData)


Part 2 - Extracts only the measurements on the mean and standard deviation for each measurement
Extract the column indices that have either mean or std in them.

# Reading "features.txt" and extracting only the mean and standard deviation

FeaturesMSData <- grep("mean\\(\\)|std\\(\\)",FeaturesData$featureName,value=TRUE) 

# Taking only measurements for the mean and standard deviation 

FeaturesMSData <- union(c("subject","activityNum"), FeaturesMSData)

oneData <- subset(oneData, select=FeaturesMSData) 


Part 3 - Uses descriptive activity names to name the activities in the data set
#enter name of activity 

oneData <- merge(activity_Labels, oneData , by="activityNum", all.x=TRUE)

oneData$activityName <- as.character(oneData$activityName)

# create data with variable means sorted by subject and Activity

Aggregdata<- aggregate(. ~ subject - activityName, data = oneData, mean) 

oneData<- tbl_df(arrange(Aggregdata,subject,activityName))


Part 4 - Appropriately labels the data set with descriptive variable names
Here are the names of the variables in oneData

names(oneData)

 [1] "subject"                     "activityName"                "activityNum"                 "tBodyAcc-mean()-X"           "tBodyAcc-mean()-Y"          
 [6] "tBodyAcc-mean()-Z"           "tBodyAcc-std()-X"            "tBodyAcc-std()-Y"            "tBodyAcc-std()-Z"            "tGravityAcc-mean()-X"       
[11] "tGravityAcc-mean()-Y"        "tGravityAcc-mean()-Z"        "tGravityAcc-std()-X"         "tGravityAcc-std()-Y"         "tGravityAcc-std()-Z"        
[16] "tBodyAccJerk-mean()-X"       "tBodyAccJerk-mean()-Y"       "tBodyAccJerk-mean()-Z"       "tBodyAccJerk-std()-X"        "tBodyAccJerk-std()-Y"       
[21] "tBodyAccJerk-std()-Z"        "tBodyGyro-mean()-X"          "tBodyGyro-mean()-Y"          "tBodyGyro-mean()-Z"          "tBodyGyro-std()-X"          
[26] "tBodyGyro-std()-Y"           "tBodyGyro-std()-Z"           "tBodyGyroJerk-mean()-X"      "tBodyGyroJerk-mean()-Y"      "tBodyGyroJerk-mean()-Z"     
[31] "tBodyGyroJerk-std()-X"       "tBodyGyroJerk-std()-Y"       "tBodyGyroJerk-std()-Z"       "tBodyAccMag-mean()"          "tBodyAccMag-std()"          
[36] "tGravityAccMag-mean()"       "tGravityAccMag-std()"        "tBodyAccJerkMag-mean()"      "tBodyAccJerkMag-std()"       "tBodyGyroMag-mean()"        
[41] "tBodyGyroMag-std()"          "tBodyGyroJerkMag-mean()"     "tBodyGyroJerkMag-std()"      "fBodyAcc-mean()-X"           "fBodyAcc-mean()-Y"          
[46] "fBodyAcc-mean()-Z"           "fBodyAcc-std()-X"            "fBodyAcc-std()-Y"            "fBodyAcc-std()-Z"            "fBodyAccJerk-mean()-X"      
[51] "fBodyAccJerk-mean()-Y"       "fBodyAccJerk-mean()-Z"       "fBodyAccJerk-std()-X"        "fBodyAccJerk-std()-Y"        "fBodyAccJerk-std()-Z"       
[56] "fBodyGyro-mean()-X"          "fBodyGyro-mean()-Y"          "fBodyGyro-mean()-Z"          "fBodyGyro-std()-X"           "fBodyGyro-std()-Y"          
[61] "fBodyGyro-std()-Z"           "fBodyAccMag-mean()"          "fBodyAccMag-std()"           "fBodyBodyAccJerkMag-mean()"  "fBodyBodyAccJerkMag-std()"  
[66] "fBodyBodyGyroMag-mean()"     "fBodyBodyGyroMag-std()"      "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 

Bleading t or f is based on time or frequency measurements.
Body = related to body movement.
Gravity = acceleration of gravity
Acc = accelerometer measurement
Gyro = gyroscopic measurements
Jerk = sudden movement acceleration
Mag = magnitude of movement
mean and SD are calculated for each subject for each activity for each mean and SD measurements. The units given are g's for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.

names(oneData)<-gsub("std()", "STD", names(oneData))

names(oneData)<-gsub("mean()", "MEAN", names(oneData))

names(oneData)<-gsub("^t", "Time", names(oneData))

names(oneData)<-gsub("^f", "Frequency", names(oneData))

names(oneData)<-gsub("Acc", "Accelerometer", names(oneData))

names(oneData)<-gsub("Gyro", "Gyroscope", names(oneData))

names(oneData)<-gsub("Mag", "Magnitude", names(oneData))

names(oneData)<-gsub("BodyBody", "Body", names(oneData))

names(oneData)

[1] "subject"                                        "activityName"                                   "activityNum"                                   
 [4] "TimeBodyAccelerometer-MEAN()-X"                 "TimeBodyAccelerometer-MEAN()-Y"                 "TimeBodyAccelerometer-MEAN()-Z"                
 [7] "TimeBodyAccelerometer-STD()-X"                  "TimeBodyAccelerometer-STD()-Y"                  "TimeBodyAccelerometer-STD()-Z"                 
[10] "TimeGravityAccelerometer-MEAN()-X"              "TimeGravityAccelerometer-MEAN()-Y"              "TimeGravityAccelerometer-MEAN()-Z"             
[13] "TimeGravityAccelerometer-STD()-X"               "TimeGravityAccelerometer-STD()-Y"               "TimeGravityAccelerometer-STD()-Z"              
[16] "TimeBodyAccelerometerJerk-MEAN()-X"             "TimeBodyAccelerometerJerk-MEAN()-Y"             "TimeBodyAccelerometerJerk-MEAN()-Z"            
[19] "TimeBodyAccelerometerJerk-STD()-X"              "TimeBodyAccelerometerJerk-STD()-Y"              "TimeBodyAccelerometerJerk-STD()-Z"             
[22] "TimeBodyGyroscope-MEAN()-X"                     "TimeBodyGyroscope-MEAN()-Y"                     "TimeBodyGyroscope-MEAN()-Z"                    
[25] "TimeBodyGyroscope-STD()-X"                      "TimeBodyGyroscope-STD()-Y"                      "TimeBodyGyroscope-STD()-Z"                     
[28] "TimeBodyGyroscopeJerk-MEAN()-X"                 "TimeBodyGyroscopeJerk-MEAN()-Y"                 "TimeBodyGyroscopeJerk-MEAN()-Z"                
[31] "TimeBodyGyroscopeJerk-STD()-X"                  "TimeBodyGyroscopeJerk-STD()-Y"                  "TimeBodyGyroscopeJerk-STD()-Z"                 
[34] "TimeBodyAccelerometerMagnitude-MEAN()"          "TimeBodyAccelerometerMagnitude-STD()"           "TimeGravityAccelerometerMagnitude-MEAN()"      
[37] "TimeGravityAccelerometerMagnitude-STD()"        "TimeBodyAccelerometerJerkMagnitude-MEAN()"      "TimeBodyAccelerometerJerkMagnitude-STD()"      
[40] "TimeBodyGyroscopeMagnitude-MEAN()"              "TimeBodyGyroscopeMagnitude-STD()"               "TimeBodyGyroscopeJerkMagnitude-MEAN()"         
[43] "TimeBodyGyroscopeJerkMagnitude-STD()"           "FrequencyBodyAccelerometer-MEAN()-X"            "FrequencyBodyAccelerometer-MEAN()-Y"           
[46] "FrequencyBodyAccelerometer-MEAN()-Z"            "FrequencyBodyAccelerometer-STD()-X"             "FrequencyBodyAccelerometer-STD()-Y"            
[49] "FrequencyBodyAccelerometer-STD()-Z"             "FrequencyBodyAccelerometerJerk-MEAN()-X"        "FrequencyBodyAccelerometerJerk-MEAN()-Y"       
[52] "FrequencyBodyAccelerometerJerk-MEAN()-Z"        "FrequencyBodyAccelerometerJerk-STD()-X"         "FrequencyBodyAccelerometerJerk-STD()-Y"        
[55] "FrequencyBodyAccelerometerJerk-STD()-Z"         "FrequencyBodyGyroscope-MEAN()-X"                "FrequencyBodyGyroscope-MEAN()-Y"               
[58] "FrequencyBodyGyroscope-MEAN()-Z"                "FrequencyBodyGyroscope-STD()-X"                 "FrequencyBodyGyroscope-STD()-Y"                
[61] "FrequencyBodyGyroscope-STD()-Z"                 "FrequencyBodyAccelerometerMagnitude-MEAN()"     "FrequencyBodyAccelerometerMagnitude-STD()"     
[64] "FrequencyBodyAccelerometerJerkMagnitude-MEAN()" "FrequencyBodyAccelerometerJerkMagnitude-STD()"  "FrequencyBodyGyroscopeMagnitude-MEAN()"        
[67] "FrequencyBodyGyroscopeMagnitude-STD()"          "FrequencyBodyGyroscopeJerkMagnitude-MEAN()"     "FrequencyBodyGyroscopeJerkMagnitude-STD()"     

Part 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
#Write tidy data into a text file

write.table(oneData, "TidyDFile.txt", row.name=FALSE)


The tidy data set a set of variables for each activity and each subject, which was written into TidyDFile.txt. The tidy data set's first row is the header containing the names for each column.
