library(e1071)
library(pmml)
library(XML)
library(RJSONIO)
file <- read.delim("~/file")
View(file)
i<-toJSON(file)
i

i1 <- rjson::fromJSON(i)

d3Tree(List = i1, file="k12.html")