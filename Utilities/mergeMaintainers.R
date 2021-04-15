# Automatically get CRAN maintainers of F4S Entries
library("readxl")
library("WriteXLS")

pkglist <- tools::CRAN_package_db()
m_info <- pkglist[, c("Package", "Maintainer")]
names(m_info) <- c("name", "maintainer")
# m_info[grepl("ChemoSpec", m_info$name),] # check that the info is there

DF <- read_excel("FOSS4Spec.xlsx")
DF <- as.data.frame(DF)

for (i in 1:nrow(DF)) {
  pkg <- DF[i, "name"]
  pkg <- paste("^", pkg, "$", sep = "")
  maint <- m_info[grepl(pkg, m_info$name), "maintainer"]
  # m_info doesn't know about non-CRAN pkgs, so character(0) is returned
  if (length(maint != 0L)) DF[i, "maintainer"] <- maint
}

DF[,c("name", "language", "maintainer")] # looks good

WriteXLS(DF, "FOSS4Spec.xlsx",
      row.names = FALSE, col.names = TRUE, na = "NA",
      BoldHeaderRow = TRUE, AdjWidth = TRUE)


