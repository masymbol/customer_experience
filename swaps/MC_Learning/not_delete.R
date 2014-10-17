library(ggplot2)
library(maps)
library(twitteR)
twitterMap <- function(searchtext,locations,radius){
 
  #radius from randomly chosen location
  radius=radius
  lat<-12.97159#runif(n=locations,min=12.97159, max=26.384472)
  long<-77.59456#runif(n=locations,min=77.59456, max=34.949778)
  #generate data fram with random longitude, latitude and chosen radius
  coordinates<-as.data.frame(cbind(lat,long,radius))
  coordinates$lat<-lat
  coordinates$long<-long
  #create a string of the lat, long, and radius for entry into searchTwitter()
  for(i in 1:length(coordinates$lat)){
    coordinates$search.twitter.entry[i]<-toString(c(coordinates$lat[i],
                                                    coordinates$long[i],radius))
  }
  # take out spaces in the string
  coordinates$search.twitter.entry<-gsub(" ","", coordinates$search.twitter.entry ,
                                         fixed=TRUE)
  
  #Search twitter at each location, check how many tweets and put into dataframe
  for(i in 1:length(coordinates$lat)){
    coordinates$number.of.tweets[i]<-
      length(searchTwitter(searchString=searchtext,n=1000,geocode=coordinates$search.twitter.entry[i]))
  }
  #making the US map
  all_states <- map_data("state")
  #plot all points on the map
  p <- ggplot()
  p <- p + geom_polygon( data=all_states, aes(x=long, y=lat, group = group),colour="grey",     fill=NA )
  
  p<-p + geom_point( data=coordinates, aes(x=long, y=lat,color=number.of.tweets
  )) + scale_size(name="# of tweets")
  p
}
# Example
b <- searchTwitter("bigdata",15,"10000mi")

  

