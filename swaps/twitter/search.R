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
#bigdata <- searchTwitter("#iphone")
print("Authorised..")

args <-commandArgs(TRUE)
ans <- as.character(args[1])
str <- as.character(args[2])
source("/home/raghuvarma/Documents/nodejs_examples/social_media/swaps/twitter/search_fun.R")
logistic(ans,str)

