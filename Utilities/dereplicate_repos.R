#'
#' Dereplicate Search Results
#'
#' Remove repos found by a topic search if we already have them.
#' Should be run in a dedicated temporary directory containing the
#' search results.
#'
#' @param in_dir Character.  Directory containing file(s) with extension `.xlsx`.
#'        These files contain the new/fresh search results.
#' @param ref_file Character.  Path to a `.xlsx` file containing already identified
#'        repos of interest. 
#' @param out_file Character. Path to write out results.
#'

dereplicate_repos <- function(in_dir, ref_file, out_file) {

  # remove the out_file file from a previous run if it is present
  if (file.exists(out_file)) file.remove(out_file)
  
  # read in the reference file
  ref <- as.data.frame(readxl::read_xlsx(ref_file))
  cat("The reference file contains", nrow(ref), "entries\n")

  # get the files with new results & merge tem
  new_files <- list.files(in_dir, pattern = "\\.xlsx", full.names = TRUE)
  for (i in 1:length(new_files)) {
    new <- as.data.frame(readxl::read_xlsx(new_files[i]))
    cat("Result file", new_files[i], "has", nrow(new), "entries\n")
    if (i == 1L) glob <- new
    if (i > 1L) glob <- merge(glob, new, all = TRUE)
  }
  
  cat("After merging the new files we have", nrow(glob), "entries\n")
  
  # merge the new with the existing results
  glob <- merge(glob, ref, all = TRUE)
  cat("After merging the new files with the existing results we have", nrow(glob), "entries\n")
  
  # do some clean up
  glob <- glob[order(glob$name),]
  toss <- which(duplicated(glob$name))
  glob <- glob[-toss,]
  cat("After removing duplicate rows we have", nrow(glob), "entries\n")
  
  # Save results
  WriteXLS::WriteXLS(glob, out_file,
    row.names = FALSE, col.names = TRUE, na = "NA"
  )

  invisible(glob)
}
