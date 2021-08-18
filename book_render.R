################################
### Render rmd files to book ###
################################

library(bookdown)
library(bslib)

bookdown::render_book("chapters/", 
                      bs4_book(theme = bs_theme(bootswatch = "cyborg")))

bookdown::render_book("chapters/", "bookdown::pdf_book")
