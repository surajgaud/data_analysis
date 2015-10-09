require(mosaic)



1. take a list L generated as follows.
set.seed(4321)
L<-list(u=sample(c(rep(NA,4),runif(96))),n=rnorm(200),t=sample(c(rep(NA,10),rt(290,df=3))))

a) derive a matrix where each of the columns contains the mean, variance, 
and number of observations of the list elements, and  standard error of 
the mean(estimated by sd/sqrt(n)).
The missing values should not be counted as the sample size: length(x[!is.na(x)]) would 
count non-missing obs. 
The columns should carry the name of the list elements. 
Use of any loop is stricly forbidden. 

#need to use lapply or sapply function. 
For example, matrix should be of the form  
> x
u            n            t
mean  0.51842419   0.12170747  -0.08644262
var   0.09193359   0.77276779   2.25243932
se    0.03032055   0.06215979   0.08664947
obs  96.00000000 200.00000000 290.00000000

mytable <- rbind(sapply(L,mean,na.rm=TRUE),
                 sapply(L,var,na.rm=TRUE),
                 sapply(L,sd,na.rm=TRUE)/sqrt(sapply(L,function(x) length(x[!is.na(x)]))),
                 sapply(L,function(x) length(x[!is.na(x)])))
dimnames(mytable)<-list(c("mean","var","se","obs"),names(L))
mytable

> mytable
u            n            t
mean  0.52703502   0.06770497   0.15536931
var   0.07821062   0.97695028   2.89634207
se    0.02854284   0.06989100   0.09993691
obs  96.00000000 200.00000000 290.00000000

b) Write a function with data input = L and output is the matrix above. 
#write comments (explainations about what you are doing 
Fmytable <- function(L) {
  
  mytable <- rbind(sapply(L,mean,na.rm=TRUE),
                   sapply(L,var,na.rm=TRUE),
                   sapply(L,sd,na.rm=TRUE)/sqrt(sapply(L,function(x) length(x[!is.na(x)]))),
                   sapply(L,function(x) length(x[!is.na(x)])))
  #calculate component-wise mean, var, se, and sample size eliminating all missing values
  
  dimnames(mytable)<-list(c("mean","var","se","obs"),names(L))
  #put the names on rows and columns
  return(mytable)  
}

Fmytable(L)


2. 
a) Write a function that calculates the location (MidIQR) as the mid-point of 25 percentile 
and 75 percentile from data. 
Need to eliminate all the missing values in the function.
apply it to data1.
set.seed(123);data1=c(rep(NA,10),rcauchy(20),rnorm(970))
MidIQR <- function(data,na.rm=TRUE) {
  if (na.rm){
    data <- data[!is.na(data)] #elimination of missing values
    iqr <- quantile(data,prob=c(1/4,3/4))
    mid <- mean(iqr) }
  else { 
    iqr <- quantile(data,prob=c(1/4,3/4))
    mid <- mean(iqr) } 
  
  return(mid)
}


MidIQR(data=data1,na.rm=TRUE)
mean(data1,na.rm=TRUE);median(data1,na.rm=TRUE)

b) Interquartile range (iqr) is defined as 75 percentile - 75 percentile. 
robust standard deviation (RSD) can be obtained by iqr/(iqr of standard normal distribution).
#iqr of standard normal distribution = qnorm(.75)-qnorm(.25) = 1.34898
Write a function that calculates RSD and apply it to data1. 
RSD <- function(data,na.rm=TRUE) {
  if (na.rm){
    data <- data[!is.na(data)] #elimination of missing values
    iqr <- quantile(data,prob=c(1/4,3/4))
    iqr <- diff(iqr) }
  else { 
    iqr <- quantile(data,prob=c(1/4,3/4))
    iqr <- diff(iqr) } 
  
  return(iqr/(qnorm(3/4)-qnorm(1/4))) #adjust scale factor
}

RSD(data=data1,na.rm=TRUE)
#compare to sd
sd(data1,na.rm=TRUE)

c) Write a function that calculates standard error of MidIQR. You need to use bootstraping to estimate standard error.
Your function should have Bootstrap size as input with default value 500. 

MidIqrse<-function(data,BT=5000,seed=1000,...) { 
  set.seed(seed)
  Bootstrap <- do(BT) * 
    MidIQR(data= resample(data1),...)
  se=sd(Bootstrap)
  return(c(se=se))
}

MidIqrse(data=data1,na.rm=TRUE)

c) Write a function that calculates standard error of RSD. You need to use bootstraping to estimate standard error.
Your function should have Bootstrap size as input with default value 500. 

RSDse<-function(data,BT=5000,seed=1000,...) { 
  set.seed(seed)
  Bootstrap <- do(BT) * 
    RSD(data= resample(data),...)
  se=sd(Bootstrap)
  return(c(se=se))
}

RSDse(data=data1,BT=1000,seed=123,na.rm=TRUE)

d) Write a function that generates table such as for the Data L in problem 1

Fmytable.iqr <- function(L,BT=5000,seed=123,...) {
  
  mytable <- rbind(sapply(L,MidIQR,...),
                   sapply(L,RSD,...),
                   sapply(L,MidIqrse,BT=BT,seed=seed,...),
                   sapply(L,RSDse,BT=BT,seed=seed,...),
                   sapply(L,function(x) length(x[!is.na(x)])))
  #calculate component-wise mean, var, se, and sample size eliminating all missing values
  
  dimnames(mytable)<-list(c("MidIQR","RSD","se.MidIQR","se.RSD","obs"),names(L))
  #put the names on rows and columns
  return(mytable)  
}

Fmytable.iqr(L,BT=5000,seed=123,na.rm=TRUE)

