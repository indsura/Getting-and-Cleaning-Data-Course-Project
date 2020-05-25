# Downloading the Samsung dataset
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./samsungdataset")
# Unzipping the dataset
unzip("samsungdataset")
# Reading files as tables and assigning variable names as required
features<-read.table("features.txt",col.names=c("n","functions"))
features<-read.table("features.txt",col.names=c("n","functions"))
activity<-read.table("activity_labels.txt",col.names=c("n","Activity"))
x_test<-read.table("X_test.txt",col.names=features$functions)
x_test<-read.table("X_test.txt",col.names=features$functions)
y_test<-read.table("y_test.txt",col.names="code")
x_train<-read.table("X_train.txt",col.names=features$functions)
y_train<-read.table("y_train.txt",col.names="code")
subject_test<-read.table("subject_test.txt",col.names="subject")
subject_train<-read.table("subject_train.txt",col.names="subject")
# STEP 1: Merging the training and testing datasets
X<-rbind(x_test,x_train)
Y<-rbind(y_test,y_train)
Subject<-rbind(subject_test,subject_train)
Merged_Data<-cbind(Subject,Y,X)
# STEP 2: Extracting only the measurements on the mean and standard deviation for each measurement.
meanstdmeasure<-grep("[Mm]ean|std",names(Merged_Data))
meanstdmerged<-Merged_Data[,meanstdmeasure]
meanstdmerged<-cbind(Merged_Data[,1:2],meanstdmerged)
# STEP 3: Using descriptive activity names to name the activities in the data set.
meanstdmerged$code<-activity[meanstdmerged$code,2]
# STEP 4: Appropriately labeling the data set with descriptive variable names.
names(meanstdmerged)[1]<-"Subject"
names(meanstdmerged)[2]<-"Activity"
names(meanstdmerged)<-gsub("Acc", "Accelerometer", names(meanstdmerged))
names(meanstdmerged)<-gsub("Gyro", "Gyroscope", names(meanstdmerged))
names(meanstdmerged)<-gsub("BodyBody", "Body", names(meanstdmerged))
names(meanstdmerged)<-gsub("Mag", "Magnitude", names(meanstdmerged))
names(meanstdmerged)<-gsub("^t", "Time", names(meanstdmerged))
names(meanstdmerged)<-gsub("^f", "Frequency", names(meanstdmerged))
names(meanstdmerged)<-gsub("tBody", "TimeBody", names(meanstdmerged))
names(meanstdmerged)<-gsub("-mean()", "Mean", names(meanstdmerged), ignore.case = TRUE)
names(meanstdmerged)<-gsub("-std()", "STD", names(meanstdmerged), ignore.case = TRUE)
names(meanstdmerged)<-gsub("-freq()", "Frequency", names(meanstdmerged), ignore.case = TRUE)
names(meanstdmerged)<-gsub("angle", "Angle", names(meanstdmerged))
names(meanstdmerged)<-gsub("gravity", "Gravity", names(meanstdmerged))
# Renaming the dataset as a tidy data set
tidydata<-meanstdmerged
# STEP 5: From the data set in step 4, creating a second, independent tidy data set with the average of each variable for each activity and each subject.
groupedtidy<-group_by(tidydata,Subject,Activity)
finaldata<-summarise_all(groupedtidy,mean)
View(finaldata)
write.table(finaldata,"finaldata.txt",row.name = FALSE)