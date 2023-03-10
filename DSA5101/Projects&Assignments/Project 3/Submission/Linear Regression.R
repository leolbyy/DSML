# author: Yusen Cai

# Here we use 3 models to predict the sales price. They are:
# model1. (benchmark) plain linear regression
# model2. remove highly correlated variables and linear regression
# model3. Lasso

#===============Load Package and Data===============
# load packages
library(ggplot2)
library(tidyr)
library(GGally)
library(corrplot)
library(leaps)
library(glmnet)
library(caret)
# Set Path
setwd('/Users/cathycai/Documents/NUS/DSA5101 Assignment/project4')
# Read data
data = read.csv('project_residential_price_data.csv')
# transform data factor type
data$V.1 = as.factor(data$V.1)
data$V.10 = as.factor(data$V.10)
data$V.20 = as.factor(data$V.20)

# remove V.8, since it's of the same meaning of V.9
#data = data[,-8]

# resort the column, so the V.9 is the last column of the data
data = cbind(data[,-(ncol(data)-1)],V.9 = data[,(ncol(data)-1)])

#=====================Linear Regression=====================
# set random seed for reproduction
set.seed(5101)
# split train and test according to 7:3
train = sample(nrow(data),size = 0.7*nrow(data))

x = data[,-ncol(data)]
y = data[,ncol(data)]


#===================1. benchmark:all in ====================
# fit linear model on train set
fit1 = lm(V.9~.,data[train,])
summary(fit1)

# calculate MSE:
MSE = function(true,predict){
  return (mean((true-predict)^2))
}


test_pred = predict(fit1,newdata = data[-train,])
train_mse = MSE(data[train,"V.9"],fit1$fitted.values);train_mse
test_mse = MSE(data[-train,"V.9"],test_pred);test_mse

#===================2.remove highly correlated ============
# first, convert factor type to numerical type
a = data[train,-ncol(data)]
a = apply(a,2,function(x) as.numeric(as.character(x)))

# remove variables of correlation above 0.85 (keep one)
highlyCorDescr <- findCorrelation(cor(a), cutoff = .85)
xnew <- x[,-highlyCorDescr]
newdata = cbind(xnew,V.9=y)

# fit the remaining variable 
fit2=lm(V.9~.,newdata[train,])
summary(fit2)

test_pred = predict(fit2,newdata =newdata[-train,])
train_mse = MSE(newdata[train,"V.9"],fit2$fitted.values)
test_mse = MSE(y[-train],test_pred)
train_rmse = sqrt(train_mse);train_rmse
test_rmse = sqrt(test_mse);test_rmse
train_nrmse = train_rmse/(max(newdata[train,'V.9'])-min(newdata[train,'V.9']));train_nrmse
test_nrmse = test_rmse/(max(newdata[-train,'V.9'])-min(newdata[-train,'V.9']));test_nrmse
# check is there difference between two model
anova(fit1,fit2)
# ====================Conclusion======================
# Here the anova test is significant, 
# which means that the variables we removed in model2 
# actually have contribution to the prediction.

#===================3.Lasso===========================
#================3.1 prepare before lasso=============
#===============a.turn features into matrix===========
# deal with three categorical variables
# we need to turn them into dummy variables matrix and remove the intercept(later will appear)
xfactor = model.matrix(~ V.1+V.10+V.20,data)[,-1]
# turn the numerical factor into matrix as input of lasso
xnumerical = as.matrix(x[-c(1,18,28)])

#===============b.normalization=======================
# before Lasso, we need to normalization
# However,to avoid data leakage, we need to fit transformer on train set;
# then fit on test set.
preProcValues <- preProcess(xnumerical[train,], method = c("center", "scale"))
trainTransformed <- predict(preProcValues, xnumerical[train,])
testTransformed <- predict(preProcValues, xnumerical[-train,])

#================c. split the train and test set========
x_train = cbind(trainTransformed,xfactor[train,])
x_test = cbind(testTransformed,xfactor[-train,])
y=as.matrix(y)
y_train = y[train,]
y_test = y[-train,]

#=====================3.2 lasso==================
# first, grid search:
grid = 10^seq(10,-2,length=100)
lasso.mod = glmnet(x_train,y_train,alpha=1,lambda =grid)
plot(lasso.mod)

# cross validation to get best hyperparameter lambda
cv.out = cv.glmnet(x_train,y_train,alpha = 1,folds=5)
plot(cv.out)
bestlam = cv.out$lambda.min

# check whether there are variables pushed to 0 by lasso
lasso.coef = predict(lasso.mod,type="coefficients",s=bestlam)
lasso.coef#V.29,V.22,V.21,V.16,V.13
lasso.coef[lasso.coef==0]

# Here in this dataset, no variable is pushed to 0 by lasso.

# check the MSE on both train and test set
train_pred =predict(lasso.mod,s=bestlam,newx=x_train)
test_pred =predict(lasso.mod,s=bestlam,newx=x_test)
train_mse = MSE(y_train,train_pred);train_mse
test_mse = MSE(y_test,test_pred);test_mse

#fit3=lm(V.9~.-V.29-V.22-V.21-V.16-V.13,data[train,])
#summary(fit3)
#anova(fit1,fit3)

