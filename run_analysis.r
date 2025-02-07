## Libraies I Need
library(data.table)
library(plyr)

## Step 1
## read test and train data! 
subject_test <- read.table("test/subject_test.txt")
x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/Y_test.txt")

subject_train <- read.table("train/subject_train.txt")
x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/Y_train.txt")

## bind data in one dataset
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

## Step 2
## read features and only get the mean and std variables.
features <- read.table("features.txt")
mean_and_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

## Step 3
## select only the right variables and create the good names for the dataset. 
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]

## read activities, updates values, correct colomn name
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

## step 4
## change the last comlomn to a nice name
names(subject_data) <- "subject"

## combine all data
all_data <- cbind(x_data, y_data, subject_data)

## step 5
averages_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
