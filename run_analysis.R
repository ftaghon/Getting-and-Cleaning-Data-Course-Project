### Loading libraries ----
library("stringr", "dplyr")




### Cleaning X data ----
# Loading the train data
X_train = read.table("dataset/train/X_train.txt")
subject_train = read.table("dataset/train/subject_train.txt")

# Loading the test data
X_test = read.table("dataset/test/X_test.txt")
subject_test = read.table("dataset/test/subject_test.txt")

# Merging the train and test data
X = rbind(X_train, X_test)
subjects = rbind(subject_train, subject_test)

# Loading variable names
varnames = read.table("dataset/features.txt")
varnames = varnames[2]
names(varnames) = "variablenames"

# Renaming variables
colnames(X) = varnames$variablenames
colnames(subjects) = "subject"

# Extracting mean and std variables
vars_of_interest = str_detect(colnames(X), "mean")
X = X[vars_of_interest]

# Tidying variable names
colnames(X) = str_replace_all(colnames(X), "\\(", "")
colnames(X) = str_replace_all(colnames(X), "\\)", "")
colnames(X) = str_replace_all(colnames(X), "-", "")
colnames(X) = tolower(colnames(X))

# Adding subject data to X
X = cbind(X, subjects)





### Cleaning y data ----
# Loading y data
y_train = read.table("dataset/train/y_train.txt")
y_test = read.table("dataset/test/y_test.txt")

# Merging the y data
y = rbind(y_train, y_test)

# Renaming y variable
colnames(y) = "activity"

# Loading activity names
actlabels = read.table("dataset/activity_labels.txt")
actlabels = actlabels[2]
names(actlabels) = "activitylabels"

# Changing activity numbers into activity names in y
y$activity = sapply(y$activity, function(x) {actlabels$activitylabels[x]})





### Merging X and y data ----
df = cbind(X, y)




### Computing variables means for each activity and for each subject ----
result = df %>%
    dplyr::group_by(activity, subject) %>%
    dplyr::summarise_all(mean)

write.table(result, "result.txt")



