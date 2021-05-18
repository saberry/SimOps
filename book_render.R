################################
### Render rmd files to book ###
################################



bookdown::render_book("chapters/", "bookdown::tufte_html_book")

bookdown::render_book("chapters/", "bookdown::pdf_book")
