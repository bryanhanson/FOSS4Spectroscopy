This repo drives the creation of the [FOSS for Spectroscopy](https://bryanhanson.github.io/FOSS4Spectroscopy/) page.

## I have info to contribute, but I'm not familiar with Github pull requests

If you have information to add to the table, or corrections, and are not familiar with pull requests on `Github`, [file an issue](https://github.com/bryanhanson/FOSS4Spectroscopy/issues) and we'll gladly update the site with your information.

## I have info to contribute, and I know how to do a pull request on Github

If you wish to contribute to improving the content, appearance or performance of the table, please file a pull request.

* `FOSS4Spec.xlsx` contains the raw data -- if you have additions or corrections you can add/fix them there. I can then process the page to update it, or you can do it yourself (next point).
* `FOSS4Spectroscopy.Rmd` contains the code to process the input and check the links, if you'd like to improve or enhance the automation/display.  The `Rmd` file relies on a package `webutils` which can be found [here](https://github.com/bryanhanson/webutils) and is not on CRAN.

## Background

See this [blog post](https://chemospec.org/2021/04/19/p20/) for details about searching for spectroscopy packages automatically to find the raw material that goes into this site.

In the past there have been automatic updates using both Travis and Github Actions.  However, this proved to be difficult to maintain.  Currently, I try to do a major update 2-3 times a year, and minor updates whenever needed.   When local changes are pushed, items in the `/docs` folder are deployed to the `gh-pages` site where the general public views the page.  

