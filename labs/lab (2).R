#nycflights13
install.packages("nycflights13")
install.packages("RMySQL")
install.packages("RSQLite")
install.packages("mosaic")
install.packages("dplyr")
install.packages("plyr")

library(RMySQL)
library(RSQLite)
library(DBI)
library(mosaic)
library(dplyr)
library(nycflights13)
library(tidyr)
library(plyr)

#See what's in the package 
data(package="nycflights13")
#Five data sets as as follows
?airlines
?airports
?flights
?planes
?weather

#Check what variables are there.
flights[1,]
table(weather[,1])

table(flights$orig)
LGA(LaGuardia Airport)
EWR(Newark Liberty International Airport)
JFK(John F. Kennedy International Airport)

?subset
#1
mysubset<- subset(flights, origin = "EWR")
head(mysubset)
unite(mysubset, "Date",year,month,day,sep ="-")

#2
mysubset1<- subset(flights, origin = "EWR")
head(mysubset1)
mysubset2 <- unite(mysubset, "Date",year,month,day,hour,sep ="-")

data(airports)
head(airports)
airports1 <- mysubset %>% select(date, dep_delay)

#3
avg <- ddply(mysubset1,c("temp","wind_speed","visib","precip"), summarise, mean = mean(date))

mysubset2 %>% summarise(delay = mean(dep_delay, na.rm=TRUE),n = n()) %>% filter(mysubset1, delay > 15)
head(mysubset2)
