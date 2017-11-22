#Janne Mikkonen
#21.11.2017
#Create analysis data on student performance and alcohol consumption

#Read the data files
setwd("~/Documents/GitHub/IODS-project/data")
math <- read.csv("student-mat.csv", header = TRUE, sep = ";")
por <- read.csv("student-por.csv", header = TRUE, sep = ";")

#Explore the structure and dimensions of these data sets
str(math)
dim(math)
str(por)
dim(por)

#Both data sets have 33 variables, which have the same names and include both factors and integers
#Math data set has 395 observations whereas por dataset has 649 observations

#Join the data sets with the help of dpylr package
library(dplyr)

#Common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

#Join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

#Explore the structure and dimensions of the new data set
str(math_por)
dim(math_por)

#The joined data includes 53 varibles because we did not use all variables for joining
#The number of observations is now 382: based on the identifiers, this many students were
#included in both data sets

#Next we need to combine also those variables that were not used for joining the data sets
#Since the responses could differ, we pick either the mean (integers) or the first value (factors)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

#Define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

#Define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#Explore the data with glimpse
glimpse(alc)

#Our alc dataframe now contains all the original varibles combined for 382 observations
#We have also created a variable measuring total alcohol consumption and a logical variable
#indicating high alcohol consumption

#Save the joined and modified data set
write.csv(alc, file = "alc.csv", row.names = FALSE)
