#'
#' Search for Topics on Github
#'
#' @param topic Character.  Length one.
#'        Currently, only a single topic like "NMR" can be used.  Although the
#'        Github documentation implies that a Boolean query string such as
#'        "NMR+OR+IR" can be used, I cannot make it work.
#'
#' @param token Character.  Github authentification token.
#'
searchTopic <- function(topic, token) {

  # Helper Functions
  checkSuccess <- function(j) return(j$message) # see checkAccess over in getGHdates

  reportAccessIssue <- function(response) {
    # https://docs.github.com/en/rest/reference/rate-limit
    message("\nI tried: ", response$url)
    cat("API access type:", response$headers$"x-ratelimit-resource", "\n")
    cat("API access limit:", response$headers$"x-ratelimit-limit", "\n")
    cat("API access used:", response$headers$"x-ratelimit-used", "\n")
    cat("API access remaining:", response$headers$"x-ratelimit-remaining", "\n")
    reset <- as.integer(response$headers$"x-ratelimit-reset")
    reset <- as.POSIXct(reset, origin = "1970-01-01", tz = "UCT")
    cat_string <- paste("Access resets at:", reset, "UTC\n", sep = " ")
    cat(cat_string)
  }

  extractFields <- function(x) {
    ni <- lengths(x["items"])
    DF <- data.frame(name = NA, desc = NA, url = NA)
    # sometimes length(x[[3]]) comes back as zero, so skip it
    # this occurs as the last page on some queries
    for (i in 1:ni) {
      if (length(x[[3]]) == 0L) break
      tmp <- unlist(x[[3]][[i]][c("name", "description", "html_url")], use.names = FALSE)
      DF <- rbind(DF, tmp)
    }
    DF[2:nrow(DF), ]
  }

  getPageCount <- function(response) {
    link <- headers(response)$link
    pages <- unlist(stringr::str_extract_all(link, "page=[0-9]+"))
    last_page <- pages[length(pages)]
    last_page <- as.integer(stringr::str_extract(last_page, "[0-9]+"))
    # next line handles the case where there is only one page total
    if (length(last_page) == 0L) last_page <- NULL
  }

  # Access the API
  # GET is what counts against access rate
  # https://docs.github.com/en/rest/guides/traversing-with-pagination

  getResponse <- function(topic, pg, token) {
    # Set up query string (https://stackoverflow.com/a/48412541/633251)
    q_string <- paste0("https://api.github.com/search/repositories?q=topic:", topic,
      "&page=", pg)
    response <- GET(q_string, config = list(
      authenticate("bryanhanson", token),
      add_headers("Accept: application/vnd.github.mercy-preview+json")))
  }

  processResponse <- function(response) {
    json <- content(response, "text")
    json <- jsonlite::fromJSON(json, simplifyVector = FALSE) # returns a list
    if (!is.null(checkSuccess(json))) {
      reportAccessIssue(response)
      stop("Github access rate exceeded, try again later")
    }

    ans <- extractFields(json)
  }

  # End of Helper Functions

  # Main Event
  DF <- data.frame(name = NA, desc = NA, url = NA)
  resp <- getResponse(topic, pg = 1, token) # get the first page
  DF <- rbind(DF, processResponse(resp))
  pgs <- getPageCount(resp) # find out how many page(s) total are available
  if (!is.null(pgs)) {
    for (i in 2:pgs) { # get the rest of the pages
      resp <- getResponse(topic, pg = i, token)
      DF <- rbind(DF, processResponse(resp))
    }
  }
  DF[-1,]
}
