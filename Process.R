# Process the Rmd after (hopefully) gaining access to Github
# -- The Rmd needs access due to GET calls to api.github.com
# -- Authenticating properly allows GET queries up to 5K/hr otherwise 60/hr
# -- This script proceeds either way, so it can work locally or on T-CI

# Try to retrieve the token and if succsesful, prep the access string & login
# See https://developer.github.com/v3/#authentication
token_found <- FALSE
token <- Sys.getenv("TRAVIS_CI")
if (token != "") token_found <- TRUE # doesn't mean it's the right token however!
if (!token_found) message("Could not retrieve token - GET calls will be rate-limited by Github")
if (token_found) {
  gh_access_string <- paste("bryanhanson:", token, " https://api.github.com/bryanhanson", sep = "")
  response <- system2("curl", args = c("-u", gh_access_string), stdout = TRUE, stderr = TRUE)
  if (any(grepl("Bad credentials", response))) message("Github access denied; perhaps the token was wrong") 
}
	
# Now process the Rmd
library("rmarkdown")
render("FOSS4Spectroscopy.Rmd", output_file = "docs/index.html")

