#
# Functions to find the most recent date on a web page that is not in the future
# Inspired by the Python package htmldate, but no code in common.
#

# Grab a web page and flatten to a simple character vector
flatWebPage <- function(url) {
  # User should check that this URL is valid before calling this function
  webpage <- read_html(url)
  flat <- unlist(as_list(webpage), use.names = FALSE)
}

# Any date of use would have a year.  This function will locate possible year entries
# that in turn are clues as to where to look more closely for a proper date, saving time
findYear <- function(string) {
  year_pat <- paste(2000:2030, collapse = "|")
  yearLoc <- grep(year_pat, string)
}

# Input string is a vector
# Return is always ISO 8601 format as ymd, no hms
# Never return a date in the future (some web sites have future events)
findDate <- function(string) {

  # Commmon items
  EngMonths <- c("January", "Jan", "February", "Feb", "March", "Mar",
                 "April", "Apr", "May", "June", "Jun", "July", "Jul",
                 "August", "Aug", "September", "Sept", "October", "Oct",
                 "November", "Nov", "December", "Dec")

  year_pat <- paste(2000:2030, collapse = "|")

  # Date patterns (add new patterns here)
  # ISO 8601 format
  iso <- '[0-9]{4}-[0-9]{2}-[0-9]{2}'
  
  # 2020/01/01
  ymd_slash_num <- '[0-9]{4}/[0-9]{2}/[0-9]{2}'

  # 2020/Jan/01 2020/January/01
  ymd_slash_eng <- paste0("(",
                        year_pat,
                        ")/(",
                        paste(EngMonths, collapse = "|"),
                        ").?/[0-9]{1,2}")

  # January 1, 2020   January 1 2020   January 1st 2020   Jan. 1st 2020   formats
  mdy_space_eng <- paste0("(",
                        paste(EngMonths, collapse = "|"),
                        ").?\\s+[0-9]{1,2}(st|nd|rd|th)?,?\\s+(",
                        year_pat,
                        ")")

  # 1 January 2020   1 January, 2020  formats
  dmy_space_eng <- paste0("[0-9]{1,2}(st|nd|rd|th)?\\s+(",
                        paste(EngMonths, collapse = "|"),
                        ").?\\s+(",
                        year_pat,
                        ")")

  # Combine all the patterns here (add new pattern names here)
  all_pats <- c(iso, ymd_slash_num, ymd_slash_eng, mdy_space_eng, dmy_space_eng)

  # Find the date(s)
  mydate <- rep(NA_character_, length(string))

  for (i in 1:length(all_pats)) {
    tmp <- str_extract(string, all_pats[i]) # Finds just the first date, but unlikely to be more than one
    mydate <- ifelse(is.na(tmp), mydate, tmp) # Will overwrite results found by earlier patterns - ?
  }

  # Clean things up
  mydate <- na.omit(mydate)
  if (length(mydate) == 0L) return(NA_character_) # a way to detect nothing found
  attributes(mydate) <- NULL # remove omit tags
  mydate <- unique(mydate) # format could be nearly anything at this point
  # add new pattern formats next line
  mydate <- parse_date_time(mydate, orders = c("ymd", "b!dy", "db!y"))
  mydate <- date(mydate) # just Y-M-D as ISO 8601, no time
  mydate <- mydate[order(as.Date(mydate), decreasing = TRUE)]
  mydate <- mydate[mydate <= today()] # no dates in the future!
  mydate <- mydate[1]
}

# Tests
# turl <- "http://www.validnmr.com/w/index.php?title=Chemometrics"
# turl <- "https://www.schneier.com/" # good test site
# turl <- "https://www.r-bloggers.com/"
# fweb <- flatWebPage(turl)
# res <- findYear(fweb) # need to see if length is zero
# ans <- findDate(fweb[res])
# ans

# Future development: unit tests, additional languages



