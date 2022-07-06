
# Supervising Script to Search Github or PyPi.org Repos for Topics

# Be sure to run the GH authorization to get a local token if searching Github.
# See details at ?set_up_github_token

library("webu")
library("WriteXLS")

# Note: Searching PyPi.org via the API one needs to use single quoted strings
# like "'laser induced breakdown spectroscopy'" otherwise each term is searched separately,
# leading to lots of false positives.  Single quoted strings like this don't work on Github.

# PyPi search strings
nmr_topics <- c("NMR")
epr_topics <- c("EPR", "ESR")
vis_topics <- c("UV", "VIS", "spectrophotometry")
ir_topics <- c("NIR", "'FT-IR'", "FTIR") # lots of false pos re: IR comms
# Also, NIR, FT-IR, FTIR probably completely overlap
raman_topics <- c("Raman")
xrf_topics <- c("XRF", "'laser induced breakdown spectroscopy'", "XAS") # cannot use LIBS as it returns 1,000+ results
all_topics <- c(nmr_topics, epr_topics, vis_topics, ir_topics, raman_topics, xrf_topics)

res_pypi <- search_pypi_for_topics(all_topics, browse = FALSE)
res_pypi2 <- res_pypi[!duplicated(res_pypi),]
WriteXLS::WriteXLS(res_pypi2, "pypi_search.xlsx", row.names = FALSE, col.names = TRUE, na = "NA")

# Github search strings
nmr_topics <- c("NMR")
epr_topics <- c("EPR", "ESR")
vis_topics <- c("UV", "VIS", "spectrophotometry")
ir_topics <- c("NIR", "IR", "FT-IR", "FTIR") # lots of false pos re: IR comms
raman_topics <- c("Raman")
xrf_topics <- c("XRF", "LIBS", "XAS")
all_topics <- c(nmr_topics, epr_topics, vis_topics, ir_topics, raman_topics, xrf_topics)

res_gh <- search_github_for_topics("'FT-IR'", browse = FALSE)



