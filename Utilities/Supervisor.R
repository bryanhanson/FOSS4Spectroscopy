
# Supervising Script to Search GH Repos for Topics

# Be sure to run the GH authorization to get a local token.

source("searchTopic.R")
source("searchRepos.R")
source("searchGH4Topics.R")

mytopics <- c("NMR", "EPR", "ESR", "UV", "VIS", "NIR", "IR", "FT-IR", "Raman", "XRF", "LIBS", "XAS", "spectrophotometry")
mytopics <- c("NMR")
mytopics <- c("EPR", "ESR")
mytopics <- c("UV", "VIS", "spectrophotometry") # lots of false pos re: IR comms
mytopics <- c("NIR", "IR", "FT-IR") # lots of false pos re: IR comms
mytopics <- c("Raman")
mytopics <- c("XRF", "LIBS", "XAS")

res <- searchGH4Topics(mytopics, browse = FALSE)

