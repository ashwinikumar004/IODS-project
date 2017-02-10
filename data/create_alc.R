# Course: Introduction to Open Data Science, spring 2017
# Author: Ashwini Kumar
# Date: 09 Feb 2107
# Exercise: Logistic regression (RStudio Exercise 3)
# File: Student alcohol consumption
# data source: https://mooc.helsinki.fi/course/view.php?id=52#section-3 

### Read the files
math <-  read.csv("~/Desktop/IODS-project/data/student-mat.csv", sep = ";", header = T)
por <-  read.csv("~/Desktop/IODS-project/data/student-por.csv", sep = ";", header = T)

### Check the structure and dimension of the data
str(math)
dim(math)
str(por)
dim(por)

### Access the dplyr library
library(dplyr)

### Join the two datasets by the selected identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")
math_por <- inner_join(math, por, by =join_by, suffix = c(".math", ".por"))

### Keep duplicated answer data
alc <- select(math_por, one_of(join_by))

### Structure and dimension of joined and duplicated answer data
str(math_por)
dim(math_por)
str(alc)
dim(alc)

### The columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

### For every column name not used for joining...
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

### Define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

### Define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

### Glimplse at the joined and modified data by running the alc twice 
glimpse(alc)

### Export the data
write.csv(alc, file="~/Desktop/IODS-project/data/alc.csv", row.names = F)
