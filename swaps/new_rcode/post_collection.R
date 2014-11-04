 library(bitops)
 library(methods)
 library(digest)
 library(RCurl)
 library(NLP)
 library(RColorBrewer)
 library(ROAuth)
 library(RJSONIO)
 library(stringr)
 library(tm)
 library(httr)
 library(wordcloud)
 library(devtools)
 library(plyr)
 library(lubridate)
 library(twitteR)
 library(plusser)

#G+
 options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
 setAPIkey('AIzaSyDmaKUqQNBbFjSjlut-q9dTWR7RY_juWQk')
 print("Authorised.. By Gplus")

 args <-commandArgs(TRUE)
 ans <- as.character(args[1])
 str <- as.character(args[2])

logistic <- function(ans,str)
{
 	setwd(str)
	parent <- str
	folders <- c("Gp")

	for (i in 1:length(folders))  
	{
	dir.create(paste(parent,folders[i], sep="/"))
	}
	
	ans_gp <- paste0("#",ans)
    post <- searchPost(ans_gp,ret = "data.frame", language = NULL,result=100)
    ss_gp <- paste("Gp/",ans,".csv", sep="")
    write.csv(post,ss_gp)
}
    logistic(ans,str)



