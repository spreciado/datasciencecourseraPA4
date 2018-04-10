# WD and libraries

setwd("UCI HAR Dataset")
library(tidyr)
library(dplyr)

#Reading the data

activity_labels <-  read.table("activity_labels.txt", 
                        colClasses = c("numeric", "character"))
features <-  read.table("features.txt", 
                             colClasses = c("numeric", "character"))

##train set
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

train <- data.frame(subject_train, "train", y_train, X_train)
train <- tbl_df(train)
rm(subject_train, X_train, y_train)

##test set

subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")

test <- data.frame(subject_test, "test", y_test, X_test)
test <- tbl_df(test)

colnames(test)[2] <- colnames(train)[2] <- "x"
rm(subject_test, X_test, y_test)

#Merge train and test set

dataset <- bind_rows(train, test)

#cols that contains mean or std 

meanstd_cols <- which(grepl("mean\\()", features[, 2]) | 
                        grepl("std()",features[, 2]))
dataset <- select(dataset, c(1, 2, 3, meanstd_cols + 3))

colnames(dataset) <- c("subject", "type_of_measurement" ,"activity", 
                    features[meanstd_cols, 2])
dataset <-
  mutate(dataset, activity = factor(activity, levels = c(1:nrow(activity_labels)), 
                                    labels = activity_labels[, 2]))

#New dataset

dataset2 <- dataset %>% gather(Signal ,Value, -(subject:activity)) %>% 
  separate(Signal, c("signal", "signal_type","direction"))


write.table(
  dataset2,
  "S:/Data_Science_course/datasciencecourseraPA4/dataset2.txt",
  row.names = F
)