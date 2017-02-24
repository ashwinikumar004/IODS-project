# Course: Introduction to Open Data Science, spring 2017
# Author: Ashwini Kumar
# Date: 09 Feb 2107
# Exercise 4: Clustering and classification (RStudio Exercise 4)


# Read the Human development and Gender inequality data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables.
str(hd)
str(gii)
summary(hd)
summary(gii)

# Look at the meta files and rename the variables with (shorter) descriptive names.
colnames(hd) <- c("HDIrank","country","HDI","lifexxp","expedu","meanedu","GNI","rank2")
colnames(gii) <- c("GIIrank","country","GII","matmor","adbi","repparl","edu2F","edu2M","labF","labM")

# Mutate the Gender inequality data and create two new variables. 
# The first one should be the ratio of Female and Male populations with secondary education in each country. (i.e. edu2F / edu2M). 
# The second new variable should be the ratio of labour force participation of females and males in each country (i.e. labF / labM)
library(dplyr)
gii <- mutate(gii, edu2FMrat = edu2F / edu2M)
gii <- mutate(gii, labFMrat = labF / labM)

# Join together the two datasets using the variable Country as the identifier. 
# Keep only the countries in both data sets (Hint: inner join). 
human <- inner_join(hd, gii, by = "country")

dim(human)
write.csv(human, file = "/Users/ashkumar/Desktop/IODS-project/data/human.csv", row.names = F)

#######################################################################################################################

# Data Wrangling exercise for week 5
human <- read.csv("/Users/ashkumar/Desktop/IODS-project/data/human.csv", header = TRUE)

dim(human)
library(stringr)
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# Selecting variables
library(dplyr)
keep_columns <- c( "country", "edu2F", "labM", "expedu", "lifexxp", "GNI", "matmor", "adbi", "repparl")

human <- dplyr::select(human, one_of(keep_columns))

# Removing all rows with missing variables
keep <- complete.cases(human)
data.frame(human[-1], comp = keep)
human <- filter(human, complete.cases(human))

# Removing regions
tail(human, n = 10)
last <- nrow(human) - 7
human <- human[1:last, ]

# Defining row names
rownames(human) <- human$country

# remove the country col
human$country <- NULL

str(human) # The data has 155 observations of 8 variables
dim(human)
# Replacing the old version of the dataset with the newly-wrangled one
write.csv(human, file = "/Users/ashkumar/Desktop/IODS-project/data/human.csv", row.names = TRUE)
