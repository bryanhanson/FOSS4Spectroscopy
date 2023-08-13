#'
#' Step through a list of candidate packages in the R console
#'
#' An alternative to manual editing of the Excel file
#'
library("readxl")

review_candidates <- function(file) {
  DF <- as.data.frame(read_excel(file))
  cat("Press ESC to stop reviewing (data is lost!)\n\n")
  toss <- c()
  for (i in 1:nrow(DF)) {
  	print(DF[i,1:2])
  	ans <- readline("Keep this entry? Return = yes, n = no ")
  	if (ans == "n") toss <- c(toss, i)
  }

  DF <- DF[-toss,]
  return(DF)
}
