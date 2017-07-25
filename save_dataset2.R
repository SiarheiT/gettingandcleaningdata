# runs analysis for Getting and Cleaning project and saves dataset

save_dataset2 <- function(csvfilename){
	source("run_analysis.R")
	data<- run_analysis()

	#save data set
	write.csv(data, csvfilename)
}