getwd()
require("mosaic")
require("mosaicData")
?KidsFeet #fourthgraders feet
head(KidsFeet)
names(KidsFeet)#names of variables
summary(KidsFeet)

histogram( birthyear ~ domhand, data = KidsFeet)
qqmath(biggerfoot ~ sex, data = KidsFeet)
densityplot(birthyear ~ width, data = KidsFeet)
freqploygon(length ~ birthmonth, data = KidsFeet)
bargraph(length ~ width, data = KidsFeet)
xyplot(birthmonth ~ birthyear, data = KidsFeet)
bwplot(birthmonth ~ length, data = KidsFeet)