
 args <-commandArgs(TRUE)
 ans <- as.character(args[1])
 str <- as.character(args[2])

logistic <- function(ans,str)
{
	setwd(str)
	ss_t <- paste("post/Twitter/",ans,".csv", sep="")
	ss_gp <- paste("post/Gp/",ans,".csv", sep="")

 ## Excet write.csv.. everything is working fine
 tweets <- read.csv(ss_t)
 post <- read.csv(ss_gp)
 print("Reading success")
 pos = scan('/home/raghuvarma/Documents/nodejs_examples/social_media/swaps/project/positive-words.txt', what='character', comment.char=';')
 neg = scan('/home/raghuvarma/Documents/nodejs_examples/social_media/swaps/project/negative-words.txt', what='character', comment.char=';')

 m <- post$msg
 t <-tweets$text
 print("pass")
 df_t <-data.frame(t)
 df_m <-data.frame(m)
 print("pass1")
 colnames(df_t) <- "text"
 colnames(df_m) <- "text"
 print("pass2")
 text_concat <-rbind(df_t,df_m)
 concated_text <- text_concat$text

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
{
  require(plyr)
  
  require(stringr)
  scores = laply(sentences, function(sentence, pos.words, neg.words) 
  {
    sentence = gsub('[[:punct:]]', '', sentence)
    
    sentence = gsub('[[:cntrl:]]', '', sentence)
    
    sentence = gsub('\\d+', '', sentence)
    
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

 analysis = score.sentiment(concated_text, pos, neg) 
 table(analysis$score)   
 mean(analysis$score)

 txt <-data.frame(analysis$text)
 scr <-data.frame(analysis$score)
 res <- cbind(scr,txt) 
 colnames(res) <- c("analysis_score","analysis_text")
 write.csv(res,"sentiment_graphs/score_analysis.csv")
 write("Write_success","sentiment_graphs/_success.txt") 

 ############################## most +ve and _ve tweets ############################
 a <- grep(3, analysis$score) #find 3 of score
 print("most +ve tweet :-")
 p<-max(analysis$score,na.rm=TRUE) # find max
 q<-min(analysis$score,na.rm=TRUE)
 dfpv1<-analysis[which(analysis$score==p),]
 dfng1<-analysis[which(analysis$score==q),]

 p1<-data.frame(dfpv1$score)
 p2<-data.frame(dfpv1$text)
 p3<-cbind(p1,p2) 

 p11<-data.frame(dfng1$score)
 p12<-data.frame(dfng1$text)
 p13<-cbind(p11,p12) 

 write.csv(dfpv1$text,"most_pos_neg/most_pos.csv")
 write("Write_success","most_pos_neg/_success.txt")
 write.csv(dfng1$text,"most_pos_neg/most_neg.csv")
 write("Write_success","most_pos_neg/_success.txt")

 #### Links with some posN neg ####
 print("some +ve tweets :-")
 df2 <- analysis[which(analysis$score==3 | analysis$score==2 | analysis$score==1),]
 p21<-data.frame(df2$score)
 p22<-data.frame(df2$text)
 p23<-cbind(p21,p22)
 write.csv(df2,"Some_pos_neg/some_pos.csv")
 write("Write_success","Some_pos_neg/_success.txt")

 print("some -ve tweets :-")
 df3 <- analysis[which(analysis$score==-3 | analysis$score==-2 | analysis$score==-1),]
 p31<-data.frame(df3$score)
 p32<-data.frame(df3$text)
 p33<-cbind(p31,p32)

 write.csv(df3,"Some_pos_neg/some_neg.csv")
 write("Write_success","Some_pos_neg/_success.txt")
 
 }

 logistic(ans,str)