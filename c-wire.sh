#!/bin/bash

# Parameters analysis

    # Check if the user need help
    for arg in "$@"; do
        if [[ "$arg" == "-h" || "$arg" == "--help" ]] ; then
            echo "Option d'aide détectée"
            cat "help.txt"
            exit 101
        fi
    done

    # Checking the minimum number of arguments
    if [[ $# -lt 3 ]] ; then
        echo "Nombre d'arguments insuffisant"
        echo "Utilisez -h ou --help pour afficher l'aide."
        exit 102
    fi

    # Checking the maximum number of arguments
    if [[ $# -gt 4 ]] ; then
        echo "Nombre d'arguments trop important"
        echo "Utilisez -h ou --help pour afficher l'aide."
        exit 103
    fi

    # Assignement and checking consistency of arguments
        # Adress of the input file
        #inputFile="./inputs/c-wire_v00.dat"
        #inputFile="./inputs/c-wire_v25.dat"
        inputFile="$1"

        # Checking the existence and the possibility of reading the file
        if [[ ! ( -f "$inputFile" ) ]] ; then
            echo "Le fichier de données n'existe pas à cet emplacement"
            exit 104
        elif [[  ! ( -r "$inputFile" ) ]] ; then
            echo "Droit de lecture manquant sur ce fichier."
            echo "Veuillez corriger les permissions et réitérer la demande."
            exit 105
        fi

        # Type of electric post to be treated (hvb, hva, lv)
        typeStation="$2"

        # Checking validity of the second argument
        if [[ "$typeStation" != "hvb" && "$typeStation" != "hva" && "$typeStation" != "lv" ]] ; then
            echo "Type de poste électrique invalide"
            echo "Utilisez -h ou --help pour afficher l'aide."
            exit 106
        fi

        # Type of consumer to be treated (comp, indiv, all)
        typeCons="$3"

        # Checking validity of the third argument
        if [[ "$typeCons" != "comp" && "$typeCons" != "indiv" && "$typeCons" != "all" ]] ; then
            echo "Type de consommateur invalide"
            echo "Utilisez -h ou --help pour afficher l'aide."
            exit 107
        fi

        # Checking argument combinations
        if [[ "$typeStation" == "hvb" && "$typeCons" != "comp" ]] ; then
            echo "La station HV-B n'a pour consommateur que des entreprises (argument 'comp')"
            echo "Utilisez -h ou --help pour afficher l'aide."
            exit 108
        elif [[ "$typeStation" == "hva" && "$typeCons" != "comp" ]] ; then
            echo "La station HV-A n'a pour consommateur que des entreprises (argument 'comp')"
            echo "Utilisez -h ou --help pour afficher l'aide."
            exit 109
        fi

        # Assigning and checking validity of the fourth argument if it's present
        if [[ $# = 4 ]] ; then
            pwrPlantNbr="$4"
            if [[ "$pwrPlantNbr" != "1" && "$pwrPlantNbr" != "2" && "$pwrPlantNbr" != "3" && "$pwrPlantNbr" != "4" && "$pwrPlantNbr" != "5" ]] ; then
                echo "Le numéro de centrale est incorrect."
                echo "Utilisez -h ou --help pour afficher l'aide."
                exit 110
            fi
        #Confirmation of user input and what is going to be done
            echo "Arguments corrects"
            echo "Nous étudions les consommateurs '$typeCons' branchés sur les '$typeStation' de la centrale numéro $pwrPlantNbr du fichier '$inputFile'."
        elif [[ $# = 3 ]] ; then
            # Assign neutral value to the power plant number
            pwrPlantNbr='[0-9]+'
            echo "Nous étudions les consommateurs '$typeCons' branchés sur les '$typeStation' du fichier '$inputFile'."
        fi

# Vérif tmp / graphs existance + vider si nécéssaire
    

# Compilation of the code C
    make -C ./codeC

    # Vérif make

    case "$typeStation" in
        'lv' )
            # LV data
            # Name and address of the lv buffer file
                outputFileLv="./tmp/buff-lv.dat"
                # Create or clean the LV buffer file 
                > "$outputFileLv"
            # Read every line (except the first (categories)) of the input file
            # Check if it's a LV (column 4 and 7 not empty (different of '-'))
            # Add columns 1, 4 and 7 in the lv buffer file
            grep -E "^$pwrPlantNbr;-;[^-]+;[^-]+;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,3,4,7 >> "$outputFileLv"
            # Success
            echo "Extraction terminée. Les données LV sont dans $outputFileLv"
        ;;
        'hva' )
            # HV-A data
            # Output file
                # Name and address of the HV-A buffer file
                outputFileHva="./tmp/buff-hva.dat"
                # Create or clean the HV-A buffer file 
                > "$outputFileHva"
            # Read every line (except the first (categories)) of the input file
            # Check if it's a HV-A (column 3 and 7 not empty (different of '-') and column 4 empty)
            # Add columns 1, 2, 3 and 7 in the HV-A buffer file
            grep -E "^$pwrPlantNbr;[^-]+;[^-]+;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,2,3,7 >> "$outputFileHva"
            # Success
            echo "Extraction terminée. Les données HV-A sont dans $outputFileHva"
        ;;
        'hvb' )
            # HV-B data
            # Output file
                # Name and address of the HV-B buffer file
                outputFileHvb="./tmp/buff-hvb.dat"
                # Create or clean the HV-B buffer file 
                > "$outputFileHvb"
            # Read every line (except the first (categories)) of the input file
            # Check if it's a HV-B (column 2 and 7 not empty (different of '-') and column 3 empty)
            # Add columns 1, 2 and 7 in the HV-B buffer file
            grep -E "^$pwrPlantNbr;[^-]+;-;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,2,7 >> "$outputFileHvb"
            # Success
            echo "Extraction terminée. Les données HV-B sont dans $outputFileHvb"
        ;;
    esac


    # Non fonctionnel et à finir
    case "$typeCons" in
        'all' )
            # All consumers data
            # Name and address of the all consumers buffer file
                outputFileAll="./tmp/buff-cons-all.dat"
                # Create or clean the all consumers buffer file 
                > "$outputFileAll"
            # Faire les deux cas
            # Read every line (except the first (categories)) of the input file
            # Check if it's a LV consummer (column 4 and 7 not empty (different of '-'))
            # Add columns 1, 4 and 7 in the lv buffer file
            grep -E "^$pwrPlantNbr;-;[^-]+;[^-]+;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,3,4,7 >> "$outputFileAll"
            # Success
            echo "Extraction terminée. Les données de l'ensemble des consommateurs sont dans $outputFileAll"
        ;;
        'comp' )
            # Company consumer data
            # Output file
                # Name and address of the company consumer buffer file
                outputFileComp="./tmp/buff-cons-comp.dat"
                # Create or clean the company consumer buffer file 
                > "$outputFileComp"
            # Read every line (except the first (categories)) of the input file
            # Check if it's a consumer (column 3 and 7 not empty (different of '-') and column 4 empty)
            
            # Add columns 1, 2, 3 and 7 in the HV-A buffer file
            grep -E "^$pwrPlantNbr;[^-]+;[^-]+;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,2,3,7 >> "$outputFileComp"
            # Success
            echo "Extraction terminée. Les données des consommateurs entreprises des '$typeStation' sont dans $outputFileComp"
        ;;
        'indiv' )
            # Individuals consumers data
            # Output file
                # Name and address of the individuals consumers buffer file
                outputFileIndiv="./tmp/buff-cons-indiv.dat"
                # Create or clean the individuals consumers buffer file 
                > "$outputFileIndiv"
            # Read every line (except the first (categories)) of the input file
            # Check if it's a lv individual consumers (column 6 and 8 not empty (different of '-'))
            # Add columns 4 and 8 in the individual consumers buffer file
            grep -E "^$pwrPlantNbr;-;-;[^-]+;-;[^-]+;-;[^-]+$" "$inputFile" | cut -d ";" -f4,7 >> "$outputFile"
            # Success
            echo "Extraction terminée. Les données des consommateurs individuels LV sont dans $outputFileIndiv"
        ;;
    esac

# Delete execution file and buffer file
    make cleanexec -C ./codeC
    #make clean -C ./codeC

# Confirm end of the treatment
    echo "Traitement terminé. Les résultats sont dans le fichier du dossier tests."