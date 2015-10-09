
HW 3: due 11 pm on Feb 12
We are going to use data sets in "nycflights13" package
#Data sets are related to flights that departed from NYC in 2013

#nycflights13
install.packages("nycflights13")
install.packages("RMySQL")
install.packages("RSQLite")
install.packages("mosaic")
install.packages("dplyr")

library(RMySQL)
library(RSQLite)
library(DBI)
library(mosaic)
library(dplyr)
library(nycflights13)

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

#Single table verbs 

During the month of August in 2013, what is the
distribution of delays for  flights leaving New Yorks LaGuardia Airport?

First get the data whose orig is EWR. 
what proportion of flights were delayed (15 minutes or more)?
what is the average delay?
how the average delay relate to time of day? 
how the average delay relate to weather? 
how the average delay relate to destination?
Always check your newly created data or combined data has correct information. 

1. create date variable by combining year, month, day for subset orig="EWR" 


flights1 <-filter(flights, origin == "EWR") %>% unite("date", year, month, day, sep= "-")
dim(flights);dim(flights1)
flights2 <-filter(flights1, dep_delay!= "NA", hour != "NA")
dim(flights2)

flights1 <-filter(flights, origin == "EWR") %>% unite("date", year, month, day, sep= "-")
dim(flights);dim(flights1)
flights2 <-filter(flights1, dep_delay!= "NA", hour != "NA")
dim(flights2)

2. calculate average delay for each date and every hour 

average_delay<-flights2 %>%
group_by(date, hour) %>%
summarise(delay=mean(dep_delay), n=n()) %>%
filter(n>10)
summary(average_delay)
dim(average_delay)
#missing values were eliminated already


eliminate missing values from the mean calculation.The size of group should be >10.


3. get mean weather data  (temp, wind_speed, visib, precip) for each date and hour for departure airport =EWR 

weather1 <-filter(weather, origin == "EWR") %>%
unite("date", year, month, day, sep= "-")
summary(weather1)
weather1 <-filter(weather, origin == "EWR") %>%
unite("date", year, month, day,, sep= "-")
summary(weather1)
#How many of them filtered?
dim(weather1)
dim(weather)
weather2 <-filter(weather1, hour != "NA", temp != "NA", wind_speed!= "NA",
precip!= "NA", visib!= "NA")
dim(weather2)
#How many missing values?
average_weather<-weather2 %>% group_by(date,hour) %>%
summarise(mean_temp=mean(temp), mean_windspeed=mean(wind_speed),
mean_visib=mean(visib), mean_precip=mean(precip))
#Do we need this step?
dim(average_weather)

4. combine 2 and 3 data frames inspect the combined data.  

Need to create date.hourvariable to use in merging.
weather2<-weather1 %>%
unite("date.hr", date,hour, sep = ".")
Do the same for average_delay
Merge them by.x='date.hr'and by.y='data.hr'
delay_weather<-merge(average_delay,average_weather,
by.x='date', by.y='date', all.x=FALSE,all.y=FALSE) %>% filter(hour.x== hour.y)



5. plot the average delay (hourly data) and hourly visibilty , temp, wind_speed, precip using the combined data
delay_weather1 <-filter(delay_weather, mean_windspeed!= max(mean_windspeed),
mean_precip<= 0.3)
figure1 <-xyplot(delay ~ hour.x, data=delay_weather1); figure1
figure2 <-xyplot(delay ~ mean_visib, data=delay_weather1); figure2
figure3 <-xyplot(delay ~ mean_temp, data=delay_weather1); figure3
figure4 <-xyplot(delay ~ mean_windspeed,data=delay_weather1); figure4
figure5 <-xyplot(delay ~ mean_precip, data=delay_weather1); figure5
6. summarize the fight data grouping by destination and date. 
  Check the average delay is related to the destination. groups size > 0 

# Check the average delay is related to the destination. no group size restriction.
flights4 <-flights2 %>% group_by(dest,date) %>%
  summarise(delay=mean(dep_delay), n=n()) %>% filter(n>10)
#no group size restriction
flights5 <-flights2 %>% group_by(dest,date) %>%
  summarise(delay=mean(dep_delay), n=n()) %>% filter(n>0)
summary(flights4)
dim(flights4)
dim(flights2)
dim(flights5)
mean( ~ delay | dest, data= flights4)
bwplot(delay ~ dest, data=flights4)


Selection of group size >10 from grouped_data could be done by
grouped_data %>%
  summarise(
    delay = mean(dep_delay),
    n = n()
  ) %>%
  filter(n > 10)
