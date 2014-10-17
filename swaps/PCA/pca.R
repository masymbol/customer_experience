library(reshape2)
library(ggplot2)

#1. #### simple PCA #######
data(iris)
#pca_iris <- princomp(iris,cor = TRUE) not worked..coz string col is there
#iris is not correlation matrix
irispca<-princomp(iris[-5])#5th col removed & performed pca.it generate 4 varience val
irispca$loadings
irispca$scores

p1 <- princomp(USArrests,cor = TRUE)  ## using correlation matrix
## p1 <- princomp(USArrests)  ## using covariance matrix

summary(p1)
loadings(p1)
plot(p1)
biplot(p1)
p1$scores
screeplot(p1) ## identical with plot()
screeplot(p1, npcs=4, type="lines")

princomp(~ ., data = USArrests, cor = TRUE) ## identical with princomp(USArrests, cor = TRUE)
p2 <- princomp(~ Murder + Assault + UrbanPop, data = USArrests, cor = TRUE)
p2$scores

## USArrests data vary by orders of magnitude, so scaling is appropriate
p3 <- prcomp(USArrests, scale = TRUE) ## using correlation matrix
##p3 <- prcomp(USArrests)  ## using covariance matrix
print(p3) 
summary(p3) 
plot(p3) ## Scree plot
biplot(p3)
## Formula interface
p4 <- prcomp(~ Murder + Assault + UrbanPop, data = USArrests, scale = TRUE)

library(nlme)
library(mgcv)
library(labdsv)  ## You first have to load the LabDSV library.
p5 <- pca(USArrests, dim=4, cor = TRUE) ## using correlation matrix 
##p5 <-pca(USArrests, dim=4) ## using covariance matrix 

summary(p5)
varplot.pca(p5)  ## scree plot and cumulative variances plot
loadings.pca(p5)
plot(p5)



###############################
# use source() to run one prog at the same time in another prog