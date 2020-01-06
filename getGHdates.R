#'
#' Get the Most Recent Commit or Issue Date from a Github Repository
#'
getGHdates <- function(url, what = "commits") { # Not vectorized

	# There is a limit of how often you can hit GH ...
	# We will check to see if we are denied for this reason
	# https://developer.github.com/v3/#rate-limiting
	
	if (!what %in% c("commits", "issues")) stop("Fail")
	
	if (!grepl("github\\.com", url)) return(NA_character_)
	
	if (!requireNamespace("httr", quietly = TRUE)) {
		stop("You need to install package httr to use this function")
		}

	if (!requireNamespace("lubridate", quietly = TRUE)) {
		stop("You need to install package lubridate to use this function")
		}

	if (!requireNamespace("jsonlite", quietly = TRUE)) {
		stop("You need to install package jsonlite to use this function")
		}
		
  # Helper Functions
  checkAccess <- function(j) return(j$message) # may need to refine this a bit
  commitDate <- function(j) return(j$commit$author$date)
  issueDate <- function(j) return(j$updated_at)
  if (what == "commits") func <- commitDate
  if (what == "issues") func <- issueDate
  
  # Prep the access string
  splitURL <- unlist(strsplit(url, "/"))
  if (length(splitURL) != 5L) return(NA_character_) # repo may be missing in some cases
  owner <- splitURL[4]
  repo <- splitURL[5]
  gh_string <- paste("https://api.github.com/repos/", owner, "/", repo, "/", what, sep = "")
  
  # Access the API & extract most recent commit or issue date
  # We get back a page of (up to) 30 results
  # https://developer.github.com/v3/#pagination
  response <- GET(gh_string) # this is what counts against access rate
  json <- content(response, "text")
  json <- fromJSON(json, simplifyVector = FALSE) # returns a list
  if (!is.null(checkAccess(json))) stop("Github access rate exceeded, try again later")
  alldates <- unlist(lapply(json, func))
  alldates <- ymd_hms(alldates)
  alldates <- alldates[order(as.Date(alldates), decreasing = TRUE)]
  ghdate <- alldates[1] # ghdate = most recent commit date
  ghdate <- date(ghdate) # just Y-M-D, no time
  ghdate
}
