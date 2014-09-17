logistic <- function(ans,str)
{
setwd(str)
parent <- str
folders <- c("post","sentiment_graphs","most_pos_neg","Some_pos_neg","wordcloud_img")

for (i in 1:length(folders))  
{
  dir.create(paste(parent,folders[i], sep="/"))
}

tweets <- searchTwitter(ans,n=25)
print("search completed...")

bigdata.df <- do.call (rbind,lapply(tweets,as.data.frame))                        
write.csv(bigdata.df,"post/iphone.csv")
write("Write_success","post/_success.txt")
 
Tweets.text = laply(tweets,function(t)t$getText())
pos = scan('/home/raghuvarma/Desktop/swaps/project/positive-words.txt', what='character', comment.char=';')

neg = scan('/home/raghuvarma/Desktop/swaps/project/negative-words.txt', what='character', comment.char=';')

score.sentiment = function(sentences, pos.words, neg.words, .progress='none')
  
{
  
  require(plyr)
  
  require(stringr)
  scores = laply(sentences, function(sentence, pos.words, neg.words) 
{
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
jpeg('sentiment_graphs/sentiment_score.jpg')  
write("Write_success","sentiment_graphs/_success.txt") 
hist(analysis$score)   
dev.off()
View(analysis)

############################## most +ve and _ve tweets ############################
a <- grep(3, analysis$score) #find 3 of score
print("most +ve tweet :-")
p<-max(analysis$score,na.rm=TRUE) # find max
q<-min(analysis$score,na.rm=TRUE)
dfpv1<-analysis[which(analysis$score==p),]
dfng1<-analysis[which(analysis$score==q),]
write.table(dfpv1,"most_pos_neg/most_pos.csv")
write("Write_success","most_pos_neg/_success.txt")
write.table(dfng1,"most_pos_neg/most_neg.csv")
write("Write_success","most_pos_neg/_success.txt")


print("some +ve tweets :-")
df2 <- analysis[which(analysis$score==3 | analysis$score==2 | analysis$score==1),]
write.table(df2,"Some_pos_neg/some_pos.csv")
write("Write_success","Some_pos_neg/_success.txt")

print("some -ve tweets :-")
df3 <- analysis[which(analysis$score==-3 | analysis$score==-2 | analysis$score==-1),]
write.table(df3,"Some_pos_neg/some_neg.csv")
write("Write_success","Some_pos_neg/_success.txt")

tweets.text <- sapply(tweets, function(x) x$getText())

clean.text <- function(some_txt)
  
{
  some_txt = gsub("&amp", "", some_txt)
  
  some_txt = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", some_txt)
  
  some_txt = gsub("@\\w+", "", some_txt)
  
  some_txt = gsub("[[:punct:]]", "", some_txt)
  
  some_txt = gsub("[[:digit:]]", "", some_txt)
  
  some_txt = gsub("http\\w+", "", some_txt)
  
  some_txt = gsub("[ \t]{2,}", "", some_txt)
  
  some_txt = gsub("^\\s+|\\s+$", "", some_txt)
  
  # define "tolower error handling" function
  
  try.tolower = function(x)
    
  {
   y = NA
    
    try_error = tryCatch(tolower(x), error=function(e) e)
    
    if (!inherits(try_error, "error"))
    y = tolower(x)
  return(y)
  }
  some_txt = sapply(some_txt, try.tolower)
  some_txt = some_txt[some_txt != ""]
  names(some_txt) = NULL
  return(some_txt)
}

clean_text = clean.text(tweets.text)

tweet_corpus = Corpus(VectorSource(clean_text))
tdm = TermDocumentMatrix(tweet_corpus, control = list(removePunctuation = TRUE,stopwords = c("machine", "learning", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

m = as.matrix(tdm) #we define tdm as matrix

word_freqs = sort(rowSums(m), decreasing=TRUE)   #now we get the word orders in decreasing order

dm = data.frame(word=names(word_freqs), freq=word_freqs)    #we create our data set
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
jpeg('wordcloud_img/wordcloud.jpg')
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
dev.off()
write("Write_success","wordcloud_img/_success.txt")
}


