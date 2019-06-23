#Project:(Machine Utilization Coal mining) -Lists

#---- OUTPUT:----
#Deliverable - a list with following components:
#Character : Machine Name
#Vector    : (min, mean ,max) utilization for the month (excluding unknown hours).
#Logical   : has utilization ever fallen below 90%? T/F
#Vector    : All hours where utilization is unkown (NA's).
#Dataframe : for this machine.
#Plot      : For all machines.s

library(ggplot2)

util <- read.csv("P3-Machine-Utilization.csv")
head(util, 12)
str(util)
summary(util)


#Deriving  Utilization:

util$Utilization <- 1- util$Percent.Idle
head(util, 15)

#Handling Datetime in R:
tail(util)
?POSIXct
util$PosixTime <- as.POSIXct(util$Timestamp, format= "%d/%m/%Y %H:%M")

#Rearrange columns:
util<- util[,c(4,1,2,3)]
util$Timestamp<- NULL 

# What is a List?
RL1<- util[util$Machine=="RL1",]
summary(RL1)

RL1$Machine <- factor(RL1$Machine)
summary(RL1)
#Character : Machine Name
#Vector    : (min, mean ,max) utilization for the month (excluding unknown hours).
#Logical   : has utilization ever fallen below 90%? T/F
#Vector    : All hours where utilization is unkown (NA's).

util_stat_rl1 <- c(min(RL1$Utilization, na.rm = T),
                   mean(RL1$Utilization, na.rm = T),
                   max(RL1$Utilization, na.rm = T))

util_stat_rl1

util_under_90<- length(which(RL1$Utilization < 0.90))
util_under_90_flag <- length(which(RL1$Utilization < 0.90)) > 0

#LISTS:
list_rl1 <- list(Machine='RL1', Stats=util_stat_rl1, LowThreshold=util_under_90_flag)

#naming components of a list:
names(list_rl1)
names(list_rl1) <- c("Machine", "Stats", "LowThreshold")
#rm(list_rl1)

#EXTRACT COMPONENTS OF LIST:
#three ways:
#[] = always retuns a list.
#[[]] = will always return actual object.
#$ = same as [[]] but prettier.

#1.
list_rl1[1]
#2.
list_rl1[[1]]
#3.
list_rl1$Machine

list_rl1[2]
typeof(list_rl1[2])[1]
list_rl1[[2]][1]
typeof(list_rl1[[2]])
typeof(list_rl1$Stats)
list_rl1[[2]][3]
list_rl1$Stats[3]

# Adding eemnt to list:
# adding hours where utilization is unknown
list_rl1$UnknownHours <- RL1[is.na(RL1$Utilization), "PosixTime"]

#Removing:
#list_rl1[4] <- NULL this will auto adjust indexing of list elements.

#adding DataFrame:
list_rl1$Data  <- RL1

summary(list_rl1)

#subsetting a list: Double sq-brackets are not for subsetting, they're for accessing elements in a list.
list_rl1[1:2]
list_rl1[c(1,4)]
list_rl1[c("Machine","Stats")]

sublist_rl1<- list_rl1[c("Machine","Stats")]

p<- ggplot(data = util)

myplot<- p + geom_line(aes(x=PosixTime, y=Utilization,                        # Adding threshold line at 0.90:
                  color=Machine), size= 1.2) + facet_grid(Machine~.) + geom_hline(yintercept = 0.90, color='Gray', size= 1.2, linetype=3)

list_rl1$Plot <- myplot
summary(list_rl1)
str(list_rl1)
  
