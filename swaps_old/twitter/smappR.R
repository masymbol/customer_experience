library(rjson)

library(rmongodb)
library(R2WinBUGS)
library(coda)
library(lattice)
library(boot)
library(digest)
library(RCurl)
library(bitops)
library(NLP)
library(RColorBrewer)
library(ROAuth)
library(bitops)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)
library(devtools)
library(twitteR)
library(plyr)
library(stringr)
library(twitteR)
library(Rfacebook)
library(streamR)
library(smappR)


reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"
consumerKey <- "fmC6OcWB4jqwBT7bRmVssagmP"
consumerSecret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"

api_key <- "fmC6OcWB4jqwBT7bRmVssagmP"
api_secret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"
access_token <- "2608974788-74mmpYz4VH9dKsypPCd5ZuIvhWi9Wcnm5S7JADW"
access_token_secret <- "w7jrgfrPW5LfjQOkEjyhL6Jm5tZLoLe6vpN1cp5caaIIN"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
#twitCred <- OAuthFactory$new(consumerKey=consumerKey,consumerSecret=consumerSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
#twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))
mongo <- mongo.create("127.0.0.1", db="swaps")


