#'
#' Merge Search Results
#'
#'

mergeSearches <- function() {
  files <- list.files("../Searches", pattern = "\\.xlsx", full.names = TRUE)
  searches <- data.frame(name = NA, desc = NA, url = NA)
  for (i in 1:length(files)) {
    found <- as.data.frame(readxl::read_xlsx(files[i]))
    searches <- rbind(searches, found)
  }

  # Remove duplicates & any Matlab items
  searches <- searches[-1, ]
  searches <- searches[!duplicated(searches$name), ]
  matlab <- grepl("Matlab|matlab|MATLAB", searches$desc)
  searches <- searches[!matlab, ]

  # Save results
  WriteXLS::WriteXLS(searches, "../Searches/Merged_Searches.xlsx",
    row.names = FALSE, col.names = TRUE, na = "NA"
  )
}
