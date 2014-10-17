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
library(stringr)
library(twitteR)
library(plusser)

Basket_Ball <-"iphone"

############################ Twitter ####################################
api_key <- "fmC6OcWB4jqwBT7bRmVssagmP"
api_secret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"
access_token <- "2608974788-74mmpYz4VH9dKsypPCd5ZuIvhWi9Wcnm5S7JADW"
access_token_secret <- "w7jrgfrPW5LfjQOkEjyhL6Jm5tZLoLe6vpN1cp5caaIIN"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

bigdata <- searchTwitter(Basket_Ball,n=700)
bigdata.df <-do.call (rbind,lapply(bigdata,as.data.frame))
combined_text <- bigdata.df["text"]
p <- bigdata.df["text"]
combined_text["Source"] <- "Twitter"

############################ G+ ####################################
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
setAPIkey('AIzaSyDmaKUqQNBbFjSjlut-q9dTWR7RY_juWQk')
ppostt <- searchPost(Basket_Ball,results = 30)
gp_text <- ppostt["msg"]
q <- ppostt["msg"]
gp_text["Source"] <- "G+"
colnames(gp_text) <- c("text","Source")

combined_text <- rbind(combined_text, gp_text)
combined_text_char <- as.character(combined_text)
pos = scan('/home/purva/Desktop/project/positive-words.txt', what='character', comment.char=';')
neg = scan('/home/purva/Desktop/project/negative-words.txt', what='character', comment.char=';')

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) {
    
    sentence = gsub('[[:punct:]]', '', sentence)
    sentence = gsub('[[:cntrl:]]', '', sentence)
    sentence = gsub('\\d+', '', sentence)
    
    sentence = tolower(sentence)
    word.list = str_split(sentence, '\\s+')
    words = unlist(word.list)
    pos.matches = match(words, pos.words)
    neg.matches = match(words, neg.words)
    
    pos.matches = !is.na(pos.matches)
    neg.matches = !is.na(neg.matches)
    
    score = sum(pos.matches) - sum(neg.matches)
    
    return(score)
  }, pos.words, neg.words, .progress=.progress )
  
  scores.df = data.frame(score=scores, text=sentences)
  return(scores.df)
}

analysis = score.sentiment(combined_text_char, pos, neg)    
table(analysis$score)   
mean(analysis$score)   
hist(analysis$score)  

# Grph of reshares(G+) and retweets(Twitter)
plot(ppostt$ti,ppostt$nR)
plot(dat,bigdata.df$retweetCount)



###########################################################################
#### use this code for word cloud generation of g+ and twitter ############
colnames(q) <-c("text")
combined_pq <-rbind(p,q)
char_combined_pq <- as.character(combined_pq)
## Run wordcloud.R from clean.text ###########################################

######## IMP have a look ############
str <- as.character(bigdata.df$created)
j<-str[1:70]
dat <- as.date(str)
plot(dat,bigdata.df$retweetCount)
#####################################




