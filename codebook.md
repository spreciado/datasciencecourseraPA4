# dataset2 codebook

The dataset database was constructed using the information from the Human Activity Recognition Using Smartphones Dataset Version 1.0 by Jorge L. Reyes-Ortiz, Davide Anguita, Alessandro Ghio, Luca Oneto. available at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The dataset contains the information from the train and test dataset merged, it contains only the information of mean and std for each signal. dataset2 is a long database that separated the information contained in each feature, the separation was done indicating if for each feature the value corresponds to mean or std and, the direction (x,y,z or none)

The description of each variable is:
  
* subject: Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
* type_of_measuremente: Indicates if the information corresponds to the train or test set. Is a character.
* activity: Activity that was performed. Factor from 1 to 6, the labels are the same as in the original dataset.
* signal: The signal as described in the feautes_info.txt file in the original dataset. Character
* signal_type: Indicates if the calculated variable is the mean or std. Character.
* direction: Indicates the direction (x,y,z or none). Character.
* Value: The value obtained for each row. Numeric.