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

bigdata <- searchTwitter(Basket_Ball,n=70)
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
#hist(analysis$score)   
# word_cloud
colnames(q) <-c("text")
combined_pq <-rbind(p,q)
char_combined_pq <- as.character(combined_pq)

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

clean_text = clean.text(char_combined_pq)

tweet_corpus = Corpus(VectorSource(clean_text))
tdm = TermDocumentMatrix(tweet_corpus, control = list(removePunctuation = TRUE,stopwords = c("machine", "learning", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

m = as.matrix(tdm) #we define tdm as matrix

word_freqs = sort(rowSums(m), decreasing=TRUE)   #now we get the word orders in decreasing order

dm = data.frame(word=names(word_freqs), freq=word_freqs)    #we create our data set

wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))

################## pos and neg count ###########

a <- grep(3, analysis$score) #find 3 of score
max(analysis$score,na.rm=TRUE) # find max
min(analysis$score,na.rm=TRUE)

print("some +ve tweets")
df2 <- analysis[which(analysis$score==3 | analysis$score==2 | analysis$score==1),]

print("some +ve tweets")
df3 <- analysis[which(analysis$score==-3 | analysis$score==-2 | analysis$score==-1),]

 
