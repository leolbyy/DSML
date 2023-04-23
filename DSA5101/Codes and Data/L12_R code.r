#############Titanic data###########
setwd("C:/Users/jingzhao/Documents/R_L1") 
titanic<-read.csv("titanic.csv")

titanic[1:5,]  # check some records to understand data

summary(titanic) # do some descriptive analysis to understand distribution of each column


library(ggplot2)

#Bar chart of Survived status#
ggplot(titanic)+
aes(x=as.factor(Survived))+
geom_bar()

titanic$Pclass<-as.factor(titanic$Pclass)

#Bar chart of Survived status with sub-groups by Pclass, you will see the insights#
ggplot(titanic)+
aes(x=as.factor(Pclass),fill=factor(Survived))+
geom_bar()


##Contingency Table
ct<-table(x=titanic$Survived, y=titanic$Pclass) #x: dependent var; y: independent var

##Proprotional Contingency Table 
prop_ct0<-prop.table(ct)          # by default, overall proportion
prop_ct1<-prop.table(ct,margin=1) # margin =1, proportion by row
prop_ct2<-prop.table(ct,margin=2) # margin =2, proportion by col

##Chi-square test in R
chisqt<-chisq.test(x=titanic$Survived, y=titanic$Pclass)


#############Sales data########
sales_jul<-read.csv("sales_jul.csv") 




##boxplot of sales by promotion factor comparison ###
sales_jul$prom<-as.factor(sales_jul$prom) # convert the variable as a factor

ggplot(sales_jul)+aes(x=sales_unit,fill=prom)+
  geom_boxplot()+
  labs(x="sales unit",
       title = "SKU sales boxplot by promotion")


###T-test of promotion effectiveness##
t.test(sales_unit~prom,data=sales_jul) #Two sided 
t.test(sales_unit~prom,alternative = "less", data=sales_jul) #one-sided, prom is better than non-prom
t.test(sales_unit~prom,alternative = "greater", data=sales_jul) #one-sided, non-prom is better than prom :)

 

###Boxplot of sales by seller_score comparison ###
sales_jul$seller_score<-as.factor(sales_jul$seller_score) # convert to factor

##boxplot using ggplot
ggplot(sales_jul)+aes(x=sales_unit,fill=seller_score)+
  geom_boxplot()+
  labs(x="sales unit",
       title = "SKU sales boxplot by seller_score")

##ANOVA to test if seller_score (more than 2 levels) have impact on sales volume ##

aov_seller_score<-aov(sales_unit~seller_score,data=sales_jul)

summary(aov_seller_score)

TukeyHSD(aov_seller_score)

