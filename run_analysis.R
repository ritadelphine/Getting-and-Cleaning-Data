#Downloading files
filename <- "A3coursera.zip"
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, filename, method="curl")
unzip(filename)

library(dplyr)

#reading files into R
features <- read.table("UCI HAR Dataset/features.txt", header=F, col.names=c("featurecode", "feature"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", header=F, col.names=c("activitycode", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", header=F, col.names="subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", header=F, col.names = features$feature)
y_test <- read.table("UCI HAR Dataset/test/Y_test.txt", header=F, col.names="activitycode")
subject_train <- read.csv("UCI HAR Dataset/train/subject_train.txt", header=F, col.names="subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", header=F, col.names=features$feature)
y_train <- read.table("UCI HAR Dataset/train/Y_train.txt", header=F, col.names = "activitycode")

#merge training and test sets
Train <- cbind(subject_train, y_train, x_train)
Test <- cbind(subject_test, y_test, x_test)
Complete <- rbind(Train, Test)
View(Complete)

meanstd <- Complete %>% select(subject, activitycode, contains("mean"), contains("std"))

#renaming variables
names(meanstd) <- gsub("^t", "Time", names(meanstd))
names(meanstd) <- gsub("Acc", "Accelerometer", names(meanstd))
names(meanstd) <- gsub("mean", "Mean", names(meanstd))
names(meanstd) <- gsub("\\.", "", names(meanstd))
names(meanstd) <- gsub("Gyro", "Gyroscope", names(meanstd))
names(meanstd) <- gsub("Mag", "Magnitude", names(meanstd))
names(meanstd) <- gsub("Freq", "Frequency", names(meanstd))
names(meanstd) <- gsub("^f", "Frequency", names(meanstd))
names(meanstd) <- gsub("gravity", "Gravity", names(meanstd))
names(meanstd) <- gsub("angle", "Angle", names(meanstd))
names(meanstd) <- gsub("BodyBody", "Body", names(meanstd))
names(meanstd) <- gsub("std", "SD", names(meanstd))

#creating new dataset with averages for each variable
Tidyaverage <- meanstd %>% group_by(subject, activitycode) %>% summarise_all(funs(mean))
write.table(Tidyaverage, "Tidyaverage.txt", row.name=FALSE)
print(Tidyaverage)
