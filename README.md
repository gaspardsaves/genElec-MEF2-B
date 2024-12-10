# genElec-MEF2-B

Collaborateurs :
    - Ibrahima Baldé-Cissé
    - Jean-Luc Maslanka
    - Gaspard Savès

Compilation :
1 - En mode normal :
    Pour compiler les fichiers C seuls : Utiliser la commande 'make -C ./codeC'
    Pour supprimer les exécutables : Utiliser la commande 'make clean -C ./codeC'

2 - En mode débug (Ce mode permet d'utiliser fsanitize afin de vérifier la libération mémoire) :
    Pour compiler les fichiers C : Utiliser la commande 'make debug -C ./codeC'
    Pour supprimer les exécutables : Utiliser la commande 'make cleandebug -C ./codeC'


Exécution :
1 - En mode normal :
    Vérifier qu'on a les droits d'exécution sur le script shell si non : 'chmod +x c-wire.sh'
    Exécution du script shell : './c-wire.sh' + paramétres
    Pour avoir le détail des paramétres possibles du script : possibilité d'utiliser l'option -h ou --help './c-wire.sh -h' ou './c-wire.sh --help'
    Pour exécuter le fichier code C séparément : ./codeC/execdef
    Le fichier de données à traiter doit se situer dans le sous-répertoire 'inputs' (--> à voir pour passer les données en param)
    ./inputs/c-wire_v25.dat
    ./inputs/c-wire_v00.dat
    
2 - En mode débug :

3 - Commun aux deux modes :
    Suppression des fichiers tampons : 'make cleanfile -C ./codeC'