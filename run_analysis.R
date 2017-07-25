## Getting and Cleaning Data Course @ COursera

run_analysis <- function(){
	# getting OS
	os <- Sys.info()
	osname <- os[["sysname"]]

	# constructing path string

	if (osname == "Windows"){
		pathstring <- ".\\UCI HAR Dataset\\"
		pathstringtest <- "test\\"
		pathstringtrain <- "train\\"
	} else {
		pathstring <- "./UCI HAR Dataset/"
		pathstringtest <- "test/"
		pathstringtrain <- "train/"
	}

	# reading test data
	xtest <- read.table(paste(pathstring, pathstringtest, "X_test.txt", sep=""), header = FALSE)
	ytest <- read.table(paste(pathstring, pathstringtest, "y_test.txt", sep=""), col.names = c("activities"), header = FALSE)
	subjecttest <- read.table(paste(pathstring, pathstringtest, "subject_test.txt", sep=""), col.names = c("subject"), header = FALSE)

	# reading train data
	xtrain <- read.table(paste(pathstring, pathstringtrain, "X_train.txt", sep=""), header = FALSE)
	ytrain <- read.table(paste(pathstring, pathstringtrain, "y_train.txt", sep=""), col.names = c("activities"), header = FALSE)
	subjecttrain <- read.table(paste(pathstring, pathstringtrain, "subject_train.txt", sep=""), col.names = c("subject"), header = FALSE)

	# reading column names
	columns <- read.table(paste(pathstring, "features.txt", sep=""), header = FALSE, stringsAsFactors = FALSE, col.names = c("id", "name"))

	#select names with std() and mean() only
	validnames<- columns[grep("std\\(\\)|mean\\(\\)",columns$name), ]

	# cleaning column names: deleting "()-, "
	columnsname <- gsub("[\\(\\), ]?[\\-]?", "", columns$name)
	
	
	columns$name <- make.names(names = columnsname, unique = TRUE)

	# assigning names to columns
	colnames(xtest) <- columns$name
	colnames(xtrain) <- columns$name

	# converting y values to factor
	ytest$activities <- factor(ytest$activities)
	ytrain$activities <- factor(ytrain$activities)

	# appending y values to data set
	xtest <- cbind(xtest, ytest)
	xtrain <-cbind(xtrain, ytrain)

	# appending subject values to data set
	xtest <- cbind(xtest, subjecttest)
	xtrain <-cbind(xtrain, subjecttrain)

	#merging both test and train data
	xdata <- rbind(xtest, xtrain)

	# reading activity labels
	activities <- read.table(paste(pathstring, "activity_labels.txt", sep=""), header = FALSE, stringsAsFactors = FALSE, col.names = c("id", "name"))

	#setting level names for activities
	levels(xdata$activities) <- activities$name

	# xdata is ready


	library(dplyr)
	
	by_groups <- group_by(xdata, subject, activities)
	
	# calculate mean of values for each (subject, activity) group
	xdata2 <- summarise_all(by_groups, funs(mean))
	

	
	#return summarized data
	xdata2
}