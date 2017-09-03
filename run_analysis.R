#Assume that data file was downloaded and extracted in the R current directory


##Load required packages
library(dplyr)
library(data.table)
library(tidyr)

# Read train data
Subject_TrainData <- tbl_df(read.table("./train/subject_train.txt"))
Activity_TrainData <- tbl_df(read.table("./train/Y_train.txt"))
TrainData <- tbl_df(read.table("./train/X_train.txt"))

# Read test data
Subject_TestData  <- tbl_df(read.table("./test/subject_test.txt"))
Activity_TestData  <- tbl_df(read.table("./test/Y_test.txt"))
TestData  <- tbl_df(read.table("./test/X_test.txt"))

# merge the training and the test sets by row binding and rename variables "subject" and "activityNum"
oneSubjectData <- rbind(Subject_TrainData, Subject_TestData)
setnames(oneSubjectData, "V1", "subject")
oneActivityData <- rbind(Activity_TrainData, Activity_TestData)
setnames(oneActivityData, "V1", "activityNum")

#combine the training and test data
oneData <- rbind(TrainData, TestData)

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


# Reading "features.txt" and extracting only the mean and standard deviation
FeaturesMSData <- grep("mean\\(\\)|std\\(\\)",FeaturesData$featureName,value=TRUE) 

# Taking only measurements for the mean and standard deviation 
FeaturesMSData <- union(c("subject","activityNum"), FeaturesMSData)
oneData <- subset(oneData, select=FeaturesMSData) 


#enter name of activity 
oneData <- merge(activity_Labels, oneData , by="activityNum", all.x=TRUE)
oneData$activityName <- as.character(oneData$activityName)

# create data with variable means sorted by subject and Activity
Aggregdata<- aggregate(. ~ subject - activityName, data = oneData, mean) 
oneData<- tbl_df(arrange(Aggregdata,subject,activityName))


#Look at variable names before rename
names(oneData)

names(oneData)<-gsub("std()", "STD", names(oneData))
names(oneData)<-gsub("mean()", "MEAN", names(oneData))
names(oneData)<-gsub("^t", "Time", names(oneData))
names(oneData)<-gsub("^f", "Frequency", names(oneData))
names(oneData)<-gsub("Acc", "Accelerometer", names(oneData))
names(oneData)<-gsub("Gyro", "Gyroscope", names(oneData))
names(oneData)<-gsub("Mag", "Magnitude", names(oneData))
names(oneData)<-gsub("BodyBody", "Body", names(oneData))

#Look at new variable names
names(oneData)


#Write tidy data into a text file
write.table(oneData, "TidyDFile.txt", row.name=FALSE)




