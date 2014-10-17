library(bitops)
library(digest)
library(RCurl)
library(NLP)
library(RColorBrewer)
library(ROAuth)
library(bitops)
library(RJSONIO)
library(stringr)
library(tm)
library(httr)
library(wordcloud)
library(devtools)
library(twitteR)
library(plyr)
library(stringr)
library(twitteR)
api_key <- "fmC6OcWB4jqwBT7bRmVssagmP"
api_secret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"
access_token <- "2608974788-74mmpYz4VH9dKsypPCd5ZuIvhWi9Wcnm5S7JADW"
access_token_secret <- "w7jrgfrPW5LfjQOkEjyhL6Jm5tZLoLe6vpN1cp5caaIIN"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
#bigdata <- searchTwitter("#iphone")
tweets = searchTwitter("#iphone",n=200)
#tweets=searchTwitter("charliesheen", since="2011-03-01", until="2011-03-02") 
#bigdata <- searchTwitter("#bigdata", n=600)
#bigdata.df <- do.call(rbind, lapply(bigdata, as.data.frame))
#bigdata <- searchTwitter("#bigdata",n=6000,since="2014-07-01",until="2014-07-14",retryOnRateLimit=5)
#bigdata <- searchTwitter("#bigdata",n=100,since="2014-09-13",until="2014-09-16",retryOnRateLimit=5)

 
