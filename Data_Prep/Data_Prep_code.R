#LIBRARIES:
library(ggplot2)

# ---- Basic Import:----
fin<-read.csv('P3-Future-500-The-Dataset.csv')
fin_1 <- read.csv('P3-Future-500-The-Dataset.csv', stringsAsFactors = F)
head(fin)
str(fin_1)





# ---- Allowing R to treat some specific values to NA while import or in subsetting:-----
# Replacing BLanks with NAs.
fin_blank_Adjusted<-read.csv('P3-Future-500-The-Dataset.csv', na.strings = c(""))
fin<- fin_blank_Adjusted


# ---- [sub()1st occurence , gsub() all occurence] Pattern matching and replacement:-----
a<- 'asassdsdfgfg'

b<- sub('as', 'bb', a)
b<-gsub('as', 'bb', a)

fin$Expenses<- gsub(" Dollars", "", fin$Expenses)
fin$Expenses<- gsub(",", "", fin$Expenses)
#addressing dollar sign inside a string, since its a special character in R. "ESCAPE SEQ- \\"
fin$Revenue<- gsub("\\$", "", fin$Revenue)
fin$Revenue<- gsub(",", "", fin$Revenue)
fin$Growth<- gsub("%", "", fin$Growth)

#now converting to numeric:
fin$Expenses<- as.numeric( fin$Expenses)
fin$Revenue<- as.numeric( fin$Revenue)
fin$Growth<- as.numeric(fin$Growth)
head(fin)
str(fin)


#***** Missing Data *****:----
# 1. Predict with 100% accuracy.
# 2. Leave record as is.
# 3. Remove record entirely.
# 4. Replace with mean and median.
# 5. Fill in by exploring correlation and similarities.
# 6. Introduce dummy variable for "missingness".


# ---- Locate Missing Values:----
sum(is.na(fin))
#identify rows that have NAs in them:(Picks only NA values not Empty or Blanks.)[TRUE?/FALSE]
complete.cases(fin)
#viewing rows with NAs in them.(slecting FALSES)
rows_with_NA <- fin[!complete.cases(fin),]


# ---- NA distribution plot:----
missing_values <- fin %>%
summarise_all(funs(sum(is.na(.))/n()))

missing_values <- gather(missing_values,key='feature',value = 'missing_percentage')

missing_values %>%
ggplot(aes(x=reorder(feature,-missing_percentage),y=missing_percentage)) +
geom_bar(stat = 'identity',fill='red') +
coord_flip()



# ---- Filtering:----
# 1. WHICH(): (IGNORES NA VALUES ONLY PICKS TRUE VALUES) using which() for Non-Missing Data
# filter by row number:
 fin[c(1,2,3),]
# filtering by which:
 fin[fin$Revenue==9746272,] #(with NA)
 fin[which(fin$Revenue==9746272),] #(without NA)
 
 fin[fin$Employees==45,] #(with NA)
 fin[which(fin$Employees==45),] #(without NA)
 
 #fin_bckup<-fin

# 2. is.na():
 is.na(fin$Expenses)
 fin[is.na(fin$Expenses),]
 fin[is.na(fin$State),]
 
 fin[!complete.cases(fin),]
 fin[is.na(fin$Industry),] 
 fin[!is.na(fin$Industry),] #opposite
 
 # 3. Filtering by removing Rows:
 fin_2<-fin[!is.na(fin$Industry),] #opposite
 
 #fin<-fin_2
 
 # 4. Reseting DataFrameIndex:
 fin_2
 # **** Assigning Rownumber for Easy Access: ****
 rownames(fin) <- 1:nrow(fin)
 
 
 
# ---- Replacing missing Data(Median Imputation Method) :----
 
 #(Factual Analysis):
 fin[is.na(fin$State),]
 fin[is.na(fin$State) & fin$City == "New York",]
 fin[is.na(fin$State) & fin$City == "New York","State"]<- "NY"
 
 fin[is.na(fin$State) & fin$City == "San Francisco",]
 fin[is.na(fin$State) & fin$City == "San Francisco","State"]<-"CA"
# check: 
 fin[c(11,377),]
 fin[c(82,265),]
 
 fin[!complete.cases(fin),]
 
 #Median Imputation Method:
 median(fin[,"Employees"], na.rm=TRUE) 
 mean(fin[,"Employees"], na.rm=TRUE) 
 
 #Calculate Median & Impute:
 med_empl_retail <- median(fin[fin$Industry=="Retail","Employees"], na.rm=TRUE) 
 fin[is.na(fin$Employees) & fin$Industry == "Retail","Employees"] <- med_empl_retail
 
 med_empl_fin_services <- median(fin[fin$Industry=="Financial Services","Employees"], na.rm=TRUE) 
 fin[is.na(fin$Employees) & fin$Industry == "Financial Services","Employees"] <- med_empl_fin_services
 
 med_growth_construction <- median(fin[fin$Industry=="Construction","Growth"], na.rm=TRUE) 
 fin[is.na(fin$Growth) & fin$Industry == "Construction","Growth"] <- med_growth_construction
 
 fin[!complete.cases(fin),]
 
 #Revenue:
med_rev_construction <- median(fin[fin$Industry=="Construction","Revenue"], na.rm=TRUE)
med_rev_construction
fin[is.na(fin$Revenue) & fin$Industry == "Construction","Revenue"] <- med_rev_construction

#Expenses:
med_exp_construction <- median(fin[fin$Industry=="Construction","Expenses"], na.rm=TRUE)
med_exp_construction
fin[is.na(fin$Expenses) & fin$Industry == "Construction",]
fin[is.na(fin$Expenses) & fin$Industry == "Construction","Expenses"] <- med_exp_construction

#or
fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit),]
fin[is.na(fin$Expenses) & fin$Industry == "Construction" & is.na(fin$Profit), "Expenses"] <- med_exp_construction

#Profits:
#revenue -expenses = profit
#expenses = revenue - profit

fin[is.na(fin$Profit), "Profit"] <- fin[is.na(fin$Profit), "Revenue"] - fin[is.na(fin$Profit), "Expenses"]
fin[c(8,42),]

fin[is.na(fin$Expenses),]
fin[is.na(fin$Expenses), "Expenses"] <- fin[is.na(fin$Expenses), "Revenue"] - fin[is.na(fin$Expenses), "Profit"]

fin[!complete.cases(fin),] # only one NA which not involved in analysis.




# ---- Visualizing Results:----

p <- ggplot(data = fin)
p
# A scatter plot classified by industry showing revenue, expense and profits
p + geom_point(aes(x=Revenue,y= Expenses,
                   color = Industry, size=Profit)) 

# A scatter plot that includes industry trends for the Expense-Revenue relationship. 
d <- ggplot(data=fin ,aes(x=Revenue, y=Expenses, color=Industry))
d + geom_point() + geom_smooth(fill=NA, size=1.2)

# Boxplot showing growth by industry.
f<- ggplot(data = fin, aes(x= Industry, y= Growth, color=Industry))
f + geom_boxplot()
# Extra:
f + geom_jitter() + geom_boxplot(size= 1, alpha= 0.5, outlier.color = NA)

 




