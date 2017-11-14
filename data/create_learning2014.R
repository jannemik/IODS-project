#Janne Mikkonen
#14.11.2017
#Exercie 2: Create learning data

#READ DATA

lrn14 <- read.table(
  "http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", 
  sep="\t", 
  header=TRUE
  )

str(lrn14)
dim(lrn14)

#There are 60 variables and 183 observations. 
#Most variables are measured on a scale from 1 to 5.
#There is only one factor variable, gender, which takes the values 1 (F) and 2 (M)

#CREATE COMBINED VARIABLES

# Access the dplyr library
library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)

#RESCALE ATTITUDE

lrn14$attitude <- lrn14$Attitude / 10

#CREATE A NEW DATA SET

# choose a handful of columns to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset
learning2014 <- select(lrn14, one_of(keep_columns))

#RENAME COLUMNS AND EXCLUDE PERSONS WITH ZERO POINTS

colnames(learning2014)
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"
colnames(learning2014)

learning2014 <- filter(learning2014, points > 0)

#SAVE THE DATA

setwd("~/Documents/GitHub/IODS-project/data")
write.csv(learning2014, file = "learning2014.csv", row.names = FALSE)
learning2014 <- read.csv(file = "learning2014.csv")
