

txt <- c("arm","foot","lefroo", "bafoobar")
if(length(i <- grep("foo", txt)))
  i
txt[i]

##################################################
#bigdata <- read.csv("/home/hduser/bigdata1.csv")
#xC = ncol(bigdata)
#xR = nrow(bigdata)
#for (i in 1:ncol(bigdata))
##################################################

big2 <- readLines("/home/hduser/bigdata.csv")

if(length(i <- grep("IBM", big2)))
i
big2[i]