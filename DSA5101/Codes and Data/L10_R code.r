

######R practice L7#######


#2.1-Numerical & Categorical data
x=1
x<-1  #numerical
mean(c(1,2,3))   #the center

x<-as.character(3) 
varname="number of sibling"

#2.2-vector & construction & selection

c("F","F","M") #vector

rep(1,5) #repeat function
rep(1:2,5)
c(rep(1,5),rep(1:2,5)) #combine vectors
rep("Sunny Day",5)

seq(1,10) #generate sequence
seq(1,10,by=2) #generate sequence with step = 2
seq(1,10,length=3) #generate sequence with length = 3

gender<-c("F","F","M") #give values to a variale
length(gender)
gender[1]   #select parts of vector
gender[1:2]
gender[gender=="F"] #select using logic

##2.3-Matrix & construction
A<-matrix(
c(2,4,3,1,5,7),
nrow=2,
ncol=3)

A[2,1] # row2*col1
A[,1]  #col 1
A[2,]  #row 2

B<-matrix(
c(1,2,3),
nrow=1,
ncol=3)

C<-rbind(A,B)
D<-cbind(A,B) #cannot combine if # of columns are different

B2<-matrix(
c(1,1),
nrow=2,
ncol=1)

D<-cbind(A,B2)

##2.4-Data Frame

num_sibling<-c(1,2,3)
math_student<-c(TRUE, FALSE, TRUE)
gender<-c("F","F","M")
data_survey<-data.frame(num_sibling, math_student,gender)
row.names(data_survey)<-c("Anna","Lucy","Joshua") #row names

data_survey[,1:2] #select the first 2 cloumns
data_survey$num_sibling #select column using col names

data_survey[1:2,] #select the first 2 rows

data_survey[gender=="F",] # select observation by logic
data_survey[gender=="F"&num_sibling>=2,] # select observation by logic



##2.5-descriptive statistics
getwd()

setwd("C:/Users/jingzhao/Documents/R_L7")  #set your working directory

sales_jul<-read.csv("sales_jul.csv")  #Import Data, or use read.table for text file
sales_jul[1:10,]                      #view sample data





####Descriptive Statistics Method 1####
summary(sales_jul)
dim(sales_jul)  #dimension (# of observation, # of variables)
summary(sales_jul$price)
by(sales_jul, sales_jul$SKU_cat, summary)  #descriptive statistics by category
mean(sales_jul$sales_unit)

##2.6-visualization using ggplot2


#install.packages("ggplot2") #Install package
library(ggplot2)     #call package

#Set factors
sales_jul$prom<-as.factor(sales_jul$prom)  #categorical variable
sales_jul$own_brand<-as.factor(sales_jul$own_brand)
sales_jul$seller_score<-as.factor(sales_jul$seller_score)

###Histogram of SKU sold###

##The first insight we want to have is "what's the sales volume?"
##Since sales volume is a numerical variable, histogram is a good visualization to understand distribution.


qplot(sales_unit, data=sales_jul, geom="histogram", binwidth = 5)




##The second insight we want to have is "sales volume affected by Promotion or not?"
##In ggplot, we can use COLOR to compare two subgroup (with prom vs. wo prom)


qplot(sales_unit, data=sales_jul, geom="histogram", binwidth = 6,
  fill = prom,                         #color code by promotion variable (fill/color)
  main = "Histogram of SKU sales",
  xlab="# of units sold",
  ylab="Freq")

##Using ggplot
ggplot(sales_jul)
ggplot(sales_jul)+aes(x=sales_unit) #Add Aesthetic
ggplot(sales_jul)+aes(x=sales_unit)+
  geom_histogram(binwidth=6)        #Add plot with specific type
ggplot(sales_jul)+aes(x=sales_unit,fill=prom)+
  geom_histogram(binwidth=6) 

ggplot(sales_jul)+aes(x=sales_unit,fill=prom)+
  geom_histogram(binwidth=6)+
  labs(x="# of units sold", y="Frequency", title = "Histogram of SKU sales volume")



##The third insight we want to have is "sales volume affected by seller score?"
##In ggplot, we can use COLOR to compare three subgroup 

ggplot(sales_jul)+aes(x=sales_unit,fill=seller_score)+
  geom_histogram(binwidth=6)+
  labs(x="# of units sold", y="Frequency", title = "Histogram of SKU sales volume")



##Multi-panel plots  

ggplot(sales_jul)+
  aes(x=sales_unit,fill=prom)+
  geom_histogram(binwidth=6)+ 
  facet_wrap(.~prom)   #facet_wrap(,~var1+...)  

ggplot(sales_jul)+
  aes(x=sales_unit,fill=prom)+
  geom_histogram(binwidth=6)+ 
  facet_wrap(.~SKU_cat)   #facet_wrap(,~var1+...)  

ggplot(sales_jul)+
  aes(x=sales_unit,fill=prom)+
  geom_histogram(binwidth=6)+ 
  facet_wrap(.~SKU_cat+prom)   #facet_wrap(,~var1+...)  

