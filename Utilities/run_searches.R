
# Supervising Script to Search Github or PyPi.org Repos for Topics

library("webu") # ask me if you want this pkg
library("WriteXLS")

# Note 1: Searching PyPi.org via the API one needs to use single quoted strings
# like "'laser induced breakdown spectroscopy'" otherwise each term is searched separately,
# leading to lots of false positives.  Single quoted strings like this don't work on Github.

# Note 2: Searching for just "VIS" or "IR" leads to too many false positives; as it is,
# "NIR" etc gives a lot of false positives dealing with IR remote controllers.
# There are similar problems with "UV".
# Cannot use "LIBS" as it returns 1,000+ results

# Note 3: Run this in an empty folder as a place to store the results.

# No authentification needed for PyPi
# PyPi search strings
nmr_topics <- c("NMR")
epr_topics <- c("EPR", "ESR")
vis_topics <- c("UV", "UV-VIS", "spectrophotometry")
ir_topics <- c("NIR", "'FT-IR'", "FTIR")
raman_topics <- c("Raman")
xrf_topics <- c("XRF", "'laser induced breakdown spectroscopy'", "XAS")
all_topics <- c(nmr_topics, epr_topics, vis_topics, ir_topics, raman_topics, xrf_topics)

res_pypi <- search_pypi_for_topics(all_topics, browse = FALSE)
res_pypi2 <- res_pypi[!duplicated(res_pypi),]
WriteXLS::WriteXLS(res_pypi2, "pypi_search_results.xlsx", row.names = FALSE, col.names = TRUE, na = "NA")

# Be sure to run the GH authorization to get a local token if searching Github.
# See details at ?set_up_github_token

# Github search strings
nmr_topics <- c("NMR")
epr_topics <- c("EPR", "ESR")
vis_topics <- c("UV", "spectrophotometry")
ir_topics <- c("NIR", "FT-IR", "FTIR")
raman_topics <- c("Raman")
xrf_topics <- c("XRF", "LIBS", "XAS")
all_topics <- c(nmr_topics, epr_topics, vis_topics, ir_topics, raman_topics, xrf_topics)

res_gh <- search_github_for_topics(topics = all_topics, browse = FALSE, username = "bryanhanson", token = github_token)

WriteXLS::WriteXLS(res_gh, "gh_search_results.xlsx", row.names = FALSE, col.names = TRUE, na = "NA")



