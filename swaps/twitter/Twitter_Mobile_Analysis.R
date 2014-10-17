library("ggplot2")
library(doBy)
library(bitops)
library(RCurl)
library(digest)
library(NLP)
library(RColorBrewer)
library(ROAuth)
library(RJSONIO)
library(stringr)
library(tm)
library(wordcloud)
library(devtools)
library(twitteR)
library(plyr)
library(stringr)

library(survival)
library(splines)
library(doBy)

api_key <- "fmC6OcWB4jqwBT7bRmVssagmP"
api_secret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"
access_token <- "2608974788-74mmpYz4VH9dKsypPCd5ZuIvhWi9Wcnm5S7JADW"
access_token_secret <- "w7jrgfrPW5LfjQOkEjyhL6Jm5tZLoLe6vpN1cp5caaIIN"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

tweets_Apple = searchTwitter("#Apple", n=70)
tweets_Samsung = searchTwitter("#Samsung", n=70)
tweets_Nokia = searchTwitter("#Nokia", n=70)
tweets_HTC = searchTwitter("#HTC", n=70)
tweets_Sony = searchTwitter("#Sony", n=70)

Apple.text=laply(tweets_Apple,function(t)t$getText())
length(Apple.text)
head(Apple.text,5)

hu.liu.pos=scan('/home/purva/Desktop/project/positive-words.txt',what='character',comment.char=';')
hu.liu.neg=scan('/home/purva/Desktop/project/negative-words.txt',what='character',comment.char=';')

pos.words=c(hu.liu.pos,'upgrade')
neg.words=c(hu.liu.neg,'wtf','wait','waiting','epicfail','mechanical')
sample=c("You'reawesomeandIloveyou","Ihateandhateandhate.Soangry.Die!","Impressedandamazed:youarepeerlessinyourachievementofunparalleledmediocrity.")

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

result=score.sentiment(sample,pos.words,neg.words)
class(result)
result$score
Apple.scores=score.sentiment(Apple.text,pos.words,neg.words,.progress='text')
hist(Apple.scores$score)

qplot(Apple.scores$score)

# Samsung
Samsung.text=laply(tweets_Samsung,function(t)t$getText())
Samsung.scores=score.sentiment(Samsung.text,pos.words,neg.words,.progress='text')
hist(Samsung.scores$score)

Nokia.text=laply(tweets_Nokia,function(t)t$getText())
Nokia.scores=score.sentiment(Nokia.text,pos.words,neg.words,.progress='text')
hist(Nokia.scores$score)

HTC.text=laply(tweets_HTC,function(t)t$getText())
HTC.scores=score.sentiment(HTC.text,pos.words,neg.words,.progress='text')
hist(HTC.scores$score)

Sony.text=laply(tweets_Sony,function(t)t$getText())
Sony.scores=score.sentiment(Sony.text,pos.words,neg.words,.progress='text')
hist(Sony.scores$score)

Apple.scores$ph = 'Apple'
Apple.scores$code = 'AA'
Samsung.scores$ph = 'Samsung'
Samsung.scores$code = 'ss'
Nokia.scores$ph = 'Nokia'
Nokia.scores$code = 'nok'
HTC.scores$ph = 'HTC'
HTC.scores$code = 'HTCs'
Sony.scores$ph = 'Sony'
Sony.scores$code = 'sonys'

all.scores=rbind(Apple.scores,Samsung.scores,Nokia.scores,HTC.scores,Sony.scores)

ggplot(data=all.scores)+geom_bar(mapping=aes(x=score,fill=ph),binwidth=1)+
  facet_grid(ph~.)+#makeaseparateplotforeachhotel
  theme_bw()+scale_fill_brewer()


all.scores$very.pos = as.numeric( all.scores$score >= 2 )
all.scores$very.neg = as.numeric( all.scores$score <= -2 )

twitter.df = ddply(all.scores, c('ph', 'code'), summarise,pos.count = sum( very.pos ), neg.count = sum( very.neg ) )

twitter.df$all.count = twitter.df$pos.count + twitter.df$neg.count

twitter.df$score = round( 100 * twitter.df$pos.count /twitter.df$all.count )

orderBy(~-score, twitter.df)

barplot(twitter.df$score,xlab="phones",ylab="feedback_in_counts",main="Graph",names.arg=c("Sony", "HTC", "Nokia","Apple","Samsung"))




