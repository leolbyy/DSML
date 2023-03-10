#===============Load Package and Data===============
# load packages
library(ggplot2)
library(tidyr)
library(RColorBrewer)
library(GGally)
library(corrplot)
library(patchwork)
# Set Path
setwd('/Users/cathycai/Documents/NUS/DSA5101 Assignment/project4')
# Read data
data = read.csv('project_residential_price_data.csv')
# transform data
data$V.1 = as.factor(data$V.1)
data$V.10 = as.factor(data$V.10)
data$V.20 = as.factor(data$V.20)

summary(data)

#==================== EDA ==========================

#========1.distribution of individual variable======
#========1.1: histogram + density for continuous variable
# V.9:sales price
ggplot(data, aes(x = V.9)) + 
  geom_histogram(bins = 30, 
                 mapping = aes(y = ..density..),
                 fill = brewer.pal(7,'Blues')[4])+
  geom_line(stat = 'density',color=brewer.pal(7,'YlOrBr')[5],size=1)+
  labs(x="Actual Sales Price", y="Density", 
       title = "Density and Histogram of Actual Sales Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

# V.23:official exchange rate
ggplot(data, aes(x = V.23)) + 
  geom_histogram(bins = 30, 
                 mapping = aes(y = ..density..),
                 fill = brewer.pal(7,'Blues')[4])+
  geom_line(stat = 'density',color=brewer.pal(7,'YlOrBr')[5],size=1)+
  labs(x="Official exchange rate with respect to dollars ", y="Density", 
       title = "Density and Histogram of exchange rates of dollars")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#========1.2:bar plot for categorical variables=======
#V.1:locality
ggplot(data)+
  geom_bar(aes(x=V.1),fill=brewer.pal(7,'Blues')[c(7,5)])+
  labs(x="Locality (V.1)", y="Count", 
       title = "Barplot of locality")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#V.10:building type
ggplot(data)+
  geom_bar(aes(x=V.10),fill=brewer.pal(7,'Blues')[7:4])+
  labs(x="Building Type (V.10)", y="Count", 
       title = "Barplot of building type")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
#V.20
ggplot(data)+
  geom_bar(aes(x=V.20),fill=brewer.pal(7,'Blues')[7:4])+
  labs(x="Loan Interest (V.20)", y="Count", 
       title = "Barplot of Loan Interest")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#==============2.correlation between variables===========

#==============2.1 correlation between input features========
# V.5,V.8
# correlation matrix plot
corrplot.mixed(cor(data[c(5,8)]), lower = "number", upper = "color")
ggpairs(data,columns=c(9,12),
        columnLabels = c('Preliminary Cost (V.5)',
                         'Price at beginning (V.8)'))+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
#V.5,V.9
# jitter
ggplot(data)+
  geom_jitter(aes(x=V.5,y=V.9),color=brewer.pal(7,'Blues')[4],alpha=0.6)+
  labs(x="Preliminary Cost", 
       y="Sales Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.8,0.8))


# V.8,V.9
# density plot together
d1 = data[c('V.8','V.9')] %>% gather(key="key", value="val")
ggplot(d1) + 
  geom_density(aes(x=val,color=key))+
  scale_color_discrete(labels=c('Price at beginning (V.8)',
                                'Actual Price (V.9)'))+
  labs(x="Price", y="Density", 
       title = "Density of Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.8,0.8))
# jitter
ggplot(data)+
  geom_jitter(aes(x=V.8,y=V.9),color=brewer.pal(7,'Blues')[4],alpha=0.6)+
  labs(x="Price per Unit at the beginning", 
       y="Sales Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.8,0.8))

#V.21,V.22
d1 = data[c('V.21','V.22')] %>% gather(key="key", value="val")
ggplot(d1) + 
  geom_density(aes(x=val,color=key))+
  scale_color_discrete(labels=c('Cost at completion (V.21)',
                                'Cost at beginning (V.22)'))+
  labs(x="Cost", y="Density", 
       title = "Density of Cost")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.8,0.8))
#jitters
ggplot(data)+
  geom_jitter(aes(x=V.21,y=V.22),color=brewer.pal(7,'Blues')[4],alpha=0.6)+
  labs(x="Cost at completion", 
       y="Cost at beginning")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.title=element_blank(),
        legend.position = c(0.8,0.8))

#pairs
#V2 and V3
ggpairs(data,columns=2:3,columnLabels =c('floor area (V.2)','lot area (V.3)'))+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
#V4:V8
ggpairs(data,columns=c(4:8))+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#V11 and V14
ggpairs(data,columns=c(9,12),
        columnLabels = c('Permitted Building Number (V.11)',
                         'Permitted Building Area (V.14)'))+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

#V12,13,15,16,17,21,22, 25,26,29
#pairs plot
ggpairs(data,columns=c(12,13,15,16,17,21,22, 25,26,29)-2)+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
#corrplot
M = cor(data[c(12,13,15,16,17,21,22, 25,26,29)-2])
res1 <- cor.mtest(data[c(12,13,15,16,17,21,22, 25,26,29)-2], conf.level = .95)
corrplot(M,method='ellipse', p.mat = res1$p, insig = "blank")
corrplot.mixed(M, lower = "ellipse", upper = "number", 
               sig.level = c(.001, .01, .05), pch.cex = .9, pch.col = "white",
               p.mat = res1$p, insig = "label_sig")
corrplot(M, p.mat = res1$p, method = 'color', diag = FALSE, type = 'upper',
         sig.level = c(0.001, 0.01, 0.05), pch.cex = 0.9,
         insig = 'label_sig', pch.col = 'white', order = 'AOE')

#V.1,V.10
table(x=data$V.1, y=data$V.10)
chisqt<-chisq.test(x=data$V.1, y=data$V.10)
chisqt#X-squared = 35.331, df = 3, p-value = 1.037e-07

#==============2.2 correlation between input features and output========
#V.1 and V.9
#boxplot
g1 = ggplot(data)+
  geom_boxplot(aes(x=V.1,y=V.9,color=V.1))+
  labs(x="Locality (V.1)", y="Sales Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = 'none')

#density
g2 = ggplot(data)+
  geom_density(aes(x=V.9,color=V.1,fill=V.1),alpha=0.3)+
  labs(x="Sales Price", y="Density",color='Locality')+
  guides(fill="none")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
g=get_legend(g2)

g1+g2+plot_layout(guides = 'collect')+
  plot_annotation(title = 'Relationship of Locality and Sales Price')&
  theme(plot.title = element_text(size=12,hjust=0.5))

# T.test
# first, Normality test
shapiro.test(data[data['V.1']==1,'V.9'])
shapiro.test(data[data['V.1']==2,'V.9'])
# they're both normalized distributed
t.test(V.9~V.1,data) #p-value = 3.532e-16
# V.1 is strongly assotiated with V.9


#V.10 and V.9
#boxplot
g1 = ggplot(data)+
  geom_boxplot(aes(x=V.10,y=V.9,color=V.10))+
  labs(x="Building Type (V.10)", y="Sales Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = 'none')
#density
g2 = ggplot(data)+
  geom_density(aes(x=V.9,color=V.10,fill=V.10),alpha=0.3)+
  labs(x="Sales Price", y="Density",color='Building Type')+
  guides(fill="none")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
g=get_legend(g2)

g1+g2+plot_layout(guides = 'collect')+
  plot_annotation(title = 'Relationship of Building Type and Sales Price')&
  theme(plot.title = element_text(size=12,hjust=0.5))
# ANOVA.test
# first, Normality test
shapiro.test(data[data['V.10']==1,'V.9'])
shapiro.test(data[data['V.10']==2,'V.9'])
shapiro.test(data[data['V.10']==3,'V.9'])
shapiro.test(data[data['V.10']==4,'V.9'])
# they're both normalized distributed
aov_test<-aov(V.9~V.10,data)
summary(aov_test) #p.value<2e-16 ***
# V.10 is strongly assotiated with V.9

#V.20and V.9
#boxplot
g1=ggplot(data)+
  geom_boxplot(aes(x=V.20,y=V.9,color=V.20))+
  labs(x="Loan Interest (V.20)", y="Sales Price")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        legend.position = 'none')
#density
g2=ggplot(data)+
  geom_density(aes(x=V.9,color=V.20,fill=V.20),alpha=0.3)+
  labs(x="Sales Price", y="Density",color='Loan Interest')+
  guides(fill="none")+
  theme_bw()+
  theme(plot.title = element_text(size=12,hjust=0.5),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())
g1+g2+plot_layout(guides = 'collect')+
  plot_annotation(title = 'Relationship of Loan Interest and Sales Price')&
  theme(plot.title = element_text(size=12,hjust=0.5))

# ANOVA.test
# first, Normality test
shapiro.test(data[data['V.20']==11,'V.9'])
shapiro.test(data[data['V.20']==12,'V.9'])
shapiro.test(data[data['V.20']==14,'V.9'])
shapiro.test(data[data['V.20']==15,'V.9'])
# they're both normalized distributed except group 14
aov_test<-aov(V.9~V.20,data)
summary(aov_test) #p.value<2e-16 ***
# V.20 is strongly assotiated with V.9
