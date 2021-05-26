install.packages("surveysd")
library(surveysd)
machi <- c(1:25)
residentnumber<-c(8,12,4,5,6,6,7,5,8,3,2,6,5,10,9,3,6,5,5,4,6,8,7,3,8)
total <- c(96,121,42,65,52,40,75,65,45,50,85,43,54,49,53,50,32,22,45,37,51,
           30,39,47,41)

residents <- c(25,mean(residentnumber),median(residentnumber),sd(residentnumber))
income <- c(25,mean(total),median(total),sd(total))
Object1 <-c(25,0,993,25189)


result=paste(residents,income,Object1,collapse=",")

standard_error <- function(x) sd(x) / sqrt(length(x)) # Create own function

standard_error(residents)

standard_error(Object1)
