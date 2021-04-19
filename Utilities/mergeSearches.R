#'
#' Script to Merge Search Results
#'
#'
library("readxl")
library("WriteXLS")

files <- list.files("Searches", pattern = "\\.xlsx", full.names = TRUE)
searches <-   DF <- data.frame(name = NA, desc = NA, url = NA)
for (i in 1:length(files)) {
   found <- as.data.frame(read_xlsx(files[i]))
   searches <- rbind(searches, found)
}

searches <- searches[-1,]
searches <- searches[duplicated(searches$name), ]
# Save results
WriteXLS(searches, "Searches/Merged_Searches.xlsx",
      row.names = FALSE, col.names = TRUE, na = "NA")

