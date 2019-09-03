HTML_FILES = slides.html

all: $(HTML_FILES)

clean: 
	rm -f $(HTML_FILES) 

%.html: %.Rmd
	Rscript -e 'rmarkdown::render("$<")'
