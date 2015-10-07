#nycflights13
install.packages("nycflights13")
install.packages("RMySQL")
install.packages("RSQLite")
install.packages("mosaic")
install.packages("dplyr")
install.packages("tidyr")

library(RMySQL)
library(RSQLite)
library(DBI)
library(mosaic)
library(dplyr)
library(nycflights13)
library(tidyr)

#See what's in the package 
data(package="nycflights13")
#Five data sets as as follows
?airlines
head(airlines)
?airports
head(airports)
?flights
head(flights)
?planes
head(planes)
?weather
head(weather)

#Check what variables are there.
flights[1,]
table(weather[,1])

table(flights$orig)
LGA(LaGuardia Airport)
EWR(Newark Liberty International Airport)
JFK(John F. Kennedy International Airport)

First get the data whose orig is EWR. 
what proportion of flights were delayed (15 minutes or more)?
what is the average delay?
how the average delay relate to time of day? 
how the average delay relate to weather? 
how the average delay relate to destination?
Always check your newly created data or combined data has correct information.

flights1 <- filter(flights,origin == "EWR")
head(flights1)

flights2  <- unite(flights1,"date", year,month,day, sep = "/" )


#alternately if you want to use the same two operations
#in a single line you can use %>%

ewrdata  <- filter(flights,origin == "EWR") %>% unite("date", year, month, day , sep = "-")
dim(ewrdata)

average_delay <- ewrdata %>%
  group_by(date, hour) %>%
  summarise(delay=mean(dep_delay), n=n()) %>%
  filter(n>10)

summary(average_delay)
dim(average_delay)


weather1 <- filter(weather, origin == "EWR") %>%
  unite("date", year, month, day, sep = "-")
summary(weather1)
#How many of them filtered?
dim(weather1)
dim(weather)

weather2 <- filter(weather1, hour != "NA", temp != "NA", wind_speed != "NA", precip != "NA", visib != "NA")
dim(weather2)
#How many missing

average_weather <- weather2 %>% group_by(date,hour) %>%
  summarise(mean_temp=mean(temp), mean_windspeed=mean(wind_speed), mean_visib=mean(visib), mean_precip=mean(precip))
#Do we need this step?
dim(average_weather)

delay_weather <- merge(average_delay,average_weather,
                       by.x='date', by.y='date', all.x=FALSE,all.y=FALSE) %>% filter(hour.x == hour.y)

delay_weather1 <- merge(average_delay,average_weather,
                       by.x='date', by.y='date', all.x=FALSE,all.y=FALSE)

delay_weather2 <- filter(delay_weather, mean_windspeed != max(mean_windspeed),mean_precip <= 0.3)
figure1 <- xyplot(delay ~ hour.x, data=delay_weather2); figure1
figure2 <- xyplot(delay ~ mean_visib, data=delay_weather2); figure2
figure3 <- xyplot(delay ~ mean_temp, data=delay_weather2); figure3
figure4 <- xyplot(delay ~ mean_windspeed,data=delay_weather2); figure4
figure5 <- xyplot(delay ~ mean_precip, data=delay_weather2); figure5


flights4 <- ewrdata %>% group_by(dest,date) %>%
  summarise(delay=mean(dep_delay), n=n()) %>% filter(n>10)
#no group size restriction
flights5 <- ewrdata %>% group_by(dest,date) %>%
  summarise(delay=mean(dep_delay), n=n()) %>% filter(n>0)
summary(flights4)
dim(flights4)
dim(flights2)
dim(flights5)
mean( ~ delay | dest, data= flights4)
bwplot(delay ~ dest, data=flights4)

mean( ~ delay | dest, data= flights5)
bwplot(delay ~ dest, data=flights5)
bwplot(dest ~ delay, data=flights5)
#too crowded?
bwplot(dest ~ log10(delay-min(delay)+1), data=flights5)
#why subtract min(delay)? why add 1?
