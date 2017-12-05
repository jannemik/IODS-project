#Janne Mikkonen
#Creating a combined data set of human development and gender inequality data files

#EXERCISE 4

#Read the "Human development" and "Gender inequality" data files

hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Explore the hd data
str(hd)
dim(hd)
summary(hd)

#There are 8 variables and 195 observations in the data.
#The observations are countries which are ranked based on human development index.

#Explore the gli data
str(gii)
dim(gii)
summary(gii)

#There are 10 variables and 195 observations in the data
#The observations are countries which are ranked based on gender inequality index.

#Rename the columns of hd

colnames(hd)
colnames(hd) <- c("hdrank", "country", "hdi", "le", "expedu", "meanedu", "gni", "gnihdi")
colnames(hd)

#Rename the columns of hd

colnames(gii)
colnames(gii) <- c("giirank", "country", "gii", "matmort", "adolbirthrate", "parliament", "f2edu", "m2edu", "flabour", "mlabour")
colnames(gii)

#Create sex-ratios of secondary education and labour force participation in the gii data

library(dplyr)

gii <- mutate(gii, edu2ratio = f2edu / m2edu)
gii <- mutate(gii, labratio = flabour / mlabour)

#Join the two data sets by country

human <- inner_join(hd, gii, by = "country")

str(human)
dim(human)

#The joined data has the same number of countries (195) as tbe original data files.
#There are now 19 variables in the joined data

#Save the data
setwd("~/Documents/GitHub/IODS-project/data")
write.csv(human, file = "human.csv", row.names = FALSE)

#EXERCISE 5

#Read the data file that was created in the last exercise
human <- read.csv(file = "human.csv")

#Transform the Gross National Income (GNI) variable to numeric 
library(stringr)
str(human$gni)
human$gni <- str_replace(human$gni, pattern=",", replace ="") %>% as.numeric()

#Remove unneeded columns
library(dplyr)
keep_columns <- c("country", "f2edu", "flabour", "expedu", "le", "gni", "matmort", "adolbirthrate", "parliament")
human_ <- select(human, one_of(keep_columns))

#Remove all rows with missing values
complete.cases(human_)
comp <- complete.cases(human_)
human_ <- filter(human_, comp == TRUE)

#Remove the observations which relate to regions instead of countries (there are 7 of them)
tail(human_, n = 10)
last <- nrow(human_) - 7
human_ <- human_[1:last, ]

#Add countries as row names
rownames(human_) <- human_$country

# remove the Country variable
human_ <- select(human_, -country)

#Examine the data
str(human_)

#There are not 155 obs and 8 var

#Save the modified data (overwrite the old)
write.csv(human, file = "human.csv", row.names = TRUE)

