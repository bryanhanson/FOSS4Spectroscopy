#'
#' Search All Github Repositories for Topics of Interest
#'
#' @param topics Character.  Strings to search on Github.
#'        Currently, only a single topic like "NMR" can be used.  Although the
#'        Github documentation implies that a Boolean query string such as
#'        "NMR+OR+IR" can be used, I cannot make it work.
#'
#' @param token Character.  Github authentification token.
#'
#' @param known.repos Character.  A list of known repo names.  If these names
#'        are in the list found on Github, they are removed leaving only new
#'        repo candidates.  If the repo has a different name from the package
#'        contained within, this should become clear during manual vetting.
#' 
searchRepos <- function(topics, token, known.repos = NULL) {

  DF <- data.frame(name = NA, desc = NA, url = NA)

  for (i in 1:length(topics)) {
    DF2 <- searchTopic(topics[i], token)
    DF <- rbind(DF, DF2)
  }

  DF <- unique(DF[2:nrow(DF),])
  DF <- DF[-1,]

  if (!is.null(known.repos)) {
    "%nin%" <- Negate("%in%")
    keep <- DF$name %nin% known.repos
    DF <- DF[keep,]
  }

  DF
}
