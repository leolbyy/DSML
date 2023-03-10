setwd("C:/Users/jingzhao/Documents/R_L1") # working directory

lm_data = read.csv("house_price.csv")


lm1<-lm(House_Price~., data = lm_data) #regression model using all the variables
summary(lm1)


lm2<-lm(House_Price~Dist_Market, data = lm_data)
summary(lm2)

lm3<-lm(House_Price~Dist_Taxi, data = lm_data)
summary(lm3)

lm4<-lm(House_Price~Dist_Hospital, data = lm_data)
summary(lm4)


lm5<-lm(House_Price~Carpet, data = lm_data)
summary(lm5)

lm6<-lm(House_Price~.,data=lm_data[,c(3,4,6,7,8,9)])


library(ggplot2)
library(GGally)  #extension of ggplot2, including pairwise scatterplot matrix 

ggpairs(lm_data, columns=1:5)
ggpairs(lm_data, columns = 1:5, aes(color = City_Category))
cor(lm_data[,1:5])
ggcorr(lm_data[,1:5], method = c("everything", "pearson")) 

lm7<-lm(House_Price~.,data = lm_data[,-4])  #remove one variable: Carpet

library(car)  ##library for calculting VIF
vif(lm1)  ##test collinearity

anova(lm1,lm7)  #Model comparison

lm8<-lm(House_Price~.,data = lm_data[,-c(3,4)])
