
#[1] "/Users/vivek/Desktop/Rprac/R_advanced/Apply_Family"

# Read Data & Prep:

Chicago<- read.csv('Chicago-F.csv', row.names = 1)
Houston<- read.csv('Houston-F.csv', row.names = 1)
NewYork<- read.csv('NewYork-F.csv', row.names = 1)
SanFrancisco<- read.csv('SanFrancisco-F.csv', row.names = 1)

#Since all columns are Numeric better convert it to a matrix.

Chicago<- as.matrix(Chicago)
Houston<- as.matrix(Houston)
NewYork<- as.matrix(NewYork)
SanFrancisco<- as.matrix(SanFrancisco)

#Let put all these to a list:
Weather <- list(Chicago=Chicago, Houston=Houston,NewYork= NewYork, SanFrancisco=SanFrancisco)

#Apply Family:
# apply: used on a matrix either row/col wise.
# tapply: used on a vector to extract sub-groups and apply a function to them
# by:used in data frames same funtion as group by in sql.
# eapply: use on environment.
# lapply: apply a function to elements of a list.(L)
# sapply: a version of lapply.Can simplify (S) the results so its not represented as a list. 
# vapply: has a pre specified type of return value.(V)
# replicate: run a function multiple times. Usually used with generation of random variables.
# mapply: multivariate (M) version of Sapply.Arguments can be recycled.
# rapply: recursive (R) version of lapply.

apply(Chicago, 1,mean)

apply(Chicago, 1, max)
apply(Chicago, 1, min)

#Compare
apply(Chicago, 1,mean)
apply(NewYork, 1,mean)
apply(Houston, 1,mean)
apply(SanFrancisco, 1,mean)
                            #<<<<< (nearly) deliverable 1 but there is a faster way: -->

# Recreate apply function with Loops:
# find mean of every row:
# 1. via Loops
output<- NULL
for (i in 1:5) {
  output[i]<- mean(Chicago[i,])
}
output

names(output)<- row.names(Chicago)

# 2. via apply():
apply(Chicago,1,mean)


#lapply():
?lapply

#transpose
t(Chicago)
# lapply applies a function to each element of a list or vector
lapply(Weather, t)

mynewlist<- lapply(Weather, t)

#example 2 :
rbind(Chicago, Newrow=1:12)
lapply(Weather, rbind, Newrow=1:12)

?rowMeans
rowMeans(Chicago) # identical to apply(Chicago, 1, mean)

lapply(Weather, rowMeans)

#colMeans
#colSums
#rowSums

#combining lapply with []:

Weather
Weather$Chicago[1,1]
Weather[[1]][1,1]

lapply(Weather, "[",1,1) #first element of all elements of the list. lapply by default takes Weather[[i]]

lapply(Weather, "[", 1, ) #first row

lapply(Weather, "[", ,3) #only march

#own function:
#lapply(list, function)
lapply(Weather, function(x) x[1,])
lapply(Weather, function(x) x[5,])
lapply(Weather, function(x) x[,12])

#Deliverable 2 temp fluctuation. will better ahead
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))

#Using Sapply: simpler version of lapply
?sapply

lapply(Weather, "[", 1,7)
sapply(Weather, "[", 1,7)

lapply(Weather, "[", 1, 10:12) 
sapply(Weather, "[", 1, 10:12) #beautiful matrix

#Deliverable1:
lapply(Weather, rowMeans)
round(sapply(Weather, rowMeans),2)

#Deliverable2:
lapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))
sapply(Weather, function(z) round((z[1,]-z[2,])/z[2,],2))

# Nesting apply functions:
lapply(Weather, apply, 1, max)
sapply(Weather, apply, 1, max) #Deliverable3
sapply(Weather, apply, 1, min) #Deliverable4


#Advanced which.max(), which.min():
which.max(Chicago[1,])
names(which.max(Chicago[1,]))

apply(Chicago, 1, function(x) names(which.max(x)))
lapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))
sapply(Weather, function(y) apply(y, 1, function(x) names(which.max(x))))

lapply(Weather, function(y) apply(y, 1, function(x) names(which.min(x))))
sapply(Weather, function(y) apply(y, 1, function(x) names(which.min(x))))
