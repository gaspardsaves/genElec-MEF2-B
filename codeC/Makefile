# Classic compilation
all: execdata
smartrobusnest.o: smartrobusnest.c smartrobusnest.h
	gcc -c smartrobusnest.c -o smartrobusnest.o
avl.o: avl.c avl.h smartrobusnest.h structures.h
	gcc -c avl.c -o avl.o
maintreatment.o: maintreatment.c maintreatment.h avl.h smartrobusnest.h structures.h
	gcc -c maintreatment.c -o maintreatment.o
execdata: smartrobusnest.o avl.o maintreatment.o
	gcc smartrobusnest.o avl.o maintreatment.o -o execdata

# Compilation of the lv ratio part
ratiolv: execratiolv
execratiolv: lvall.c
	gcc -o execratiolv lvall.c

# Compilation in debug mode using fsanitize and other options to check memory allocation and other errors
debug: execdebug
smartrobusnest1.o: smartrobusnest.c smartrobusnest.h
	gcc -c -Wall -Wextra -g -fsanitize=address smartrobusnest.c -o smartrobusnest1.o
avl1.o: avl.c avl.h structures.h
	gcc -c -Wall -Wextra -g -fsanitize=address avl.c -o avl1.o
maintreatment1.o: maintreatment.c maintreatment.h avl.h smartrobusnest.h structures.h
	gcc -c -Wall -Wextra -g -fsanitize=address maintreatment.c -o maintreatment1.o
execdebug: smartrobusnest1.o avl1.o maintreatment1.o
	gcc -fsanitize=address smartrobusnest1.o avl1.o maintreatment1.o -o execdebug
	echo "Compilation effectuée avec succès en mode débug"

# Delete execution files
clean:
	rm smartrobusnest.o avl.o maintreatment.o
	rm execdata

cleanratiolv:
	rm execratiolv

# Delete execution files in debug mode
cleandebug:
	rm smartrobusnest1.o avl1.o maintreatment1.o
	rm execdebug
	echo "Nettoyage des exécutables du mode debug terminé"

# Delete buffer files
cleanfile:
	rm -f ../tmp/*.csv