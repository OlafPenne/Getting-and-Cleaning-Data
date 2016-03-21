library(dplyr)


## Load 8 relevant tables

setwd("C:/Users/olaf.penne/Documents/03 Algemeen/Coursera/Assignment3_5/UCI HAR Dataset")

x_test<-read.table("./test/X_test.txt")
y_test<-read.table("./test/y_test.txt")

x_train<-read.table("./train/X_train.txt")
y_train<-read.table("./train/y_train.txt")

subject_test <- read.table("./test/subject_test.txt")
subject_train <- read.table("./train/subject_train.txt")

activity_labels<-read.table("./activity_labels.txt")
features <- read.table("./features.txt")



## Merge dataset Train and Test into one table

x_all<-rbind(x_train,x_test)
y_all<-rbind(y_train,y_test)
subject_all<-rbind(subject_train,subject_test)

## Extracts only mean and standard deviation

mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])  # get only columns with mean() or std() in their names
x_all<-x_all[,mean_and_std_features]
names(x_all)<-features[mean_and_std_features,2]


## Uses descriptive activity names to name the activities in the data set

y_all[, 1] <- activity_labels[y_all[, 1], 2]
total_dataset<-cbind(y_all,subject_all,x_all) ## enrich total dataset with the activities and subject


## Appropriately labels the data set with descriptive variable names.

names(total_dataset) [1:2]<-c("Activity","Subject")


## From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

average_dataset<-ddply(total_dataset,.(Subject,Activity),function (x) colMeans(x[,3:68]))
write.table(average_dataset, "average_dataset.txt",row.name=FALSE)