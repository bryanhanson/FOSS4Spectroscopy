#'
#' Dereplicate Search Results
#'
#' Remove repos found by a topic search if we already have them.
#'
#' @param in_dir Character.  Directory containing file(s) with extension `.xlsx`.
#'        These files contain the new/fresh search results.
#' @param ref_file Character.  Path to a `.xlsx` file containing already identified
#'        repos of interest. 
#' @param out_file Character. Path to write out results.
#'

dereplicate_repos <- function(in_dir, ref_file, out_file) {

  # read in the reference file
  ref <- as.data.frame(readxl::read_xlsx(ref_file))
    print(nrow(ref))
  print(colnames(ref))
  # get the files with new results
  new_files <- list.files(in_dir, pattern = "\\.xlsx", full.names = TRUE)

  # merge each new result with the reference file
  for (i in 1:length(new_files)) {
    new <- as.data.frame(readxl::read_xlsx(new_files[i]))
    print(nrow(new))
    print(colnames(new))
    ref <- merge(ref, new, all = TRUE)
    print(nrow(ref))
  }
  
  ref <- ref[order(ref$name),]

  # Save results
  WriteXLS::WriteXLS(ref, out_file,
    row.names = FALSE, col.names = TRUE, na = "NA"
  )

  invisible(ref)
}
