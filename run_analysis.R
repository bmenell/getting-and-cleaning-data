## FILE STRUCTURES
## This program assumes that you have features.txt is the same directory as this program
## and folders named "train" and "test" as given in the assignment

## LOAD REQUIRED PACKAGES

if (!require("data.table")) {
  install.packages("data.table")
}

if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

## LOAD DATA SETS
message("Loading data sets....")
subject_train <- read.table("train/subject_train.txt")
X_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_test <- read.table("test/subject_test.txt")
X_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")

featureNames <- read.table("features.txt")

## REQUIREMENT 3: USE DESCRIPTIVE ACTIVITY NAMES AND NAME THE ACTIVITIES
message("Naming data sets....")
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2
names(y_train) <- "activity"
names(y_test) <- "activity"

## REQUIREMENT 1: COMBINE INTO ONE DATASET
message("Combining data sets....")
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

## REQUIREMENT 2: EXTRACT ONLY MEAN AND STD DEV
message("Extracting mean and std columns...")
# which columns contain mean() or std()?
meanstdcols <- grepl("mean\\(\\)", names(combined)) | grepl("std\\(\\)", names(combined))

# keep the subjectID and activity columns
meanstdcols[1:2] <- TRUE

# remove columns that are not mean() or std()
combined <- combined[, meanstdcols]

## REQUIREMENT 4: LABEL THE DATASET WITH DESCRIPTIVE NAMES
message("Labeling data sets...")
# convert the activity column from integer to a descriptive label
combined$activity <- factor(combined$activity, labels=c("Walking",
                                                        "Walking Upstairs",
                                                        "Walking Downstairs",
                                                        "Sitting",
                                                        "Standing",
                                                        "Laying"))

## REQUIREMENT 5: CREATE A TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT
message("Melting and writing file...")
melted <- melt(combined, id=c("subjectID","activity"))
tidy <- dcast(melted, subjectID+activity ~ variable, mean)
write.table(tidy, "tidy_data.txt", row.names=FALSE)

