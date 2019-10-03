
####################### get started #####################

## details on using the `help` function
?help                         
## information about the stats package
help(package = "stats")       


## install packages
install.packages("rvest",repos = "http://cran.us.r-project.org")
install.packages("RSelenium",repos = "http://cran.us.r-project.org")
library(devtools)
install_github("skoval/deuce")


####################### import files stored online #####################

## read table directly
url <- "http://www.tennis-data.co.uk/2019/ausopen.csv"
tennis_aus <- read.csv(url)
print(dim(tennis_aus))

## download data
url <- "http://www.bls.gov/cex/pumd/data/comma/diary14.zip"
download.file(url, dest = "dataset.zip", mode = "wb") 
unzip("dataset.zip")
# assess the files contained in the .zip file which
# unzips as a folder named "diary14"
list.files("diary14")
tennis_aus[1,1:6]

## exercise: online file import 


########################## static data ##############################

## readLines
tennis_elo <- readLines("http://tennisabstract.com/reports/atp_elo_ratings.html")
tennis_elo[1:3]

## rvest
#load data
require('rvest')
url <- 'https://www.sports-reference.com/cbb/players/chris-clemons-2.html'
webpage <- read_html(url)
# organize data
data <- webpage %>%
  html_nodes(css = 'table') %>%
  html_table()
cat("Extracted", length(data), "tables, with", nrow(data[[1]]), 
    "rows and", ncol(data[[1]]), "columns \n")
head(data[[1]][1,1:8])


## exercise: rvest


## exercise: loop through static data 


########################## dynamic data ##############################

## set up RSelenium
install.packages("RSelenium",repos = "http://cran.us.r-project.org")
require(RSelenium)
binman::list_versions("chromedriver")
rD <- rsDriver(port = 5678L, browser = "chrome",chromever = "77.0.3865.40")


## example: Australia open final
# Get id element
webElem <- remDr$findElements(using = 'id', "detail")
#  Use getElementText to extract the text from this element
unlist(lapply(webElem, function(x){x$getElementText()}))[[1]]
remDr$close() # Close driver when finished

## exercise: 



########################## case study ##############################
## navigate to specific url
library(RSelenium) 
url <- "https://www.flashscore.com/team/connecticut-huskies/8rqVf3Tj/results/"
rD <- rsDriver(port = 6001L, browser = "chrome",version = "4.0.0-alpha-2",
               chromever = "77.0.3865.40")
remDr <- rD[["client"]]
remDr$navigate(url)

## extract live table
remDr$navigate(url)
webElem <- remDr$findElements(using = 'id', "live-table")
unlist(lapply(webElem, function(x){x$getElementText()}))

## one click to see more
webElem <- remDr$findElement(using = 'css selector', "#live-table > div > div > div > a")
webElem$clickElement()

## while loop to load all the "see more details"
remDr$navigate(url)
repeat{
  x <- try(click_ind <- remDr$findElement(using = 'css selector', "#live-table > div > div > div > a"),
           silent=TRUE)
  if (inherits(x, "try-error")) break
  click_ind$clickElement()
}

## extract full table
webElem <- remDr$findElements(using = 'id', "live-table")
uconn_score_all <- unlist(lapply(webElem, function(x){x$getElementText()}))

##  organize score results
uconn_score <- unlist(strsplit(uconn_score_all, split = '\n'))[-c(1:3)]

## navigate to head to head page
url <- "https://www.flashscore.com/match/IRo6KWr7/#h2h;overall"
remDr$navigate(url)

## click to load all the data, extract table elements
webElem <- remDr$findElement(using = 'css selector', 
                             "#tab-h2h-overall > div:nth-child(3) > table > tbody > tr.hid > td > a")
webElem$clickElement()
webElem <- remDr$findElement(using = 'css selector', 
                             "#tab-h2h-overall > div:nth-child(3) > table")

## organize hgead to head results
h2h <- unlist(webElem$getElementText())
h2h <- unlist(strsplit(h2h, split = '\n'))[-c(1,17,20)]
h2h <- strsplit(gsub("South Florida", "SF", h2h)," ")

## count the frequency of both team winning
win_team <- NULL
for (i in 1:length(h2h)){
  team <- h2h[[i]][c(3,4)]
  score <- as.numeric(h2h[[i]][c(5,7)])
  win_team <- c(win_team,team[which.max(score)])
}
