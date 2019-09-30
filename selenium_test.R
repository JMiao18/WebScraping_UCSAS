## test for RSelenium
# install.packages("devtools")
devtools::install_github("ropensci/wdman")

require(wdman)

selServ <- selenium(verbose = FALSE)
selServ$process