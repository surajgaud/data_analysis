#exploratory data analysis on the kaggle titanic data
#goals : read the entire data
#        fix missing data
getwd()
library(plyr)
data  <- read.csv("full.csv") #1309 observations
dim(data)
summary(data)
class(data$embarked)
