all: execdef
smartrobusnest.o: smartrobusnest.c smartrobusnest.h
	gcc -c smartrobusnest.c -o smartrobusnest.o
avl.o: avl.c avl.h structures.h
	gcc -c avl.c -o avl.o
execdef: avl.o smartrobusnest.o
	gcc avl.o smartrobusnest.o -o execdef
	echo "Compilation effectuée avec succès"

debug: execdebug
smartrobusnest.o: smartrobusnest.c smartrobusnest.h
	gcc -c smartrobusnest.c -o smartrobusnest.o
avl.o: avl.c avl.h structures.h
	gcc -c avl.c -o avl.o
execdebug: avl.o smartrobusnest.o
	gcc -fsanitize=address avl.o smartrobusnest.o -o execdebug
	echo "Compilation effectuée avec succès en mode débug"

clean:
	rm smartrobusnest.o avl.o
	rm execdef execdebug
	echo "Nettoyage des exécutables terminé"

cleandebug:
	rm smartrobusnest.o avl.o
	rm execdebug
	echo "Nettoyage des exécutables en mode debug terminé"

cleanfile:
	rm ../tmp/buff-lv.dat ../tmp/buff-hva.dat ../tmp/buff-hvb.dat
	echo "Nettoyage des fichiers tampons terminé"