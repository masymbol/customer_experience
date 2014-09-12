
args <-commandArgs(TRUE)
ans <- as.character(args[1])

source("productdata.R")
logistic(ans)
