library(plyr)

# Loading datasets
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
features <- read.table("UCI HAR Dataset/features.txt")
activities <- read.table("UCI HAR Dataset/activity_labels.txt")

# merging training and test datasets
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

# getting the mean and standard deviation measurments 
chosen_features <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, chosen_features]
names(x_data) <- features[chosen_features, 2]

# updating labels
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"
names(subject_data) <- "subject"

# binding all the data
resulting_data <- cbind(x_data, y_data, subject_data)

# creating tidy data
averages_data <- ddply(resulting_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages_data, "tidy_averages.txt", row.name=FALSE)
