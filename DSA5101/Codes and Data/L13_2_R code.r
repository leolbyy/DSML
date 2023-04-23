setwd("C:/Users/jingzhao/Documents/R_L1") # working directory

lm_data = read.csv("house_price.csv")

###Set up traing and testing data sets

set.seed(13)  #seed to generate random number

train = sample(nrow(lm_data), 0.7*nrow(lm_data))  # sample() is takes a sample of the specified size from the elements
test = setdiff(seq_len(nrow(lm_data)), train)     # the rest as test

##PCA calcualtion using prcomp

pca<-prcomp(lm_data[train,c(1:5,8)],center=T,scale=T) #data standardization
 
summary(pca)    

#install.packages("factoextra")  # Extract and Visualize the Results of Multivariate Data Analyses including PCA

library(factoextra)

# Eigenvalues extraction
eig.val <- get_eigenvalue(pca)
eig.val


# Scree Plot
fviz_eig(pca,addlabels = TRUE, ylim = c(0, 50))  


#Graph of individuals


fviz_pca_ind(pca,
             axes = c(1,2),   #a numeric vector of length 2 specifying the dimensions to be plotted.
             geom = "point",  # plot type
             col.ind = "cos2", # Color by the quality of representation
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
             )

#Graph of variables


fviz_pca_var(pca,
             col.var = "contrib", # Color by contributions to the PC
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE     # Avoid text overlapping
             )

# visualize the contribution
fviz_contrib(pca, choice = "var", axes = 1, top = 10) # contribution to PC1
fviz_contrib(pca, choice = "var", axes = 1:2, top = 10)



 
# Results for Variables
res.var <- get_pca_var(pca)
res.var$coord          # Coordinates
res.var$contrib        # Contributions to the PCs
res.var$cos2           # Quality of representation 

# Results for individuals
res.ind <- get_pca_ind(pca)
res.ind$coord          # Coordinates
res.ind$contrib        # Contributions to the PCs
res.ind$cos2           # Quality of representation 


##### prediction of PCs for new datasets
pred <- predict(pca, newdata=lm_data[test,c(1:5,8)]) #prediction of testing data sets

p <- fviz_pca_ind(pca, geom = "point", repel = T) #graph of individual of traing test
fviz_add(p, pred, color ="blue") #Add new data points


##New data sets for linear regression model
lm_data_training_new<-res.ind$coord[,1:3] #The first 3 PCs, Reduce the dimension from 6 to 3, covering 87% of variances
lm_data_testing_new<-pred[,1:3]

