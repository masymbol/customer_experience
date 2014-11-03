 
 library(methods)
 library(RColorBrewer)
 library(NLP)
 library(tm)
 library(wordcloud)

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
  m <- post$msg
  t <-tweets$text
  df_t <-data.frame(t)
  df_m <-data.frame(m)
  colnames(df_t) <- "text"
  colnames(df_m) <- "text"
  text_concat <-rbind(df_t,df_m)
  concated_text <- text_concat$text

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

 clean_text = clean.text(concated_text)

 tweet_corpus = Corpus(VectorSource(clean_text))
 tdm = TermDocumentMatrix(tweet_corpus, control = list(removePunctuation = TRUE,stopwords = c("machine", "learning", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

 m = as.matrix(tdm) #we define tdm as matrix

 word_freqs = sort(rowSums(m), decreasing=TRUE)   #now we get the word orders in decreasing order

 dm = data.frame(word=names(word_freqs), freq=word_freqs)    #we create our data set
 jpeg('wordcloud_img/wordcloud.jpg')
 wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
 dev.off()
}

logistic(ans,str)