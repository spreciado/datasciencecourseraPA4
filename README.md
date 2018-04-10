# Getting and Cleaning Data Course Project
This repo contains all the information and code (run_analysis.R) that was used in order to complete the course project for the Getting and Cleaning data course.

# run_analysis.R

In the run_analysis.R code I performed the next steps in order to create a tidy data set.

## 1. Working directory and libraries
In order to perform the analysis I created a R-project linked to my github repo. First I set the wd to the directory in which the data was downloaded and uploaded the dplyr and tidyr packages.

```
setwd("UCI HAR Dataset")
library(tidyr)
library(dplyr)
```

## 2. Reading the data

a.  activity_labels.
```
activity_labels <-  read.table("activity_labels.txt", 
                        colClasses = c("numeric", "character"))
```
b. Features.
```
features <-  read.table("features.txt", 
                             colClasses = c("numeric", "character"))
```
c. Train and test data sets.\
For the train and test data set I executed almost the same code, changing the directories, for reference "word" is going to be either    "train" or "test".
1. Read the subject dataset.
    ```
    subject_word <- read.table("./train/subject_word.txt")
    ```
2. Read the word dataset.
    ```
    X_word <- read.table("./train/X_word.txt")
    ```
3. Read the labels dataset.
    ```
    y_word <- read.table("./word/y_word.txt")
    ```
4. Merge the labels, subject and the values for the word dataset. I included a column as a character, indicating it the values come from de train or test dataset.
    ```
    word <- data.frame(subject_word, "word", y_word, X_word)
    ```
5. For each dataset, I use the tbl_df word prior to merging both databases.
    ```
    word <- tbl_df(word)
    ```
6. The function tbl_df modifies the names of the column that I added, in order to merge them properly I modified the column.
    ```
    colnames(test)[2] <- colnames(train)[2] <- "x"
    ```
7. Erase the uploaded info from the R Environment to free memory.
    ```
    rm(subject_word, X_word, y_word)
    ```

## 3. Analysis
In this section I will explain how I performed each step that was asked to perform in the course project guide. I swapped the order of steps 3 and 4.

1. Merges the training and the test sets to create one data set.\
    I used the bid_rows function from dplyr package to merge the datasets.
    ```
    dataset <- bind_rows(train, test)
    ```
2. Extracts only the measurements on the mean and standard deviation for each measurement.\
    meanstd_cols is a variable that contains only the names that have the words mean() or std(), I used the variable `features` for that purpose.
    ```
    meanstd_cols <- which(grepl("mean\\()", features[, 2]) | 
                            grepl("std\\()",features[, 2]))
    ```
    Since features had 3 columns less than the dataset that contains the train and test data, I had to sum 3 to the columns indicator, then I performed the extraction with the select function from the dplyr package.
    ```
    dataset <- select(dataset, c(1, 2, 3, meanstd_cols + 3))
    ```
3. Appropriately labels the data set with descriptive variable names.\
    The dataset named "features.txt" contained all the names for each one of the features that is in the train and test datasets. I used The first three columns where named by my own criteria, and the remainder where labeled as in the features dataset.
    ```
    colnames(dataset) <- c("subject", "type_of_measurement" ,"activity", 
                        features[meanstd_cols, 2])
    ```
4. Uses descriptive activity names to name the activities in the data set.\
    The variable "subject" was labeled using the information contained in the "activity_labels.txt" dataset. I used the mutate function from the dplyr package to perform the change.
    ```
    dataset <-
      mutate(dataset, activity = factor(activity, levels = c(1:nrow(activity_labels)), 
                                        labels = activity_labels[, 2]))
    ```
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.\
    Only the variables "subject", "type_of measurement" and "activity" where observations of one variable, all the others contained information about the Signal, the signal_type (mean or std) and direction (x, y, z or none). In order to tidy the data I gathered all the variables except for the three that were already ok ("subject", "type_of measurement" and "activity"). Therefore I created a long dataset that had one single value, with that dataset I used the separate function to separate the Signal variable into three new variables called "Signal", "signal_type" and direction.
    ```
    dataset2 <- dataset %>% gather(Signal ,Value, -(subject:activity)) %>% separate(Signal, c("signal", "signal_type","direction"))
    ```
