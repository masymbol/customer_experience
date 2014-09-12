library(plusser)
library(bitops)
library(RCurl)
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
setAPIkey('AIzaSyDmaKUqQNBbFjSjlut-q9dTWR7RY_juWQk')
myProfile=harvestProfile("+AjayOhri", parseFun = parseProfile)
str(myProfile)
myposts=harvestPage("+AjayOhri", parseFun = parsePost, results = 1, nextToken = NULL, cr = 1)
str(myposts)
head(myposts)
plot(myposts$ti,myposts$nC) #number of comments
plot(myposts$ti,myposts$nP) #number of likes or plus 1
plot(myposts$ti,myposts$nR) #number of reshares

g <- "Basket_Ball"
ppost <- searchPost("cricket",results = 30)
ppostt <- searchPost(g,results = 30)

