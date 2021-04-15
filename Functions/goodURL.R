
goodURL <- function(url, ...) {
  good <- tryCatch(
  # main event / { } enclose the expr (1st argument)
  {
  status <- status_code(GET(url, ...))
  good <- FALSE
  if (status == 200L) good <- TRUE
  good # essentially the return value if no error or warning
  },
  # if an error occurs
  error = function(cond) {
    good <- FALSE
  },
  # if a warning occurs
  warning = function(cond) {
    good <- FALSE
  }
  
  ) # end of tryCatch
  return(good)
}


# see ?handle_setopt
# see https://stackoverflow.com/q/37367918/633251
# "https://ciojlajdo.com"
#  set_config(timeout(1)) # this works
# goodURL("https://httpbin.org/delay/3", config(timeout = 4))
#  "https://bitbucket.org/aphalo/photobiology/src/master/" # returns 401

