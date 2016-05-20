library("plyr")
# get the data from the web
#file <- "UCI_HAR_Dataset.zip"
#download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",file, method="curl")
#unzip(file)

# load the data
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

train <- read.table("UCI HAR Dataset/train/X_train.txt")
trainy <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")

test <- read.table("UCI HAR Dataset/test/X_test.txt")
testy <- read.table("UCI HAR Dataset/test/Y_test.txt")
testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")

# put all the colums together
train <- cbind(trainSubjects, trainy, train)
test <- cbind(testSubjects, testy, test)

# merge thre training and the tests set to create one data set
data <- rbind(train, test)
names(data) = c('Subject', 'Activity', features[,2])

# extract only measurements on the mean and standard deviation for each measurement
data <- data[,c(1,2,grep(".*mean.*|.*std.*",names(data)))]

# use descriptive activity names to name the activities in the data set
data <- merge(activityLabels, data, by.x="V1",by.y = "Activity", all=TRUE)
data <- subset(data, select= -V1)

# appropriately label the data set with descriptibe variable names
names(data)[1] <- "Activity"

# create a second, independent tidy data set with the average of each activity and each subject
# columns 1 and 2 are Activity and Subject
average <- ddply(data, .(Activity, Subject), function(x) colMeans(x[, 3:81]))
write.table(average, "average.txt", row.name=FALSE)