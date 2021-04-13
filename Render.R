
# Process the Rmd
# Be sure to run the GH authorization if working locally.

library("rmarkdown")
render("FOSS4Spectroscopy.Rmd", output_file = "docs/index.html")

