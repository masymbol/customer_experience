library(XML)
library(sp)
library(raster)
library(dismo)
library(maps)
library(ggplot2)
library(twitteR)

searchTerm <- "#rstats"
searchResults <- searchTwitter(searchTerm, n = 1000) # Gather Tweets
tweetFrame <- twListToDF(searchResults) # Convert to a nice dF
userInfo <- lookupUsers(tweetFrame$screenName) # Batch lookup of user info
userFrame <- twListToDF(userInfo) # Convert to a nice dF
#locatedUsers <- !is.na(userFrame$location)   
#locationss <- geocode(userFrame$location[locatedUsers]) # Use amazing API to guess
locations <- geocode(userFrame$location)
locations_And_Name <- cbind(locations$originalPlace,locations$interpretedPlace,userFrame$screenName)
# approximate lat/lon from textual location data.
with(locations, plot(longitude, latitude))

newdata <- locationss[order(row.names),] 


############ not working ##############
worldMap <- map_data("world")
zp1 <- ggplot(worldMap)
zp1 <- zp1 + geom_path(aes(x = locations$longitude, y = locations$latitude, group = group), colour = gray(2/3), lwd = 1/3)
zp1 <- zp1 + geom_point(data = locations, aes(x = locations$longitude, y = locations$latitude),colour = "RED", alpha = 1/2, size = 1)# Add points indicating users
zp1 <- zp1 + coord_equal() # Better projections are left for a future post
zp1 <- zp1 + theme_minimal() # Drop background annotations
print(zp1)
#########################################
tuser <- getUser('Eselquesoy') # to get user





