
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep="")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")

testCombined <- cbind(subject_test, ytest, xtest)

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep="")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")

trainCombined <- cbind(subject_test, ytest, xtest)

testTrainCombined <- rbind(testCombined, trainCombined)
names(testTrainCombined)[1:2] <- c("Subject","Label")

#did the regex filtering in Notepad++, not in R.
extract <- select(testTrainCombined, Subject, Label, V1, V2, V3, V4, V5, V6, V41, V42, V43, V44, V45, V46, V81, V82, V83, V84, V85, V86, V121, V122, V123, V124, V125, V126, V161, V162, V163, V164, V165, V166, V201, V202, V214, V215, V227, V228, V240, V241, V253, V254, V266, V267, V268, V269, V270, V271, V345, V346, V347, V348, V349, V350, V424, V425, V426, V427, V428, V429, V503, V504, V516, V517, V529, V530, V542, V543)

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")

extract$Label <- activity_labels$V2[extract$Label]

#Again did the regex filtering via Notepad++.
features <- read.table("./UCI HAR Dataset/features2.txt", quote="\"", comment.char="")
temp <- select(extract, Subject, Label)
extract2 <- select(extract, !c(Subject, Label))

colnames(extract2) <- features$V2
extract2 <- cbind(temp, extract2)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

extract2 <- extract2 %>% group_by(Subject, Label) %>% summarise_all(mean)
makeCodebook(extract2, reportTitle = "Codebook of run_analysis.R")
write.table(extract2, file = "TidyDataset.txt", row.names=FALSE)
