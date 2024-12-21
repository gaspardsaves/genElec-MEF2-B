# genElec-MEF2-B

**Projet C-WIRE :zap:, deuxième année de pré-ingénieur CY-Tech, semestre 1 2024-2025**

## :handshake: Collaborateurs :
**- [Ibrahima Baldé-Cissé](https://github.com/IBBC78)**  
**- [Jean-Luc Maslanka](https://github.com/JEAN-LUC7)**  
**- [Gaspard Savès](https://github.com/gaspardsaves)**

## Description du projet :
[:scroll: Lire le sujet et le cahier des charges du projet](Projet_C-Wire_preIng2_2024_2025-v1.4-1.pdf)  
[:memo: Lire le rapport de réalisation du projet](rapport-projet-c-wire-mef2-b.pdf)  
[:memo: Lire le carnet de bord des collaborateurs](carnet-de-bord.txt)  

Ce projet réalise un traitement ciblé des données d'un réseau de transport d'électricité.  
![Aperçu d'un réseau électrique](reseau.png)  
Après passage en entrée des données d'un réseau de transport d'électricité, le script permet d'analyser les postes électriques (stations HV-B et HV-A et postes LV) ainsi que leurs consommations respectives afin de savoir quelle proportion de leur énergie est consommée par les entreprises et les particuliers et s'ils sont en situation de sous-charge ou de surcharge. Les données peuvent également être triées en fonction de la centrale sur laquelle les postes électriques sont branchés.

## Pré-requis :
- Installation de l'utilitaire gnuplot pour la réalisation des histogrammes  
`gnuplot --version` pour vérifier s'il est installé sur votre machine  
Son installation est facultative mais sans lui vous ne pourrez pas tester l'ensemble des fonctionnalités.  
--> S'il n'est pas installé l'exécution du script se fera correctement et un message vous annoncera que les histogrammes n'ont pas pu être réalisé mais les fichiers csv de sortie auront été générés correctement.

## Exécution globale du projet :
Vérifier la possession des droits d'exécution sur le script shell si ce n'est pas le cas : `chmod +x c-wire.sh`  
Exécution du script shell : `./c-wire.sh` + paramètres  
--> Pour avoir le détail des paramétres possibles du script : possibilité d'utiliser l'option `-h` ou `--help` (commandes `./c-wire.sh -h` ou `./c-wire.sh --help` afin d'afficher l'aide)  
Un petit fichier de données permettant d'utiliser le programme se trouve dans le dossier *inputs* pour l'utiliser passer `./inputs/c-wire_v00.dat` en premier argument du script. Avec ce fichier de données, peu importe les paramètres choisis, les temps de traitements sont de l'ordre de l'instantané.  
Si vous utilisez la v25 (9 millions de lignes) le temps de traitement maximum pour `lv all` avec la génération des graphiques est de l'ordre de 12 secondes sur nos machines comme sur les machines de l'école.  

**En fin d'exécution**  
Un fichier `make.log` permet de constater les retours des commandes de compilation.  
Le répertoire `outputs` contient les fichiers `.csv` générés lors de l'exécution.  
:bar_chart: Le répertoire `graphs` contient les graphiques générés lors de l'exécution.  

## Structure du projet :
### Répertoires :
- Le répertoire `code C` contient l'ensemble des fichiers C et headers ainsi que le makefile du projet  
- Le répertoire `graphs` contient, après exécution, les histogrammes générés par le programme  
- Le répertoire `inputs` contient le petit fichier de démonstration (v00) vous pouvez y copier votre fichier de données  
- Le répertoire `outputs` contient, après exécution, les fichiers `.csv` générés par le programme  
- Le répertoire `tests` contient des exemples de fichiers et histogrammes de sortie pour la v00 et la v25 (Voir le [rapport de réalisation du projet](rapport-projet-c-wire-mef2-b.pdf) pour plus de détails)  
- Le répertoire `tmp` contient, pendant l'exécution, les éventuels fichiers tampons générés  

### A la racine : 
`c-wire.sh` est le script shell principal du projet  
`carnet-de-bord.txt` est le fichier de suivi des collaborateurs, il nous permettait de voir le travail menés par les autres.  
`help.txt` est le fichier contenant l'aide concernant l'exécution du script  
`Projet_C-Wire_preIng2_2024_2025-v1.4-1.pdf` est le sujet du projet  
`rapport-projet-c-wire-mef2-b.pdf` est le rapport de réalisation du projet  
`resau.png` est l'image qui s'affiche ici dans les descriptif du projet  
`script-gnuplot-lv-neg.plt` est le script gnuplot permettant la génération de l'histogramme des postes LV en surcharge  
`script-gnuplot-lv-pos.plt` est le script gnuplot permettant la génération de l'histogramme des postes LV en sous-charge  

## :hammer Makefile / Compilation :
Si vous souhaitez compiler et gérer le code C séparément cela est possible en utilisant les commandes :  
`make -C ./codeC`  l'exécutable principal s'appelle alors `execdata`  
`make ratio -C ./codeC` le deuxième exécutable s'appelle alors `execratio` (utile pour `lv all`)   
`make clean -C ./codeC` permet de supprimer les éxécutables  
`make cleanratio -C ./codeC` permet de supprimer l'exécutable ratio (utile pour `lv all`)  
`make cleanfile -C ./codeC` permet des supprimer les fichiers tampons générés lors de l'exécution  

### :hammer_and_wrench: Cible débug
Une cible débug a été prévue afin de pouvoir utiliser `fsanitize` et d'autres options de débogage comme `-Wall` et `-Wextra`  
`make debug -C ./codeC` permet de compiler en mode débug, l'exécutable s'appelle alors `execdebug`  
`make cleandebug -C ./codeC` permet de supprimer les exécutables du mode debug  
**Attention, pour pouvoir utiliser ce mode, il convient dans `c-wire.sh`, de remplacer toutes les occurences de `./codeC/execdata` par `./codeC/execdebug`, `make -C ./codeC` doit être remplacé par `make debug -C ./codeC` et `make clean -C ./codeC` par `make cleandebug -C ./codeC`**