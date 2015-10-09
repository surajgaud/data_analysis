require(mosaic)
set.seed(4321)
L<-list(u=sample(c(rep(NA,4),runif(96))),n=rnorm(200),t=sample(c(rep(NA,10),rt(290,df=3))))

#part a

myans <- rbind(mean = (sapply(L,mean, na.rm = TRUE)),#finding the mean and eliminating na values
              variance = (sapply(L,var, na.rm = TRUE)), #finding the variance and eliminating na values
              se =  sapply(L,function(x) sd(x, na.rm = TRUE)/sqrt(length(x[!is.na(x)]))), #finding std error
              obs = sapply(L,function(x) length(x[!is.na(x)])))# finding the number of ovservations
print(myans)

# part b

myfn1 <- function(data) #declaring this function
  {
  myans1 <- rbind(mean = (sapply(data,mean, na.rm = TRUE)),#finding the mean and eliminating na values
                 variance = (sapply(data,var, na.rm = TRUE)), #finding the variance and eliminating na values
                 se =  sapply(data,function(x) sd(x, na.rm = TRUE)/sqrt(length(x[!is.na(x)]))), #finding std error
                 obs = sapply(data,function(x) length(x[!is.na(x)])))# finding the number of ovservations
     rownames(myans1) <- c("mean","var","se","obs")
     print(myans1)
}
myfn1(L) #calling the function


#2a


set.seed(123)
data1=c(rep(NA,10),rcauchy(20),rnorm(970))
mydata <- data1[!is.na(data1)]%>%  sort(mydata, decreasing = FALSE)


myfn2 <- function(data)
  {
     quant = quantile(data,prob=c(0.25,0.75), na.rm = TRUE)
     z = sum(quant)/2
     #print(z)
  }

myfn2(mydata)

#2b

myfn3 <- function(data)
{ 
  mydat  <-  data[!is.na(data)]
  quantile(mydat, 0.25)
  quantile(mydat,0.75)
  xqr <- IQR(mydat)
  xqrsnd <- qnorm(0.75)-qnorm(0.25)
  ro_sd = xqr/xqrsnd
  #print(ro_sd)
} 
myfn3(mydata)




#2c

myfn4 <- function(data){
         set.seed(123)
         bootstrap <- do(500)*myfn2(resample(data))
         myfn4 <- sd(bootstrap)
         print(myfn4)
}

myfn4(mydata,123,500)



#2d

myfn5 <- function(data,size){
         set.seed(123)
         bootstrap <- do(500)*myfn3(resample(data))
         myfn5 <- sd(bootstrap)
         print(myfn5)
}

myfn5(mydata)


#2e

myfn6 <- function(data)
{
  data = data[!is.na(data)]
  midIQR = sapply(data,FUN = myfn2)
  ro_sd = sapply(data,FUN = myfn3)
  se_midIQR = sapply(data,FUN = myfn4)
  se_rsd = sapply(data,FUN = myfn5) 
  obs = sapply(data,function(x) length(x[!is.na(x)]))
  myans2 <- rbind("midIQR","RSD","se.midIQR","se.RSD","obs")
  print(myans2)
}
myfn6(L)











  


