#this the initial test file 
#author : suraj gaud


getwd()
pima<- read.csv("pima.csv")
head(pima)
require("mosaic") #every session you use
require("mosaicData")
?Births78 #documentation on Births78
data(Births78) #make Births78 data available
head(Births78) #print first 6 lines of the data
xyplot( births ~ date, data=Births78)


bwplot( age ~ substance, data=HELPrct)

histogram( ~age, data=HELPrct )
densityplot( ~age, data=HELPrct )
bwplot( ~age, data=HELPrct )
qqmath( ~age, data=HELPrct )
freqpolygon( ~age, data=HELPrct )
bargraph( ~sex, data=HELPrct )

xyplot( i1 ~ age, data=HELPrct )
bwplot( age ~ substance, data=HELPrct )
bwplot( substance ~ age, data=HELPrct )

