#
# Manual, Final Check for Data Quality of FOSS4Spec.xlsx
#
library("readxl")
library("plyr")

DF <- read_excel("FOSS4Spec.xlsx")
names(DF)

# Check for duplicated entries
# Some pkgs have the same name but different case.
# Some of these are typos, some are actually 2 different pkgs.
any(duplicated(tolower(DF$name)))
which(duplicated(tolower(DF$name)))
any(duplicated(DF$name))

# Check for language misspellings, mis-classifications
count(DF$language)

# Check for inconsistencies in focus
unique(DF$focus)
count(DF$focus)
