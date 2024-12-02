# genElec-MEF2-B

Collaborateurs :
    - Ibrahima Baldé-Cissé
    - Jean-Luc Maslanka
    - Gaspard Savès

Compilation :
Pour compiler les fichiers C seuls : Utiliser la commande 'make -C ./codeC'
Pour supprimer les exécutables : Utiliser la commande 'make cleanexec -C ./codeC'

Exécution :
Vérifier qu'on a les droits d'exécution sur le script shell si non : 'chmod +x c-wire.sh'
Exécution du script shell : './c-wire.sh' + paramétres
Pour avoir le détail des paramétres possibles du script : possibilité d'utiliser l'option -h ou --help './c-wire.sh -h' ou './c-wire.sh --help'
Pour exécuter le fichier code C séparément : ./codeC/execdef
Le fichier de données à traiter doit se situer dans le sous-répertoire 'inputs' (--> à voir pour passer les données en param)
Suppression des fichiers tampons : 'make clean -C ./codeC'