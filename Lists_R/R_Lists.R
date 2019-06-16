#Project:(Machine Utilization Coal mining) -Lists

#---- OUTPUT:----
#Deliverable - a list with following components:
#Character : Machine Name
#Vector    : (min, mena,max) utilization for the month (excluding unknown hours).
#Logical   : has utilization ever fallen below 90%? T/F
#Vector    : All hours where utilization is unkown (NA's).
#Dataframe : for this machine.
#Plot      : For all machines.

util <- read.csv("P3-Machine-Utilization.csv")
head(util, 12)
str(util)
summary(util)
