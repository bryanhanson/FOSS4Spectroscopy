This repo drives the creation of the [FOSS for Spectroscopy](https://bryanhanson.github.io/FOSS4Spectroscopy/) page.

If you have information to add to the table, or corrections, and are not familiar with `R`, [file an issue](https://github.com/bryanhanson/FOSS4Spectroscopy/issues) and we'll update the site.

If you wish to contribute to improving the content, appearance or performance of the table, please file a pull request.  The file `FOSS4Spec.xlsx` contains the raw data -- if you have additions or corrections you can add/fix them there. `FOSS4Spectrscopy.Rmd` contains the code to process the input and check the links, if you'd like to improve or enhance the automation/display.

Currently the site is updated automatically by Github Actions upon each push.  It also updates weekly via a CRON job.  Items in the `/docs` folder are deployed to the Git pages site where the general public views the page.
