#'
#' Dereplicate Search Results
#'
#' Remove repos found in a topic search if we already have them.
#' Matlab files are removed at this stage.
#'
#' @param in_dir Character.  Directory containing file(s) with extension `.xlsx`.
#'        Files must have columns labeled `name`, `repository` and `description`.
#' @param out_file Character. Path to write out results.
#'

dereplicate_repos <- function(in_dir, out_file) {

  known <- list.files(in_dir, pattern = "\\.xlsx", full.names = TRUE)
  searches <- data.frame(name = NA, repository = NA, description = NA)
  for (i in 1:length(known)) {
    found <- as.data.frame(readxl::read_xlsx(known[i]))
    found <- found[, c("name", "repository", "description")]
    searches <- rbind(searches, found)
  }

  # Remove duplicates & any Matlab items
  searches <- searches[-1, ]
  searches <- searches[!duplicated(searches$name), ]
  matlab <- grepl("Matlab|matlab|MATLAB", searches$description)
  searches <- searches[!matlab, ]

  # Save results
  WriteXLS::WriteXLS(searches, out_file,
    row.names = FALSE, col.names = TRUE, na = "NA"
  )
}
