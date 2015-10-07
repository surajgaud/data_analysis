
install.packages("devtools")
install.packages("tidyr")
require(tidyr)
require(dplyr)
require(mosaic)
require(devtools)
find_rtools()
devtools::install_github("rstudio/EDAWR")

library(EDAWR)
?storms
?pollution
?cases
?tb

#tb cases
cases


#Wind speed data for six hurricanes
storms


#Pollution data amount of particles
pollution




Tidy data
1. Each variables is saved in its own column
2. Each observation is saved in its own row.
3. Each 'type' of observation stored in a single 
table (here storm)

variables in column, observations in row, each type in a table
Easy to access variable
Automaticlly preserves observations


#tidyr: package that reshapes the layout of tables
#two main functions: gather() and spread()

#cases
Imagine how this data would look if it were tidy with three variables: 
  country year, n

gather()
Collapses multiple columns into two columns:
  1. a key column that contains the former column names
Country 2011 2012 2013
2. a vallue column that contains the former column cells
2:4
gather(cases, "year","n",2:4)

cases: data frame to reshape
"year": name of the new key column (a character string)
"n": name of the new value column (a character string)
2:4: names or numeric indexes of columns to collapse




Imagine how the pollution data set would look tidy with three
variables: city, large, small

pollution: data frame to reshape
size: column to use for keys (new columns names)
amount: columns to use for values (new column cells)


spread(pollution, size,amount)


npol<-spread(pollution, size,amount)
npol2 <- gather(npol,"size","amount",2:3)
npol2[order(npol2$city,decreasing=TRUE),]


#separate()



. Year
. Month
. Day

Separate splits a column by a character string separator.
separate()
storms2<-separate(storms, date, c("year", "month", "day"), sep = "-")
storms2


#unite()
Unite unites columns into a single column.
unite()
unite(storms2, "date", year, month, day, sep = "-")


Make observations from variables with gather()
Make variables from observations with spread()
Split and merge columns with unite()
and separate()

Data sets contain
more information
than they display

require(mosaic)
require(mosaicData)
head(CPS85,3)
HELP3 <- mutate(HELPrct,
                risklevel = derivedFactor(
                  low = sexrisk < 5,
                  medium = sexrisk < 10,
                  high = sexrisk >=10,
                  .method = "first" # use first rule that applies
                )
)

weekdays <- c("Sun", "Mon", "Tue", "Wed", "Thr", "Fri", "Sat")
Births <- mutate( Births78,
                  day = factor(weekdays[1 + (dayofyear - 1) %% 7],
                               ordered=TRUE, levels = weekdays) )
data(CPS85)
head(Births,3)

?CPS85;head(CPS85,3)
CPS85 <- mutate(CPS85, workforce.years = age - 6 - educ)
favstats(~workforce.years, data = CPS85)

tally(~(exper - workforce.years), data = CPS85)
CPS85[CPS85$workforce,years,]

HELP2 <- mutate( HELPrct, newsex = factor(female, labels=c('M','F')) )
head(HELP2,3)
#check the coding 
tally(~newsex + female, data = HELP2)

HELP3 <- mutate(HELPrct,
                risklevel = derivedFactor(
                  low = sexrisk < 5,
                  medium = sexrisk < 10,
                  high = sexrisk >=10,
                  .method = "first" # use first rule that applies
                )
)


head(HELP3[, c("sexrisk","risklevel")], 4)
CPS1 <- select(CPS85, -workforce.years)
head(CPS1, 1)
CPS1 <- select(CPS85, c(workforce.years, exper))
head(CPS1, 1)
CPSsmall <- select(CPS85, select = 1:4)
head(CPSsmall, 2)
head(select(HELPrct, contains("risk")), 2)

#%>% operator
HELPrct %>% select(ends_with("e")) %>% head(2)

HELPrct %>% select(starts_with("h")) %>% head(2)

HELPrct %>% select(starts_with("h")) %>% head(2)
HELPrct %>% select(matches("i[12]")) %>% head(2) # regex matching
ddd # small data frame we defined earlier
row.names(ddd) <- c("Abe", "Betty", "Claire", "Don", "Ethel")
ddd # row.names affects how a data.frame prints
names(CPS85)[2] <- "education"
CPS85[1, 1:4]
names(CPS85)[names(CPS85) == "education"] <- "educ" 
#make it clearer what is going on here.
CPS85[1, 1:4]
names(faithful) #yellow stone geyser data  
[1] "eruptions" "waiting"
eruption: duration of an eruption 
waiting: time until the subsequent eruption 
names(faithful) <- c("duration", "time_til_next")
head(faithful, 3)
xyplot(time_til_next ~ duration, faithful)
data(faithful) # restore the original version
faithful2 <- faithful %>%
  select(duration=eruptions, time_til_next = waiting)
head( faithful2, 2 )

faithfulLong <- faithful2 %>% filter(duration > 3)
xyplot(time_til_next ~ duration, faithfulLong)
xyplot( time_til_next ~ duration,
        data = faithful2 %>% filter( duration > 3))

xyplot( time_til_next ~ duration, data = faithful2,
        subset=duration > 3 )


