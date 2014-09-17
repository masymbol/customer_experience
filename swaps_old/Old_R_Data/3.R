library(e1071)
library(caret)

data(iris)

iris$SpeciesClass[iris$Species=="versicolor"] <- "TRUE"
iris$SpeciesClass[iris$Species!="versicolor"] <- "FALSE"
trainPositive<-subset(iris,SpeciesClass=="TRUE")
inTrain<-createDataPartition(1:nrow(trainPositive),p=0.6,list=FALSE)
trainpredictors<-iris[inTrain,1:4]
testpredictors<-iris[,1:4]
testLabels<-iris[,6]

svm.model<-svm(trainpredictors,y=NULL,
               type='one-classification',
               nu=0.5,
               scale=TRUE,
               kernel="radial")
svm.pred<-predict(svm.model,testpredictors)
confusionMatrixTable<-table(Predicted=svm.pred,Reference=testLabels)
confusionMatrix(confusionMatrixTable,positive='TRUE')