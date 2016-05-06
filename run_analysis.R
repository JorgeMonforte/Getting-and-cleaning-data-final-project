# UCI HAR Dataset features loader
# Author: Jorge Monforte Gonzalez 


# NOTE: I built in the global namespace instead of a clousure so it is easy to
# poke around with it.

library(dplyr)

# --------------------------------------------------------------------------- 
# Main Functions
# --------------------------------------------------------------------------- 



# Returns the mean and deviation features set

get_mean_deviation_data_frame <- function() {
    init_features()
    features <- get_features()
    features <- extract_columns(features, regex="-mean|-std|Mean")
    features <- merge_activities(features)
    features <- merge_subjects(features)
    end_features()
    features
}

# Computes de means grouped by subject and activity of the variables collected
# with the function get_mean_deviation_data_frame

get_summarised_data <- function() {
    tbl_df(get_mean_deviation_data_frame()) %>% 
            group_by(subject, activity) %>%
            summarise_each(funs(mean))
}


# --------------------------------------------------------------------------- 
# Constant definitions
# --------------------------------------------------------------------------- 

package_url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

full_features <- NULL # Variable to cache the features set

base_dir <- NULL # Path to the data if working from a directory

zip_file <- NULL # Path to the data if working from a zip file

temp_file <- NULL # Path to a temp zip file, if not null it is deleted in
                  # the closing procedures

run_cached <- FALSE # If sets to true it caches the features so you dont have
                   # to reload them each time you run get_features

# --------------------------------------------------------------------------- 
# Auxiliay  functions
# --------------------------------------------------------------------------- 


init_features <- function() {
    if (is.null(zip_file) & is.null(base_dir)) {
        zip_file <<- temp_file <<- tempfile()
        download.file(package_url, temp_file)
    }
}

end_features <- function() {
    if (! is.null(temp_file))
        unlink(temp_file)
        zip_file <<- temp_file <<- NULL
}

extract_columns <- function(df, regex="-mean|-std|Mean") {
    names <- colnames(df)
    df[,grep(regex, names)]
}

# Access to file data functions


open_path <- function(path) {
    path <- file.path("UCI HAR Dataset", path)
    if (! is.null(base_dir)) 
        return(file.path(base_dir, path))
    if (! is.null(zip_file)) 
        return(unz(zip_file, path))
    stop('Unable to access to files')
}

my_readLines <- function(that) {
    data <- readLines(that)
    if (! is.character(that))
        close(that)
    data
}

get_features_file <- function(label) {
	open_path(sprintf('%s/X_%s.txt', label, label))
}

get_subjects_file <- function(label) {
	open_path(sprintf('%s/subject_%s.txt', label, label))
}

get_activities_file <- function(label) {
	open_path(sprintf('%s/y_%s.txt', label, label))
}

get_activities_labels_file <- function() {
	open_path('activity_labels.txt')
}

get_features_colnames_file <- function () {
	open_path('features.txt')
}

# Read and preprocess data from files

load_features_col_names <- function () {
	raw <- my_readLines(get_features_colnames_file())
	sub("^[0-9]{1,3} ", "", raw)
}

load_activities_labels <- function () {
	raw <- my_readLines(get_activities_labels_file())
    sub("^[0-9] ", "", raw)
}

load_features <- function(label) {
	read.table(get_features_file(label))
}

load_subjects <- function(label) {
	as.numeric(my_readLines(get_subjects_file(label)))
}

load_activities <- function(label) {
	as.numeric(my_readLines(get_activities_file(label)))
}

# Returns the main features set

get_features <- function() {
    if (is.null(full_features)) { 
        features <- merge_features()
        if (run_cached)
            full_features <<- features
        return(features) }
    else
        return(full_features)
}

# Combine data to build the main data.frame and name its columns

merge_features <- function() {
        features <- load_features('train')
        features <- rbind(features, load_features('test'))
        colnames(features) <- load_features_col_names()
        features
}

# Function to add subjects to the features dataframe

merge_subjects <- function(df) {    
	subjects <- load_subjects('train')
	subjects <- c(subjects, load_subjects('test'))
    df <- cbind(subjects, df)
    colnames(df)[1] <- "subject"
    df
}

# Function to add activities to the features dataframe

merge_activities <- function(df, colname="activity") {
    activities <- load_activities('train')
    activities <- c(activities, load_activities('test'))
    activities <- factor(activities)
    levels(activities) <- load_activities_labels()
    df <- cbind(activities, df)
    colnames(df)[1] <- colname
    df
}


# Lets run them ...

features <- get_mean_deviation_data_frame()
summarised_features <- get_summarised_data()

