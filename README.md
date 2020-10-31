---
title: "README"
author: "Coen Schoof"
date: "30-10-2020"
output: html_document
---

## How does the script work?

A short walkthrough of the run_analysis.R script for the assignment "Getting and Cleaning Data Course Project" will be provided below.
For the sake of readability, this markdown file is divided based on Coursera's instructions for the assignment (see below):

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

### "1. Merges the training and the test sets to create one data set."

First, single files were combined using cbind for the test data and the training data respectively. 

```
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")

testCombined <- cbind(subject_test, ytest, xtest)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")

trainCombined <- cbind(subject_test, ytest, xtest)
```

After that, both test data and training data were combined using rbind().
Because the first two columns (subject_test/train and ytest/train) automatically were called "V1", I changed the names of these columns to "Subject" and "Label" respectively. I did this to prevent R from trying to calculate the mean of the wrong data.

```
testTrainCombined <- rbind(testCombined, trainCombined)
names(testTrainCombined)[1:2] <- c("Subject","Label")
```

### "2. Extracts only the measurements on the mean and standard deviation for each measurement."

I did the regex filtering in Notepad++, not in R. All relevant columns were extracted and loaded into "extract". After that the activity labels (e.g. STANDING, SITTING, etc) were loaded into "activity_labels".  

```
extract <- select(testTrainCombined, Subject, Label, V1, V2, V3, V4, V5, V6, V41, V42, V43, V44, V45, V46, V81, V82, V83, V84, V85, V86, V121, V122, V123, V124, V125, V126, V161, V162, V163, V164, V165, V166, V201, V202, V214, V215, V227, V228, V240, V241, V253, V254, V266, V267, V268, V269, V270, V271, V345, V346, V347, V348, V349, V350, V424, V425, V426, V427, V428, V429, V503, V504, V516, V517, V529, V530, V542, V543)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
```

### "3. Uses descriptive activity names to name the activities in the data set"

Using some clever indicing I found on the forum. I replaced the activity numbers (1:6) to the actual activities (WALKING, SITTING, etc). 

1. Activity_labels$V2 contains e.g. SITTING, STANDING and WALKING
2. using [extract$Label], which can be 1 to 6, we extract the activity corresponding to the number. For example: activity_labels\$V2[2] would extract the second entry in the activity_labels file, which is WALKING_UPSTAIRS
3. These activities finally replace the old values (1:6) by storing the extracted values into extract$Label

```
extract$Label <- activity_labels$V2[extract$Label]
```

### "4. Appropriately labels the data set with descriptive variable names."

Again, via Notepad++, I extracted all column names ending on "std()" or "mean()" by ctrl-F'ing on "mean|std". These were stored into "features"

To prevent replacing names of the wrong columns, I temporarily stored the first two columns (Subject and Label) into a temporary data frame. After that, I made a data frame that only contains the measurements (so, without the subject numbers and activities) called "extract2". Now that "extract2" is exactly the same length as "features". I was able to replace the column names using "colnames".
Finally, now that the column names were replaced, I cbinded "temp" (containing Subject and Label) with "extract2", thereby finishing with a data set that contain the proper column names, as opposed to V1, V2, V3, etc.

```
features <- read.table("./UCI HAR Dataset/features2.txt", quote="\"", comment.char="")
temp <- select(extract, Subject, Label)
extract2 <- select(extract, !c(Subject, Label))

colnames(extract2) <- features$V2
extract2 <- cbind(temp, extract2)
```

### "5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject."

Using some dplyr piping, I grouped "extract2" by Subject and by Label. After summarizing, this creates a table that shows each activity per participant only once. For example:

2 WALKING
2 WALKING_UPSTAIRS
2 WALKING_DOWNSTAIRS
2 SITTING
2 STANDING
2 LAYING

Finally, the data were written to a .txt file, excluding row names.

```
extract2 <- extract2 %>% group_by(Subject, Label) %>% summarise_all(mean)
write.table(extract2, file = "TidyDataset.txt", row.names=FALSE)
```


## Codebook

The codebook was created using dataMaid. 

### Data report overview
The dataset examined has the following dimensions:


---------------------------------
Feature                    Result
------------------------ --------
Number of observations         54

Number of variables            68
---------------------------------




### Codebook summary table

------------------------------------------------------------------------------------------
Label   Variable                            Class         # unique  Missing  Description  
                                                            values                        
