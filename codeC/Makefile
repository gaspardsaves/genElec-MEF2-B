all: execdef
smartrobusnest.o: smartrobusnest.c smartrobusnest.h
	gcc -c smartrobusnest.c -o smartrobusnest.o
execdef: 
	gcc -o execdef

cleanexec:
	rm .o
	rm execdef

clean:
	rm .csv
	touch .csv