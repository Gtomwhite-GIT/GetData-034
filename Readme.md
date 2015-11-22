#Readme.md

## Transformation details

There are five items to be cmpleted by the run_analysis.R script:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## How ```run_analysis.R``` implements the above steps:

* Requires the ```reshape2``` and ```data.table``` libraries.
* Loads the features and activity labels.

		Variables Used
	1. 	features
	2. 	extract_features
	3. 	activity_labels

* Loads both test and train data

		Variables Used
	1. 	X_test
	2. 	Y_test
	3. 	subject_test
	4.	test_data
	5. 	X_train
	6. 	Y_train
	7. 	subject_train
	8.	train_data
	
* Extracts the mean and standard deviation column names and data using the derived extract_features.
* Processes the data in two parts. For test and train data respectively using the variables above.
* Merges test and train data sets using rbind().
* Creates a tidy dataset using melt and dcast.
* Writes the tidy data to a txt dataset where row_names = FALSE

-The run_analysis.R code is also commented for the processing
