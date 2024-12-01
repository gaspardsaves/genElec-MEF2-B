all: execdef
smartrobusnest.o: smartrobusnest.c smartrobusnest.h
	gcc -c smartrobusnest.c -o smartrobusnest.o
avl.o: avl.c avl.h structures.h
	gcc -c avl.c -o avl.o
execdef: avl.o smartrobusnest.o
	gcc avl.o smartrobusnest.o -o execdef
	echo "Compilation effectuée avec succès"

cleanexec:
	rm smartrobusnest.o avl.o
	rm execdef
	echo "Nettoyage des exécutables terminé"

clean:
	rm ../tmp/buff-lv.dat ../tmp/buff-hva.dat ../tmp/buff-hvb.dat
	echo "Nettoyage des fichiers tampons terminé"