#learning data manipulation with the mosiac packages
#author suraj gaud


require(mosaic)
require(mosaicData)
help(read.table)
getwd()
x <- read.table("No2_data.txt", skip = 16, header = FALSE)
x
xx <- data.frame(x)
names(xx) <- c("NO2", "cph", "temp","wind_speed","temp_diff","wind_dir","hr_of_day", "day_num")
names(xx)
summary(xx)

xyplot(NO2~cph, data = xx)
xyplot(NO2~temp, data = xx)
xyplot(NO2~wind_speed, data = xx)
xyplot(NO2~temp_diff, data = xx)
xyplot(NO2~wind_dir, data = xx)
xyplot(NO2~hr_of_day, data = xx)
xyplot(NO2~day_num, data = xx)

model <- lm(NO2~cph, data=xx)
summary(model)
bootstrap <- do(5000)*lm(NO2~cph, data=resample(xx))
head(bootstrap,10)
prop(~ cph>0.3535, data = bootstrap)
histogram(~cph,data = bootstrap,v=0.3535,glwd=5)
confint(bootstrap)

getwd()

install.packages("xlsx")
require(xlsx)
excelfile <- read.xlsx("Delay Pav-Short ITIs.xls",sheetIndex = 1,rowIndex = 5:100, colIndex = 2:10)
head(excelfile,10)
