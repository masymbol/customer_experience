################### SVM ################################
library(e1071)
library(MASS)
data(cats)
data(iris)
attach(iris)
model  <- svm(Sex~., data = cats)

index <- 1:nrow(cats)
#pred <- predict(model, x)
#x <- subset(iris, select = -Species)
#y <- subset(iris, select = Species)
#model <- svm(x, y)
#model <- svm(Species ~ ., data = iris)

# alternatively the traditional interface:
#x <- subset(iris, select = -Species)
#y <- Species
#model <- svm(x, y) 

index <- 1:nrow(cats)
testindex <- sample(index, trunc(length(index)/3))
testset <- cats[testindex,]
trainset <- cats[-testindex,]
prediction <- predict(model, testset[,-1])

########################################################################














