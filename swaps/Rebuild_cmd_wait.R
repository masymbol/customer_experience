## user interaction
args <-commandArgs(TRUE)
str <- as.character(args[1])
terms <- as.character(args[2])
splat <- strsplit(terms, ",")[[1]]
sp <- strsplit(terms, ",")[[1]]
#print(splat)

logistic <- function(str,splat)
{    

setwd(str)
#setwd("/home/purva/Desktop/TRial_for_compitive_analysis")
#str <-"/home/purva/Desktop/TRial_for_compitive_analysis"
parent <- str
folders <- c("Tweets","pos_neg","Most_inflencer","sentiment","wordcloud")
for (i in 1:length(folders))  
{
  dir.create(paste(parent,folders[i], sep="/"))
}

setwd(str)
library(rJava)
library(ggplot2)
library(bitops)
library(RCurl)
library(digest)
library(NLP)
library(RColorBrewer)
library(ROAuth)
library(RJSONIO)
library(stringr)
library(tm)
library(httr)
library(wordcloud)
library(devtools)
library(twitteR)
library(plyr)
library(stringr)
library(splines)
library(survival)
library(MASS)
#library(doBy)
library(plusser)

## Twitter Authentication ##
api_key <- "fmC6OcWB4jqwBT7bRmVssagmP"
api_secret <- "3e2Y9jfPVqwUgQtEMwGaIQYrjGLe1DnG3xEMmQBnHaqQcduc94"
access_token <- "2608974788-74mmpYz4VH9dKsypPCd5ZuIvhWi9Wcnm5S7JADW"
access_token_secret <- "w7jrgfrPW5LfjQOkEjyhL6Jm5tZLoLe6vpN1cp5caaIIN"
setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
setAPIkey('AIzaSyDmaKUqQNBbFjSjlut-q9dTWR7RY_juWQk')
cat("\nAuthorised..\n")


## sentiment score function ##
hu.liu.pos=scan('../../../project/positive-words.txt',what='character',comment.char=';')
hu.liu.neg=scan('../../../project/negative-words.txt',what='character',comment.char=';')
pos.words=c(hu.liu.pos,'upgrade')
neg.words=c(hu.liu.neg,'wtf','wait','waiting','epicfail','mechanical')
sample=c("You'reawesomeandIloveyou","Ihateandhateandhate.Soangry.Die!","Impressedandamazed:youarepeerlessinyourachievementofunparalleledmediocrity.")

## Global values ##
g5 <- data.frame()
g8 <- data.frame()
pdf <- data.frame()
l <- data.frame()
transfer <- data.frame()
str_wcloud <- as.character()
ppostt_df <- data.frame()

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  require(stringr)
  
  scores = laply(sentences, function(sentence, pos.words, neg.words) 
  {
    sentence = iconv(sentence, "latin1", "ASCII", sub="")
    sentence = str_replace_all(sentence, "[^[:alnum:]]", " ")
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

 for (i in 1:length(splat))
 {
 print(splat[i])

  str <- splat[i]
  strr <- as.character(str)
  str_wcloud <<- paste(strr,str_wcloud,append=strr)
  p <- searchTwitter(str,n=90)
  ans_gp <- paste0("#",strr)
  print(ans_gp)
  ppostt <- searchPost(ans_gp)
   
  bigdata.dff <- do.call (rbind,lapply(p,as.data.frame))
  msg <-data.frame(ppostt$msg)
  text <-data.frame(bigdata.dff$text)
  colnames(msg) <- "text"
  colnames(text) <- "text"
  ppp <- rbind(text,msg)
  p.text <-as.character(ppp$text)
  #p.text <- sapply(p,function(t)t$getText())
  #tweets.textt <- sapply(p,function(x) x$getText())
  pdf <- data.frame(p.text) # for wordcloud
  g8 <<- data.frame(rbind(g8,pdf))
  #l <<- data.frame(g8)
  ppostt_df <<- data.frame(rbind(ppostt_df,ppostt))
  
  p.scores=score.sentiment(p.text,pos.words,neg.words,.progress='text')
  
  #
  nuetral <- p.scores[which(p.scores$score==0),]
  positive <- p.scores[which(p.scores$score>0),]
  negative <- p.scores[which(p.scores$score<0),]
  
  nuet_l <-data.frame(length(nuetral$score))
  nuet_l["class"] <- "nuetral"
  pos_l <-data.frame(length(positive$score))
  pos_l["class"] <- "positive"
  neg_l <-data.frame(length(negative$score))
  neg_l["class"] <- "negative"
  
  colnames(nuet_l)[1] <- "length"
  colnames(pos_l)[1] <- "length"
  colnames(neg_l)[1] <- "length"
  
  sentiment_file <- rbind(nuet_l,pos_l,neg_l)
  senti_name <- paste("sentiment/",strr,"_sentiment.csv", sep="")
  write.csv(sentiment_file,senti_name)
  #
  
  g1 <- p.scores
  g5 <<- rbind(g5,g1) #g5 is global now

  ############################## most +ve and _ve tweets ############################
  #setwd("/home/purva/Desktop/TRial_for_compitive_analysis/")
  a <- grep(3, g1$score) #find 3 of score
  pp<-max(g1$score,na.rm=TRUE) # find max
  qq<-min(g1$score,na.rm=TRUE)
  dfpv1 <- g1[which(g1$score==pp),]
  dfng1 <- g1[which(g1$score==qq),]
  output_pos <- paste("pos_neg/",strr,"_Most_pos.csv", sep="")
  output_neg <- paste("pos_neg/",strr,"_Most_neg.csv", sep="")
  write.csv(dfpv1,output_pos)
  write.csv(dfng1,output_neg)
  
  df2 <- g1[which(g1$score==3 | g1$score==2 | g1$score==1),]
  df3 <- g1[which(g1$score==-3 | g1$score==-2 | g1$score==-1),]
  output_Somepos <- paste("pos_neg/",strr,"some_pos.csv", sep="")
  output_Someneg <- paste("pos_neg/",strr,"some_neg.csv", sep="")
  write.csv(df2,output_Somepos)
  write.csv(df3,output_Someneg)
  
  #### write csv ####
  #setwd("/home/purva/Desktop/TRial_for_compitive_analysis/Tweets")
  bigdata.df <- do.call (rbind,lapply(p,as.data.frame))  # twitter
  transfer <- bigdata.df
  outputfile <- paste("Tweets/",strr,".csv", sep="")
  write.csv(bigdata.df,outputfile)

  outputfile <- paste("Tweets/",strr,"_gp_post.csv", sep="")
  write.csv(ppostt,outputfile)
  
  #################### most influencer ###################
  #setwd("/home/purva/Desktop/TRial_for_compitive_analysis/Most_inflencer")
  combined <- transfer[transfer$retweetCount > 0 & transfer$favoriteCount > 0,]
  add <- combined$retweetCount + combined$favoriteCount
  combined["addition"] <- add
  asc <- combined[with(combined, order(addition)), ]  #ascending order
  desc <- combined[with(combined, order(-addition)), ] #descending order 
  scr_name <- desc$screenName
  output_infl <- paste("Most_inflencer/",strr,"MostInflencer_names.csv", sep="")
  #write.csv(scr_name,output_infl)
  
  p1 <- data.frame(desc$screenName)
  add_sec <- transfer$retweetCount + transfer$favoriteCount
  transfer["addition"] <- add_sec
  desc2 <- transfer[with(transfer, order(-addition)), ]
  p2 <- data.frame(desc2$screenName)
  colnames(p2) <- "desc.screenName"
  p3 <- rbind(p1,p2)
  p3["source"] <- "Twitter"
  colnames(p3)[1] <- "identification"
  output_infl_list <- paste("Most_inflencer/",strr,".csv", sep="")
  #write.csv(p3,output_infl_list)
    
  #### gp influencer #####
  gpf <- ppostt
  comn <- gpf$nP + gpf$nR
  gpf["add"] <- comn
  desc2 <- gpf[with(gpf, order(-add)), ]
  gp_names <-data.frame(desc$au)
  desc2["source"] <- "G+"
  output_infl_listt <- paste("Most_inflencer/",strr,".csv", sep="")
  #write.csv(desc2,output_infl_listt)
  q1 <- data.frame(desc2$au)
  q2 <- data.frame(desc2$source)
  q <- cbind(q1,q2)
  colnames(q)[1] <- "identification"
  colnames(q)[2] <- "source"
  #write.csv(q,output_infl_listt)
    
  influ_bind <- rbind(p3,q)
  write.csv(influ_bind,output_infl_listt)

}	
}
logistic(str,splat)

source("/home/raghuvarma/Documents/nodejs_examples/social_media/swaps/wordcld.R")


