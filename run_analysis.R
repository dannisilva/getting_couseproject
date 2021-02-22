library(data.table)
library(dplyr)

names_features = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/features.txt"))
activity_labels = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/activity_labels.txt"))

#TRAIN
id_train = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/train/subject_train.txt",
                           col.names = "id"))
x_train = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/train/X_train.txt"))
head(x_train)
names(x_train) = names_features$V2
head(x_train)

y_train = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/train/y_train.txt"))
y_train = merge(y_train, activity_labels, by = "V1")
head(y_train)
names(y_train) = c("code_activity", "activity")


#TEST
id_test = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/test/subject_test.txt",
                          col.names = "id"))
x_test = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/test/X_test.txt"))
head(x_test)
names(x_test) = names_features$V2
head(x_test)

y_test = as_tibble(fread("/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/UCI HAR Dataset/test/y_test.txt"))
y_test = merge(y_test, activity_labels, by = "V1")
head(y_test)
names(y_test) = c("code_activity", "activity")

#Merges the training and the test sets to create one data set.
x = rbind(x_train, x_test)
y = rbind(y_train, y_test)
ids = rbind(id_train, id_test)

data_full = cbind(ids, x, y)
head(data_full)

#Extracts only the measurements on the mean and standard deviation for each measurement. 

data_full_sel = data_full %>% select(id, contains("mean"), contains("sdt"), activity)
head(data_full_sel)

#Uses descriptive activity names to name the activities in the data set
#already made

#Appropriately labels the data set with descriptive variable names. 
names(data_full_sel)
names(data_full_sel) = gsub("Acc", "Accelerometer", names(data_full_sel))
names(data_full_sel) = gsub("Gyro", "Gyroscope", names(data_full_sel))
names(data_full_sel) = gsub("[ˆt]+[B]", "TimeB", names(data_full_sel))
names(data_full_sel) = gsub("[ˆf]+[B]", "FrequencyB", names(data_full_sel))
names(data_full_sel) = gsub("Mag", "Magnitude", names(data_full_sel))
names(data_full_sel) = gsub("BodyBody", "Body", names(data_full_sel))
names(data_full_sel) = gsub("-mean()", "Mean", names(data_full_sel))
names(data_full_sel) = gsub("Freq()", "Frequency", names(data_full_sel))
names(data_full_sel) = gsub(",gravity", "Gravity", names(data_full_sel))
names(data_full_sel) = gsub("\\(", "", names(data_full_sel))
names(data_full_sel) = gsub("\\)", "", names(data_full_sel))
names(data_full_sel) = gsub("angle", "Angle", names(data_full_sel))

names(data_full_sel)

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

res_data = data_full_sel %>% 
        group_by(id, activity) %>%
        summarise_if(is.numeric, mean)

<<<<<<< HEAD
write.table(res_data, 
       "/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/getting_couseproject/res_data.txt",
       row.names = F)
=======
fwrite(res_data, "/Users/danielesilva/Documents/Curso de Ciencia de Dados/Getting and Cleaning Data/Course project/getting_couseproject/res_data.txt")
>>>>>>> 354e4632eb0c7f11e4fa3b0a55355bea14ae1dab