ggplot(sales_jul)+
  aes(x=sales_unit,fill=prom)+
  geom_histogram(binwidth=6)+ 
  facet_grid(SKU_cat~prom)   #facet_grid(row_var~col_var)  


ggplot(sales_jul)+
  aes(x=sales_unit,fill=seller_score)+
  geom_histogram(binwidth=6)+ 
  facet_wrap(.~seller_score)  #facet_wrap(~ variable) 


ggplot(sales_jul)+aes(x=sales_unit,fill=seller_score)+geom_histogram(binwidth=6)+ 
  facet_grid(prom~seller_score)    # facet_grid(row_variable~col_variable)




##density plot using ggplot
ggplot(sales_jul)+aes(x=sales_unit,color=seller_score)+
  geom_density()+
  labs(y="# of units sold",
       x="Promotion or not",
       title = "SKU sales by category")+
  facet_grid(.~prom)



###Boxplot of SKU sales by category (vector)###


qplot(x=SKU_cat,y=sales_unit,data=sales_jul, 
   color = SKU_cat,
   geom = "boxplot",
   xlab="SKU category",
   ylab="Sales Unit",
   main="Boxplot of Sales Unit by category")

ggplot(sales_jul)+
  aes(x=prom,y=sales_unit)+
  geom_boxplot()

ggplot(sales_jul)+
  aes(x=prom,y=price)+
  geom_boxplot()

ggplot(sales_jul)+
  aes(x=prom,y=price,color = prom)+
  geom_boxplot()+
  facet_grid(.~SKU_cat)


ggplot(sales_jul)+
  aes(x=prom,y=sales_unit,color=SKU_cat)+
  geom_boxplot()+
  facet_wrap(.~SKU_cat)

boxplot_sales_prom_cat<-      #assign a plot name
  ggplot(sales_jul)+
  aes(x=prom,y=sales_unit,color=SKU_cat)+
  geom_boxplot()+
  facet_wrap(.~SKU_cat)
ggsave("boxplot_sales_prom_bycat.jpg",boxplot_sales_prom_cat)   #save plot in your current working directory

##Bar chat by ggplot
ggplot(sales_jul)+aes(x=seller_score, fill=factor(seller_score))+
  geom_bar()+
  facet_wrap(.~SKU_cat)



##Mix multiple plots
#install.packages("gridExtra")
library(gridExtra)

plot1<-ggplot(sales_jul)+aes(x=sales_unit,color=factor(SKU_cat))+
  geom_density()+
  labs(y="# of units sold",
       x="SKU category",
       title = "SKU sales by category")
plot2<-ggplot(sales_jul)+aes(x=sales_unit)+
  geom_histogram(binwidth=3) 
plot3<-ggplot(sales_jul)+aes(x=seller_score, fill=factor(seller_score))+
  geom_bar()

grid.arrange(plot1,plot2,plot3,ncol=2,nrow=2)  # Grid with 2 rows and 2 columns

grid.arrange(arrangeGrob(plot1,ncol=1),        # First row with one plot spaning over 2 columns
             arrangeGrob(plot2, plot3,ncol=2), # Second row with 2 plots in 2 different columns
             nrow = 2)                         # Grob is a graphical plot

mix_graph<-grid.arrange(arrangeGrob(plot1,plot2,ncol=2),        # First row with one plot spaning over 2 columns
             arrangeGrob(plot2,plot3,ncol=2), # Second row with 2 plots in 2 different columns
             nrow = 2)     
ggsave("mix_graph.jpg",mix_graph)

#Create new features: As data scientist, one important work is to derive new & meaningful features based on
#your business understanding. 

#Think about "SALES", besides # of sales volume, what else is important? Yes, revenue
#Let's create a sales dollar value using price & sales unit

total_sales_sku<-sales_jul$price*sales_jul$sales_unit  #total sales amount of each SKU
sales_jul<-cbind(sales_jul,total_sales_sku)            #merge into data frame

##See if we have additional insights?

plot1<-ggplot(sales_jul)+
  aes(y=total_sales_sku,x=SKU_cat,fill=prom)+
  geom_boxplot()

plot2<-ggplot(sales_jul)+
  aes(y=sales_unit,x=SKU_cat,fill=prom)+
  geom_boxplot()

grid.arrange(plot1,plot2,ncol=1)

#from this plot, what recommendation we could provide to marketing team?




###Export data
write.csv(sales_jul,"sales_jul.csv",row.names=F)  


###############FIFA Practice########

fifa<-read.csv("FIFA17_data.csv")
boxplot_cat_seller<-ggplot(fifa)+aes(x=as.character(International.Reputation),y=Score,color=factor(Preferred.Foot))+geom_boxplot()
boxplot_cat_seller<-boxplot_cat_seller+ggtitle("Boxplot of SKU sales")+ylab("# of units sold") + xlab("SKU category")+ labs(color="seller score")
ggsave("boxplot_sales_bycat_bysellerscore.jpg",boxplot_cat_seller)
qplot(Age, data=fifa, geom="histogram", binwidth = 3)
ggplot(fifa)+aes(x=Preferred.Foot,y=Score,color=factor(Preferred.Foot))+geom_boxplot()


  