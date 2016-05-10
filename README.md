
UCI HAR Dataset features loader
===============================

_IMPORTANT_: The script automatically downloads the data

The run_script.R when sourced from R it downloads the packaged file from the
provided url and loads the data from the contained and stores the data in the
__selected_features__ and __summarized_selected_features__ variables.

This is done with two functions:

get_mean_deviation_data_frame() 
-------------------------------

The behaviour of this function is configured through global variables instead
of parameters and mostly it gets the data calling the **get_features** function
that collects the data from the X features files and merges them in a
data.frame extract builds a new data.frame from the merged one with the columns
names provided by the **features.txt** file. 

Then a new data frame is created selecting the required columns using a regular 
expression, this data frame is then merged with the *activities* and *subjects*
columns that are loaded from the corresponding files.

get_summarised_data(data)
-------------------------

This functions takes the features data frame returned by the previous function
as an argument and with it converted to a dplyr table it transforms it in two
steps in a summarised table with the means computed for each column grouped by
subject and activity.

Other functions
---------------

- download_features function gets the zip file

- The get...file opens a connection or returns the path to be loaded by the
  scripts

- The load... functions reads the data from the files and transforms it to be
  used by the merge functions

- The merge_features function compiles the loaded train and test dataframes
  and labels the columns.

- The merge_subjects and merge_activities are functions that take the main data
  frame as arguments and returns the dataframe with the new column added

