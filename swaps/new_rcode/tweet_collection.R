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
 
 tweets <- "new_character"
 api_key <- "fmC6OcWB4jqwBT7bRmVssagmP"
 api_secret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"
 access_token <- "2608974788-74mmpYz4VH9dKsypPCd5ZuIvhWi9Wcnm5S7JADW"
 access_token_secret <- "w7jrgfrPW5LfjQOkEjyhL6Jm5tZLoLe6vpN1cp5caaIIN"
 setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
 print("Authorised.. By twitteR")

 args <-commandArgs(TRUE)
 ans <- as.character(args[1])
 str <- as.character(args[2])


logistic <- function(ans,str)
{
 	setwd(str)
	msg <- file("logs.txt", open="wt")  #log file generated
	sink(msg, type="message")
	parent <- str
	folders <- c("Tweeter","sentiment_graphs","most_pos_neg","Some_pos_neg","wordcloud_img")
	for (i in 1:length(folders))  
	{
	dir.create(paste(parent,folders[i], sep="/"))
	}
	tweets <- searchTwitter(ans,n=100,lang="en")
	print("Twitter search completed...")
    ss_t <- paste("Tweeter/",ans,".csv", sep="")
    tweets_df <- do.call (rbind,lapply(tweets,as.data.frame))
    #write.csv(tweets_df,ss_t)
    
    # Links
    tweeter_str <- "https://twitter.com/"
	Link_for_tweets <- tweets_df$screenName
 	path <- paste0(tweeter_str,Link_for_tweets)
    path_df <- data.frame(path)
    csv <- cbind(tweets_df,path_df)
    write.csv(csv,ss_t)

}
    logistic(ans,str)



