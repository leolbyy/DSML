setwd("C:/Users/jingzhao/Documents/R_L1") # working directory

lm_data = read.csv("house_price.csv")


set.seed(13)  #seed to generate random number

train = sample(nrow(lm_data), 0.7*nrow(lm_data))  # sample() is takes a sample of the specified size from the elements
test = setdiff(seq_len(nrow(lm_data)), train) 


lm_data_training<-lm_data[train,]  #training data set
lm_data_testing<-lm_data[test,]    #testing

###Full model##

lm1<-lm(House_Price~., data = lm_data_training) #regression model using all the variables
summary(lm1)
estimate<-predict(lm1,type='response',newdata=lm_data_testing) # prediction
observed = lm_data_testing$House_Price #observed outcome
format(cor(estimate,observed)^2,digits=4) #R2


##Model with selected variables/Feature selection##
lm2<-lm(House_Price~.,data =lm_data_training[,c(3,4,6,7,8,9)])  # Remove the highly correlated variables: Dist_Hospital, Carpet, Rainfall and all categorical variables
summary(lm2)
estimate<-predict(lm2,type='response',newdata=lm_data_testing)
observed = lm_data_testing$House_Price
format(cor(estimate,observed)^2,digits=4)

##Model with Top PrincipalComponents/Feature Extractio##
pca<-prcomp(lm_data[train,c(1:5,8)],center=T,scale=T) #PCA
pred <- predict(pca, newdata=lm_data[test,c(1:5,8)])  #PC prediction for testing data

library(factoextra)
res.ind <- get_pca_ind(pca)
res.ind$coord          # Coordinates

lm_data_training_new<-res.ind$coord[,1:3] #The first 3 PCs, Reduce the dimension from 6 to 3, covering 87% of variances
lm_data_training_new<-cbind(lm_data_training_new,lm_data[train,c(6,7,9)]) #Add categorical variables, and House_Price
colnames(lm_data_training_new)<-c("PC1","PC2","PC3","Parking","City_Category","House_Price") #give the column name

lm_data_testing_new<-pred[,1:3]  #Choose top 3 PCs of testing data
lm_data_testing_new<-cbind(lm_data_testing_new,lm_data[test,c(6,7,9)])
colnames(lm_data_training_new)<-c("PC1","PC2","PC3","Parking","City_Category","House_Price") 

lm_data_new<-rbind(lm_data_training_new,lm_data_testing_new) #new dataset with Top 3 Principalcomponents

lm3<-lm(House_Price~., data = lm_data_training_new) #regression model using top PC3+categorical
summary(lm3)
estimate<-predict(lm3,type='response',newdata=lm_data_testing_new)
observed = lm_data_testing_new$House_Price
format(cor(estimate,observed)^2,digits=4)


##Model selection using package caret##

#install.packages("caret")
library(caret)
set.seed(14)

train.control <- trainControl(method = "cv", number = 10)  #define the method, 10-fold cross-validation

##Full model##
model <- train(House_Price ~., data = lm_data, method = "lm",
               trControl = train.control)  #Training and test model
print(model)

##With selected variables ONLY
model2<- train(House_Price ~., data = lm_data[,c(3,4,6,7,8,9)], method = "lm",
               trControl = train.control)
print(model2)

##With top 3 principal components
model3<- train(House_Price ~., data = lm_data_new, method = "lm",
               trControl = train.control)
print(model3)

##Final Prediction model

lm_final<-lm(House_Price~., data = lm_data_new)
summary(lm_final)


