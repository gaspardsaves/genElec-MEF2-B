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
        # First argument of the script
            # Adress of the input file
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
        # Second argument
            # Type of electric post to be treated (hvb, hva, lv)
            typeStation="$2"

            # Checking validity of the second argument
                if [[ "$typeStation" != "hvb" && "$typeStation" != "hva" && "$typeStation" != "lv" ]] ; then
                    echo "Type de poste électrique invalide"
                    echo "Utilisez -h ou --help pour afficher l'aide."
                    exit 106
                fi

        # Third argument
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

        # Fourth argument
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
                    echo "Arguments corrects"
                    echo "Nous étudions les consommateurs '$typeCons' branchés sur les '$typeStation' du fichier '$inputFile'."
                fi

    # Checking the existence and clean-up of 'graphs' and 'tmp' directories using a function
    # A faire gestion des permissions
        directory1="tmp"
        directory2="graphs"
        checkDirectory () {
            local directory=$1
            if [ -d "$directory" ]; then # Clean the directory
                rm -f "$directory"/*
                echo "Le dossier '$directory' a été nettoyé avec succès."
            else
                mkdir "$directory"  # Create the directory
                echo "Le dossier '$directory' n'existait pas et a été créé avec succès"
            fi
        }
        checkDirectory "$directory1"
        checkDirectory "$directory2"

# Compilation of the code C and check if it's successful
    echo "____ ALL ____" > make.log
    echo "$(date): Compilation" >> make.log
    make -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection ou juste l'erreur
    if [ $? -eq 0 ]; then
        echo "Compilation réussie. Détail dans le fichier make.log"
    else
        echo "Echec de compilation. Voir erreurs dans le fichier make.log."
        exit 111
    fi

# Data treatment 
    # Use of switch case loop
    case "$typeStation" in
        'lv' )
            # LV data
            # Name and address of the lv buffer file
                outputFileLv="./tmp/buff-lv.dat"
                # Create or clean the LV buffer file 
                > "$outputFileLv"
            # Read every line (except the first (categories)) of the input file
            # Check if it's a LV (column 4 and 7 not empty (different of '-'))
            # Add columns 4, 7 and 8 in the lv buffer file
            case "$typeCons" in
                'all' )
                    # All consumers data
                    grep -E "^$pwrPlantNbr;-;-|[0-9]+;[^-]+;-|[0-9]+;-|[0-9]+;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f4,7,8 | ./codeC/execdef >> "$outputFileLv"
                ;;
                'comp' )
                    # Company consumer data
                    grep -E "^$pwrPlantNbr;-;-|[0-9]+;[^-]+;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f4,7,8 | ./codeC/execdef >> "$outputFileLv"
                ;;
                'indiv' )
                    # Individuals consumers data
                    grep -E "^$pwrPlantNbr;-;-|[0-9]+;[^-]+;-;-|[0-9]+;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f4,7,8 | ./codeC/execdef >> "$outputFileLv"
                ;;
            esac
            # Success
            echo "Extraction terminée. Les données des postes et des consommateurs LV nécessaires sont dans $outputFileLv"
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
            # ( ./codeC/execdef < ( grep -E "^$pwrPlantNbr;-|[0-9]+;[^-]+;-;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' ) ) > "$outputFileHva"
            
            ( grep -E "^$pwrPlantNbr;-|[0-9]+;[^-]+;-;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' | ./codeC/execdef ) > "$outputFileHva"
            # Test ok avec cette commande manque le tri par consommation croissante et nécessité de passer en long int car sinon chiffres négatifs

            #outputFileDef="./tmp/buff-hva-def.dat"
            #(./codeC/execdef < $outputFileHva ) > $outputFileDef
            # Success
            echo "Extraction terminée. Les données HV-A des postes et des consommateurs sont dans $outputFileHva"
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
            grep -E "^$pwrPlantNbr;[^-]+;-;-;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" | cut -d ";" -f2,7,8 | ./codeC/execdef >> "$outputFileHvb"
            # Success
            echo "Extraction terminée. Les données HV-B des postes et des consommateurs sont dans $outputFileHvb"
        ;;
    esac

# Delete execution file and check if it's successful
    echo "____ CLEAN ____" >> make.log
    echo "$(date): Suppression des exécutables" >> make.log
    make clean -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection globale ou juste l'erreur
    if [ $? -eq 0 ]; then
        echo "Suppression des exécutables réussie. Détail dans le fichier make.log"
    else
        echo "Echec de la suppression des exécutables. Voir les erreurs dans le fichier make.log."
        exit 112
    fi

# Delete buffer file and check if it's successful
    echo "____ CLEANFILE____" >> make.log
    echo "$(date): Suppression des fichiers tampons" >> make.log
    # make cleanfile -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection globale ou juste l'erreur 
    #if [ $? -eq 0 ]; then
        #echo "Suppression des fichiers tampons réussie. Détail dans le fichier make.log"
    #else
        #echo "Echec de suppression des fichiers tampons. Voir erreurs dans le fichier make.log."
        #exit 113
    #fi

# Confirm end of the treatment
    echo "Traitement terminé. Les résultats sont dans le fichier du dossier tests."