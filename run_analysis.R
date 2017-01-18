library("dplyr")
library("plyr")

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if (!file.exists("werabledata.zip")){
    download.file(url1,"werabledata.zip")
}

if (!file.exists("UCI HAR Dataset")){
    unzip("werabledata.zip")
}

#1 Merges the training and the test sets to create one data set.
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt",header = FALSE,dec=".") 
xtest <- read.table("UCI HAR Dataset/test/X_test.txt",header = FALSE,dec=".")
xdata <- rbind(xtrain,xtest)

ytrain <- read.table("UCI HAR Dataset/train/Y_train.txt",header = FALSE,dec=".") 
ytest <- read.table("UCI HAR Dataset/test/Y_test.txt",header = FALSE,dec=".")
ydata <- rbind(ytrain,ytest)

subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt",header = FALSE,dec=".")
subjecttest <- read.table("UCI HAR Dataset/test/subject_test.txt",header = FALSE,dec=".")
subjectdata <- rbind(subjecttrain,subjecttest)
names(subjectdata) <- "subject"

#2 Extracting features having mean and std.

features <- read.table("UCI HAR Dataset/features.txt")
features <- as.character(features[,2])

#names(xdata) <- make.names(features)
meanandstdfeatures <- grep("-mean\\(\\)|-std\\(\\)",features,ignore.case = TRUE)
xdata <- xdata[,meanandstdfeatures]
names(xdata) <- features[meanandstdfeatures]

#3 Uses descriptive activity names to name the activities in the data set
activities <- read.table("UCI HAR Dataset/activity_labels.txt")
ydata[,1] <- activities[ydata[,1],2]
names(ydata) <- "activity"

#4 Appropriately labels the data set with descriptive variable names.

data <- cbind(xdata,ydata,subjectdata)
averages <- ddply(data,.(subject,activity),function(x) colMeans(x[,1:66]))
write.table(averages,"Cleandata.txt",row.names = FALSE)


