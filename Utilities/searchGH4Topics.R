#'
#' Search Github Repos for Selected Topics
#'
#' Search Github repositories for selected topics
#'
#' @param topics Character.  A vector of topics to search.
#' @param browse Logical.  Shall the repos found be opened in a browser?
#' @return Invisibly, a data frame containing the repo data.
#'
searchGH4Topics <- function(topics = NULL, browse = TRUE) {

  if (is.null(topics)) stop("You must provide topics to search")

  if (!requireNamespace("httr", quietly = TRUE)) {
    stop("You need to install package httr to use this function")
  }
  if (!requireNamespace("jsonlite", quietly = TRUE)) {
    stop("You need to install package jsonlite to use this function")
  }
  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("You need to install package stringr to use this function")
  }
  if (!requireNamespace("readxl", quietly = TRUE)) {
    stop("You need to install package readxl to use this function")
  }
  if (!requireNamespace("WriteXLS", quietly = TRUE)) {
    stop("You need to install package WriteXLS to use this function")
  }

  # Make sure we have a token to avoid rate limits
  # The token is generated interactively via "Web Application Flow",
  # and is deposited in the local workspace with the name github_token
  # before rendering this document
  # See developer.github.com/apps/building-oauth-apps/authorizing-oauth-apps/#web-application-flow
  # This token has classes 'Token2.0', 'Token', 'R6' <Token2.0>
  local_token_found <- FALSE
  local_token_found <- exists("github_token")
  if (local_token_found) set_config(config(token = github_token))
  if (!local_token_found) stop("Did not find a local token")

  # Get the names of packages we already know about
  known <- as.data.frame(readxl::read_xlsx("../FOSS4Spec.xlsx"))
  known <- known$name

  # Search Github and remove packages already known to us
  res <- searchRepos(topics, "github_token", known.repos = known)

  # Save results with a useful filename
  file_name <- paste(topics, collapse = "_")
  file_name <- paste("Search", file_name, sep = "_")
  file_name <- paste(file_name, "xlsx", sep = ".")
  file_name <- paste("../Searches", file_name, sep = "/")
  WriteXLS::WriteXLS(res, file_name,
    row.names = FALSE, col.names = TRUE, na = "NA"
  )
  # Open the pages in a browser
  if (browse) {
	  for (i in 1:nrow(res)) {
	    if (grepl("^https?://", res$url[i], ignore.case = TRUE)) BROWSE(res$url[i])
	  }
  }
  invisible(res)
}
