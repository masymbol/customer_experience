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
tweets = searchTwitter("#cricket",n=200)

print("search completed...")

bigdata.df <-do.call (rbind,lapply(tweets,as.data.frame))                        
 write.csv(bigdata.df,"/home/raghuvarma/Documents/nodejs_examples/social-media/iphone.csv")
 
Tweets.text = laply(tweets,function(t)t$getText())
pos = scan('/home/raghuvarma/Desktop/swaps/project/positive-words.txt', what='character', comment.char=';')

neg = scan('/home/raghuvarma/Desktop/swaps/project/negative-words.txt', what='character', comment.char=';')

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
analysis = score.sentiment(Tweets.text, pos, neg)    
table(analysis$score)   
mean(analysis$score)   
hist(analysis$score)   
View(analysis)

############################## most +ve and _ve tweets ############################
a <- grep(3, analysis$score) #find 3 of score
print("most +ve tweet :-")
p<-max(analysis$score,na.rm=TRUE) # find max
q<-min(analysis$score,na.rm=TRUE)
dfpv1<-analysis[which(analysis$score==p),]
dfng1<-analysis[which(analysis$score==q),]
write.table(dfpv1,"/home/raghuvarma/Desktop/swaps/most_pos.csv")
write.table(dfng1,"/home/raghuvarma/Desktop/swaps/most_neg.csv")


print("some +ve tweets :-")
df2 <- analysis[which(analysis$score==3 | analysis$score==2 | analysis$score==1),]
write.table(df2,"/home/raghuvarma/Desktop/swaps/some_pos.csv")

print("some -ve tweets :-")
df3 <- analysis[which(analysis$score==-3 | analysis$score==-2 | analysis$score==-1),]
write.table(df3,"/home/raghuvarma/Desktop/swaps/some_neg.csv")

source("/home/raghuvarma/Desktop/swaps/twitter/WordCloud.R")
