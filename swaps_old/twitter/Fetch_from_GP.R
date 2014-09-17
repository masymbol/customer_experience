library(RCurl)
library(bitops)
library(RJSONIO)
library(ggplot2)
library(reshape2)


api_key<-"AIzaSyCKqFMyz0H1B6sKmScYbLlMPgU92cINswY"
user_id <- "+AjayOhri"
data <- getURL(paste("https://www.googleapis.com/plus/v1/people/",user_id,"/activities/public?maxResults=100&key=", api_key, sep=""),ssl.verifypeer = FALSE)
js <- fromJSON(data, asText=TRUE)
df = data.frame(no = 1:length(js$items))

for (i in 1:nrow(df)){
  
  df$kind[i] = js$items[[i]]$verb
  
  df$title[i] = js$items[[i]]$title
  
  df$replies[i] = js$items[[i]]$object$replies$totalItems
  
  df$plusones[i] = js$items[[i]]$object$plusoners$totalItems
  
  df$reshares[i] = js$items[[i]]$object$resharers$totalItems
  
  df$url[i] = js$items[[i]]$object$url
  
}

filename <- paste("gplus_data_", user_id, sep="") # in case we have more user_ids


write.table(df, file = paste0(filename,".csv"), sep = ",", col.names = NA,
            qmethod = "double")

df_graph = df[,c(1,4,5,6)]

melted=melt(df_graph,id.vars='no')

ggplot(melted,aes(x=factor(no),y=value,color=factor(variable),group=factor(variable)))+
  geom_line()+xlab('no')+guides(color=guide_legend("metrics"))+
  labs(title="Google+")

# change userId and u ll get different graphs
