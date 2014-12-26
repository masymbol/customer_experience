######## wordcloud ################
print("wordcloud entered")
write.csv(g8,"wcloud.csv")
write.csv(ppostt_df,"gp.csv")
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

g8_char <- as.character(g8$p.text)
tw <-data.frame(g8$p.text)
gp <- data.frame(ppostt_df$msg)
colnames(tw) <- "text"
colnames(gp) <- "text"
comb_text <- rbind(tw,gp)
chars <- as.character(comb_text$text)
write.csv(comb_text,"comb.csv")

clean_text = clean.text(chars)
tweet_corpus = Corpus(VectorSource(clean_text))
tdm = TermDocumentMatrix(tweet_corpus, control = list(removePunctuation = TRUE,stopwords = c("machine", "learning", stopwords("english")), removeNumbers = TRUE, tolower = TRUE))

m = as.matrix(tdm) #we define tdm as matrix

word_freqs = sort(rowSums(m), decreasing=TRUE)   #now we get the word orders in decreasing order

dm = data.frame(word=names(word_freqs), freq=word_freqs)    #we create our data set
jpeg('wordcloud/word_cloud.jpg')
wordcloud(dm$word, dm$freq, random.order=FALSE, colors=brewer.pal(8, "Dark2"))
print(str_wcloud)

