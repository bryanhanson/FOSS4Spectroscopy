#'
#' Supervising Script to Search Github Repos for Topics
#'
#' Be sure to authenticate first
#'
library("jsonlite")
library("httr")
library("stringr")
library("readxl")
library("WriteXLS")

source("Utilities/searchTopic.R")
source("Utilities/searchRepos.R")

# Get the names of packages we already know about
known <- as.data.frame(read_xlsx("FOSS4Spec.xlsx"))
known <- known$name

# Search Github and remove packages already known to us
topics <- c("NMR", "EPR", "ESR", "UV", "VIS", "NIR", "IR", "FT-IR", "Raman", "XRF", "LIBS", "XAS", "spectrophotometry")
res <- searchRepos(topics, "github_token", known.repos = known)

# Save results with a useful filename
file_name <- paste(topics, collapse = "_")
file_name <- paste("Search", file_name, sep = "_")
file_name <- paste(file_name, "xlsx", sep = ".")
file_name <- paste("Searches", file_name, sep = "/")
WriteXLS(res, file_name,
      row.names = FALSE, col.names = TRUE, na = "NA")

# Open the pages in a browser
found <- as.data.frame(read_xlsx(file_name))

for (i in 1:nrow(found)) {
  if (grepl("^https?://", found$url[i], ignore.case = TRUE)) BROWSE(found$url[i])
}

