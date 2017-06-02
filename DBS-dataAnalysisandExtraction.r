#' loading the needed librarys 
library(ggplot2)
library(stringr)
library(RPostgreSQL)
library(lubridate)
library(dplyr, warn.conflicts = F)
library(tidyr, warn.conflicts = F)

#'reading the csv file
election <- read.csv2(file = "/Users/Uli/Documents/Studium/BioInfo/SS2017/Datenbanken/Projekt/american-election-tweets.csv")

election <- election%>%
  #'adding an Id as a primarykey for tweet
  mutate(Id = 1:length(election$handle))%>%
  #'count how often the # sign was used (necessary to find faulty hashtags)
  mutate(hashtagCountSign = str_count(text, pattern = "#"))%>%
  #'extract the hashtag from the tweet using a regular expression
  mutate(name = str_extract_all(text,pattern = "\\B#\\w\\w+"))%>%
  group_by(Id)%>%
  #'count how many hahstags were extracted
  mutate(hashtagCountFound = length(unlist(name)))%>%
  ungroup()

#'detect missing/faulty hashtags
#'in Total 10 times the number of extracted hashtags differed from the number of #signs used 
wrongHashtags <- which(election$hashtagCountSign != election$hashtagCountFound)
wrongHashtags <- election[wrongHashtags,]

#'check the 10 cases by hand
#'okay:52, 814,1714,3582,4766,4844,5158,5834 (stuff like #1 is not an hashtag....)
#'not okay:6112 # ISIS, 6126 # MAKE AMERICA GREAT AGAIN (unexpected white space was used in both cases)

#'rename the two faulty hashtags by hand
election$name[6112][[1]][3] <- "#ISIS"
election$name[6126][[1]][1] <- "#MakeAmericaGreatAgain"

#'extract the data for the table tweet
tweetFinal <- election%>%
  select(text,handle,retweet_count,favorite_count,time,Id)%>%
  mutate(text = as.character(text))%>%
  mutate(handle = as.character(handle))%>%
  mutate(time = ymd_hms(time))

#'reorder the tweet data
tweetFinal <- tweetFinal[,c(6,1:5)]

#'extract the data for the table contains/enthaelt
enthaeltFinal <- election%>%
  select(name,Id)%>%
  unnest(name)%>%
  #'hashtags are not case-sensitive
  mutate(name = tolower(name))%>%
  filter(name != "character(0)")

enthaeltFinal <- unique(enthaeltFinal)
#'extract the data for the table hashtag
hashtagFinal <- unique(enthaeltFinal%>%select(name))
  
## agdbs-edu01.imp.fu-berlin.de
## connect to database
pg = dbDriver("PostgreSQL")
conn = dbConnect(pg, user="postgres", password="DBS", host="agdbs-edu01.imp.fu-berlin.de", port="5432", dbname="election")

##write to tables tweet, hashtag, contains
dbWriteTable(conn = conn,name = 'hashtag', value =  hashtagFinal, row.names = F, overwrite=FALSE, append=TRUE)
dbWriteTable(conn = conn,name = 'tweet', value =  tweetFinal, row.names = F, overwrite=FALSE, append=TRUE)
dbWriteTable(conn = conn,name = 'contains', value =  enthaeltFinal, row.names = F, overwrite=FALSE, append=TRUE)
