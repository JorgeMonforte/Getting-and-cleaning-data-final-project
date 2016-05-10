
UCI HAR Dataset features loader
===============================

Column names unitis and other information related to the original data is
provided in the original package. These dataframes include also two columns
*subject* and *activity* that referes to the subject being measured doing the
inidicated activity.

selected_features variable
-----------------

the run_script.R that load data from the UCI HAR Dataset and configures a
dataframe with the combined traning and test data, also including the subject
of the data and with a factor column that indicates the activity, this data is
stored in the global variable *selected_features*.


summarised\_features variable
----------------------------

The run_script.R also compiles a dplyr table that summarises the means of each
original dataset variable for each subject and activity and stores it in the
*summarised_selected_features* variable. The data in each column except those
refering subject and activity are means of the values in the column title.

*WARNING*

As these values are the summarized values of previously summarised values they
should be used with care as they are not computed as means or deviations of 
the original data.
