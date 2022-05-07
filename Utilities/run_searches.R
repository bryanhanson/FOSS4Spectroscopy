
# Supervising Script to Search Github Repos for Topics

# Be sure to run the GH authorization to get a local token.

library("ghutils")
library("WriteXLS")

nmr_topics <- c("NMR")
epr_topics <- c("EPR", "ESR")
vis_topics <- c("UV", "VIS", "spectrophotometry") # lots of false pos re: IR comms
ir_topics <- c("NIR", "IR", "FT-IR") # lots of false pos re: IR comms
raman_topics <- c("Raman")
xrf_topics <- c("XRF", "LIBS", "XAS")

res <- search_github_for_topics(mytopics, browse = FALSE)

# Save results with a useful filename
WriteXLS::WriteXLS(res, file_name, row.names = FALSE, col.names = TRUE, na = "NA")



