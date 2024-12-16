# genElec-MEF2-B

**Projet C-WIRE :zap:, deuxième année de pré-ingénieur CY-Tech, semestre 1 2024-2025**

## :handshake: Collaborateurs :
**- [Ibrahima Baldé-Cissé](https://github.com/IBBC78)**  
**- [Jean-Luc Maslanka](https://github.com/JEAN-LUC7)**  
**- [Gaspard Savès](https://github.com/gaspardsaves)**

## Description du projet :
[:scroll: Lire le sujet](Projet_C-Wire_preIng2_2024_2025-v1.4-1.pdf)  
[:memo: Lire le carnet de bord des collaborateurs](carnet-de-bord.txt)  

Ce projet réalise un traitement ciblé des données d'un réseau de transport d'électricité.  
![Aperçu d'un réseau électrique](reseau.png)  
Après passage en entrée des données d'un réseau de transport d'électricité, le script permet d'analyser les postes électriques (centrales, stations HV-B et HV-A et postes LV) ainsi que leurs consommation respectives afin de savoir quelle proportion de leur énergie est consommée par les entreprises et les particuliers et s'ils sont en situation de sous-capacité ou de surcapacité.

## Pré-requis :
- Installation de l'utilitaire gnuplot

## Exécution globale du projet :
Vérifier la possession des droits d'exécution sur le script shell si ce n'est pas le cas : `chmod +x c-wire.sh`  
Exécution du script shell : `./c-wire.sh` + paramètres  
--> Pour avoir le détail des paramétres possibles du script : possibilité d'utiliser l'option `-h` ou `--help` commandes `./c-wire.sh -h` ou `./c-wire.sh --help` afin d'afficher l'aide  
Un petit fichier de données permettant d'utiliser le programme se trouve dans le dossier *inputs* pour l'utiliser passer `./inputs/c-wire_v00.dat` en premier argument du script. Avec ce fichier de données, peu importe les paramètres choisis, les temps de traitements sont de l'ordre de l'instantané.  
Si vous utilisez la v25 (9 millions de lignes) le temps de traitement maximum, sur nos machines, pour `lv all` est de l'ordre de 12 secondes et 10 secondes sur les machines de l'école.  

**En fin d'exécution**  
Un fichier `make.log` permet de constater les retours des commandes de compilation.  
Le répertoire `outputs` contient les fichiers `.csv` générés lors de l'exécution.  
:bar_chart: Le répertoire `graphs` contient les graphiques générés lors de l'exécution.  


## Makefile / Compilation :
Si vous souhaitez compiler et gérer le code C séparément cela est possible en utilisant les commandes :  
`make -C ./codeC`  l'exécutable principal s'appelle alors `execdata`  
`make ratio -C ./codeC` le deuxième exécutable s'appelle alors `execratio`  
`make clean -C ./codeC` permet de supprimer les éxécutables  
`make cleanratio -C ./codeC` permet de supprimer l'exécutable ratio  
`make cleanfile -C ./codeC` permet des supprimer les fichiers tampons générés lors de l'exécution  

### :hammer_and_wrench: Cible débug
Une cible débug a été prévue afin de pouvoir utiliser fsanitize et d'autres options de débogage.  
`make debug -C ./codeC` permet de compiler en mode débug, l'exécutable s'appelle alors `execdebug`  
`make cleandebug -C ./codeC` permet de supprimer les exécutables du mode debug  
**Attention, pour pouvoir utiliser ce mode il convient de remplacer dans `c-wire.sh` toutes les occurences de `./codeC/execdata` par `./codeC/execdebug`, `make -C ./codeC` doit être remplacé par `make debug -C ./codeC` et `make clean -C ./codeC` par `make cleandebug -C ./codeC`**