------- ----------------------------------- ----------- ---------- --------- -------------
        **[Subject]**                       integer              9  0.00 %   Subject No.                

        **[Label]**                         character            6  0.00 %   Activity                

        **[tBodyAcc-mean()-X]**             numeric             54  0.00 %                

        **[tBodyAcc-mean()-Y]**             numeric             54  0.00 %                

        **[tBodyAcc-mean()-Z]**             numeric             54  0.00 %                

        **[tBodyAcc-std()-X]**              numeric             54  0.00 %                

        **[tBodyAcc-std()-Y]**              numeric             54  0.00 %                

        **[tBodyAcc-std()-Z]**              numeric             54  0.00 %                

        **[tGravityAcc-mean()-X]**          numeric             54  0.00 %                

        **[tGravityAcc-mean()-Y]**          numeric             54  0.00 %                

        **[tGravityAcc-mean()-Z]**          numeric             54  0.00 %                

        **[tGravityAcc-std()-X]**           numeric             54  0.00 %                

        **[tGravityAcc-std()-Y]**           numeric             54  0.00 %                

        **[tGravityAcc-std()-Z]**           numeric             54  0.00 %                

        **[tBodyAccJerk-mean()-X]**         numeric             54  0.00 %                

        **[tBodyAccJerk-mean()-Y]**         numeric             54  0.00 %                

        **[tBodyAccJerk-mean()-Z]**         numeric             54  0.00 %                

        **[tBodyAccJerk-std()-X]**          numeric             54  0.00 %                

        **[tBodyAccJerk-std()-Y]**          numeric             54  0.00 %                

        **[tBodyAccJerk-std()-Z]**          numeric             54  0.00 %                

        **[tBodyGyro-mean()-X]**            numeric             54  0.00 %                

        **[tBodyGyro-mean()-Y]**            numeric             54  0.00 %                

        **[tBodyGyro-mean()-Z]**            numeric             54  0.00 %                

        **[tBodyGyro-std()-X]**             numeric             54  0.00 %                

        **[tBodyGyro-std()-Y]**             numeric             54  0.00 %                

        **[tBodyGyro-std()-Z]**             numeric             54  0.00 %                

        **[tBodyGyroJerk-mean()-X]**        numeric             54  0.00 %                

        **[tBodyGyroJerk-mean()-Y]**        numeric             54  0.00 %                

        **[tBodyGyroJerk-mean()-Z]**        numeric             54  0.00 %                

        **[tBodyGyroJerk-std()-X]**         numeric             54  0.00 %                

        **[tBodyGyroJerk-std()-Y]**         numeric             54  0.00 %                

        **[tBodyGyroJerk-std()-Z]**         numeric             54  0.00 %                

        **[tBodyAccMag-mean()]**            numeric             54  0.00 %                

        **[tBodyAccMag-std()]**             numeric             54  0.00 %                

        **[tGravityAccMag-mean()]**         numeric             54  0.00 %                

        **[tGravityAccMag-std()]**          numeric             54  0.00 %                

        **[tBodyAccJerkMag-mean()]**        numeric             54  0.00 %                

        **[tBodyAccJerkMag-std()]**         numeric             54  0.00 %                

        **[tBodyGyroMag-mean()]**           numeric             54  0.00 %                

        **[tBodyGyroMag-std()]**            numeric             54  0.00 %                

        **[tBodyGyroJerkMag-mean()]**       numeric             54  0.00 %                

        **[tBodyGyroJerkMag-std()]**        numeric             54  0.00 %                

        **[fBodyAcc-mean()-X]**             numeric             54  0.00 %                

        **[fBodyAcc-mean()-Y]**             numeric             54  0.00 %                

        **[fBodyAcc-mean()-Z]**             numeric             54  0.00 %                

        **[fBodyAcc-std()-X]**              numeric             54  0.00 %                

        **[fBodyAcc-std()-Y]**              numeric             54  0.00 %                

        **[fBodyAcc-std()-Z]**              numeric             54  0.00 %                

        **[fBodyAccJerk-mean()-X]**         numeric             54  0.00 %                

        **[fBodyAccJerk-mean()-Y]**         numeric             54  0.00 %                

        **[fBodyAccJerk-mean()-Z]**         numeric             54  0.00 %                

        **[fBodyAccJerk-std()-X]**          numeric             54  0.00 %                

        **[fBodyAccJerk-std()-Y]**          numeric             54  0.00 %                

        **[fBodyAccJerk-std()-Z]**          numeric             54  0.00 %                

        **[fBodyGyro-mean()-X]**            numeric             54  0.00 %                

        **[fBodyGyro-mean()-Y]**            numeric             54  0.00 %                

        **[fBodyGyro-mean()-Z]**            numeric             54  0.00 %                

        **[fBodyGyro-std()-X]**             numeric             54  0.00 %                

        **[fBodyGyro-std()-Y]**             numeric             54  0.00 %                

        **[fBodyGyro-std()-Z]**             numeric             54  0.00 %                

        **[fBodyAccMag-mean()]**            numeric             54  0.00 %                

        **[fBodyAccMag-std()]**             numeric             54  0.00 %                

        **[fBodyBodyAccJerkMag-mean()]**    numeric             54  0.00 %                

        **[fBodyBodyAccJerkMag-std()]**     numeric             54  0.00 %                

        **[fBodyBodyGyroMag-mean()]**       numeric             54  0.00 %                

        **[fBodyBodyGyroMag-std()]**        numeric             54  0.00 %                

        **[fBodyBodyGyroJerkMag-mean()]**   numeric             54  0.00 %                

        **[fBodyBodyGyroJerkMag-std()]**    numeric             54  0.00 %                
------------------------------------------------------------------------------------------


Report generation information:

 *  Created by: Coen Schoof (username: `CoenSchoof`).

 *  Report creation time: za okt 31 2020 13:09:56

 *  Report was run from directory: `C:/Users/coen_/OneDrive/Bureaublad/Getting and Cleaning Data Course Project`

 *  dataMaid v1.4.0 [Pkg: 2019-12-10 from CRAN (R 4.0.3)]

 *  R version 4.0.3 (2020-10-10).

 *  Platform: x86_64-w64-mingw32/x64 (64-bit)(Windows 10 x64 (build 19041)).

 *  Function call: `dataMaid::makeDataReport(data = extract2, mode = c("summarize", 
"visualize", "check"), smartNum = FALSE, file = "codebook_extract2.Rmd", 
    checks = list(character = "showAllFactorLevels", factor = "showAllFactorLevels", 
        labelled = "showAllFactorLevels", haven_labelled = "showAllFactorLevels", 
        numeric = NULL, integer = NULL, logical = NULL, Date = NULL), 
    listChecks = FALSE, maxProbVals = Inf, codebook = TRUE, reportTitle = "Codebook of run_analysis.R")`






