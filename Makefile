.PHONY: all clean report

all:
	# remember to put the code cachanges in the individual rules
	#Rscript code/01-load_clean.R --file_path=data/original/titanic.csv --output_path=data/clean/titanic_clean.csv
	#Rscript code/03-model.R --file_path=data/clean/titanic_clean.csv --output_path=output/model.RDS
	#Rscript code/04-analyze.R --model=output/model.RDS --output_coef=output/coef.csv --output_fig=output/fig.png
	make clean
	make docs/index.html

data/clean/titanic_clean.csv: code/01-load_clean.R data/original/titanic.csv
	Rscript code/01-load_clean.R --file_path=data/original/titanic.csv --output_path=data/clean/titanic_clean.csv

output/model.RDS: code/03-model.R data/clean/titanic_clean.csv
	Rscript code/03-model.R --file_path=data/clean/titanic_clean.csv --output_path=output/model.RDS

output/coef.csv output/fig.png: code/04-analyze.R output/model.RDS
	Rscript code/04-analyze.R --model=output/model.RDS --output_coef=output/coef.csv --output_fig=output/fig.png

docs/index.html: index.qmd output/coef.csv output/fig.png
	quarto render
	touch docs/.nojekyll 

report:
	make docs/index.html

clean:
	rm -f output/*
	rm -f data/clean/*
	rm -f index.html
	rm -f *.pdf
	rm -rf docs/*
