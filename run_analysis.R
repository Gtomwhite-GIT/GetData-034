## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Reference: https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.pdf
# Reference: https://cran.r-project.org/web/packages/reshape2/reshape2.pdf

# Install Needed Packages if not previously installed
if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}

require("data.table")
require("reshape2")

# Extract zip file getdata-projectfiles-UCI HAR Dataset.zip in working directory

# Extracts only the measurements on the mean and standard deviation for each measurement.
# Features - To be used for data columns
  features <- read.table("./UCI HAR Dataset/features.txt")[,2]

# Build values to extract only the mean and standard deviation for each measurement.
  extract_features <- grepl("mean|std", features)

# Merge the training and the test sets to create one data set
# Prepping test data set for merge
# Activity labels 
  activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")[,2]

# Load and process X_test & y_test data.
  X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
  y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
  subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

  names(X_test) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
  X_test = X_test[,extract_features]

# Load activity labels
  y_test[,2] = activity_labels[y_test[,1]]
  names(y_test) = c("Activity_ID", "Activity_Label")
  names(subject_test) = "Subject"

# Bind test data
  test_data <- cbind(as.data.table(subject_test), y_test, X_test)

# Prepping train data set for merge
# Load and process X_train & y_train data.
  X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
  y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

  subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

  names(X_train) = features

# Extract only the measurements on the mean and standard deviation for each measurement.
  X_train = X_train[,extract_features]

# Load activity labels
  y_train[,2] = activity_labels[y_train[,1]]
  names(y_train) = c("Activity_ID", "Activity_Label")
  names(subject_train) = "Subject"

# Bind train data
  train_data <- cbind(as.data.table(subject_train), y_train, X_train)

# Merge test and train data
  data = rbind(test_data, train_data)

# Appropriately labels the data set with descriptive activity names.
  id_labels   = c("Subject", "Activity_ID", "Activity_Label")
  data_labels = setdiff(colnames(data), id_labels)
  melt_data      = melt(data, id = id_labels, measure.vars = data_labels)

# Create a second, independent tidy data set with the average of each variable for each activity and each subject.
# Apply mean function to dataset using dcast function
  tidy_data   = dcast(melt_data, Subject + Activity_Label ~ variable, mean)

  write.table(tidy_data, file = "./tidy_data.txt", row.names = FALSE)
