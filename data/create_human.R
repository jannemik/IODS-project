#Data wrangling for the next week's data

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