# Classic compilation
all: execdata
smartrobusnest.o: smartrobusnest.c smartrobusnest.h
	gcc -c smartrobusnest.c -o smartrobusnest.o
avl.o: avl.c avl.h structures.h
	gcc -c avl.c -o avl.o
execdata: avl.o smartrobusnest.o
	gcc avl.o smartrobusnest.o -o execdata
	echo "Compilation effectuée avec succès"smartrobusnest

# Compilation of the ratio part
ratio: execratio
execratio: lv_all.c
	gcc -o execratio lv_all.c


# Compilation in debug mode using fsanitize and other options to check memory allocation and other errors
debug: execdebug
smartrobusnest1.o: smartrobusnest.c smartrobusnest.h
	gcc -c -Wall -Wextra -g -fsanitize=address smartrobusnest.c -o smartrobusnest1.o
avl1.o: avl.c avl.h structures.h
	gcc -c -Wall -Wextra -g -fsanitize=address avl.c -o avl1.o
execdebug: avl1.o smartrobusnest1.o
	gcc -fsanitize=address avl1.o smartrobusnest1.o -o execdebug
	echo "Compilation effectuée avec succès en mode débug"

# Delete execution files
clean:
	rm smartrobusnest.o avl.o
	rm execdata execratio
	echo "Nettoyage des exécutables terminé"

# Delete execution files in debug mode
cleandebug:
	rm smartrobusnest1.o avl1.o
	rm execdebug
	echo "Nettoyage des exécutables en mode debug terminé"

# Delete buffer files
cleanfile:
	rm -f ../tmp/*.csv
	echo "Nettoyage des fichiers tampons terminé"