#!/bin/bash

# Checking the existence and clean-up of 'graphs' and 'tmp' directories using a function
# A faire gestion des permissions
    directory1="tmp"
    directory2="graphs"
    directory3="outputs"
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
    checkDirectory "$directory3"

# Initializing processing time measure
    timeStart=$(date +%s.%N)

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
            echo "Nombre d'arguments insuffisant. Consultez l'aide ci-dessous."
            cat "help.txt"
            exit 102
        fi

    # Checking the maximum number of arguments
        if [[ $# -gt 4 ]] ; then
            echo "Nombre d'arguments trop important. Consultez l'aide ci-dessous."
            cat "help.txt"
            exit 103
        fi

    # Assignement and checking consistency of arguments
        # First argument of the script
            # Adress of the input file
            inputFile="$1"

            # Checking the existence and the possibility of reading the file
                if [[ ! ( -f "$inputFile" ) ]] ; then
                    echo "Le fichier de données n'existe pas à cet emplacement. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 104
                elif [[  ! ( -r "$inputFile" ) ]] ; then
                    echo "Droit de lecture manquant sur ce fichier."
                    echo "Veuillez corriger les permissions et réitérer la demande. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 105
                fi
        # Second argument
            # Type of electric post to be treated (hvb, hva, lv)
            typeStation="$2"

            # Checking validity of the second argument
                if [[ "$typeStation" != "hvb" && "$typeStation" != "hva" && "$typeStation" != "lv" ]] ; then
                    echo "Type de poste électrique invalide. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 106
                fi

        # Third argument
            # Type of consumer to be treated (comp, indiv, all)
            typeCons="$3"

            # Checking validity of the third argument
                if [[ "$typeCons" != "comp" && "$typeCons" != "indiv" && "$typeCons" != "all" ]] ; then
                    echo "Type de consommateur invalide. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 107
                fi

        # Checking argument combinations
            if [[ "$typeStation" == "hvb" && "$typeCons" != "comp" ]] ; then
                echo "La station HV-B n'a pour consommateur que des entreprises (argument 'comp'). Consultez l'aide ci-dessous."
                cat "help.txt"
                exit 108
            elif [[ "$typeStation" == "hva" && "$typeCons" != "comp" ]] ; then
                echo "La station HV-A n'a pour consommateur que des entreprises (argument 'comp'). Consultez l'aide ci-dessous."
                cat "help.txt"
                exit 109
            fi

        # Fourth argument
            # Assigning and checking validity of the fourth argument if it's present
                if [[ $# = 4 ]] ; then
                    pwrPlantNbr="$4"
                    if [[ "$pwrPlantNbr" != "1" && "$pwrPlantNbr" != "2" && "$pwrPlantNbr" != "3" && "$pwrPlantNbr" != "4" && "$pwrPlantNbr" != "5" ]] ; then
                        echo "Le numéro de centrale est incorrect. Consultez l'aide ci-dessous."
                        cat "help.txt"
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

# Initializing compilation time measure
    compilationStart=$(date +%s.%N)
# Compilation of the code C and check if it's successful
    echo "____ ALL ____" > make.log
    echo "$(date): Compilation data" >> make.log
    make -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection ou juste l'erreur
    if [[ $? -eq 0 ]] ; then
        echo "Compilation réussie." >> make.log
    else
        echo "Echec de compilation. Voir erreurs dans le fichier make.log."
        exit 111
    fi

    if [[ "$typeCons" == "all" ]] ; then
        echo "____ RATIO ____" >> make.log
        echo "$(date): Compilation ratio" >> make.log
        make ratio -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection ou juste l'erreur
        if [ $? -eq 0 ]; then
            echo "Compilation ration réussie." >> make.log
        else
            echo "Echec de compilation. Voir erreurs dans le fichier make.log."
            exit 112
        fi
    fi

# End of measure of compilation time
    compilationEnd=$(date +%s.%N)
    compilationTime=$( echo "$compilationEnd - $compilationStart" | bc )

# Data treatment

    # Output file naming and initialization of the file
        if [[ $# = 4 ]] ; then
            outputFile=./outputs/${typeStation}_${typeCons}_${pwrPlantNbr}.csv
        else
            outputFile=./outputs/${typeStation}_${typeCons}.csv
        fi
        > "$outputFile"

    # Use of switch case loop
    case "$typeStation" in
        'lv' )
            # LV data
            # Read every line (except the first (categories)) of the input file
            # Check if it's a LV (column 4 and 7 not empty (different of '-'))
            # Add columns 4, 7 and 8 in the lv buffer file
            case "$typeCons" in
                'all' )
                    # All consumers data
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n > "$outputFile"
                    buffLvMinmax="./tmp/buff-lv_all_minmax.csv"
                    > "$buffLvMinmax"
                    lvMinmax="./tmp/lv_all_minmax.csv"
                    #echo "___LES 10 PLUS PETITES CAPACITÉS___" > "$buffLvMinmax"
                    head -n 10 "$outputFile" >> "$buffLvMinmax"
                    #echo "___LES 10 PLUS GROSSES CAPACITÉS___" >> "$buffLvMinmax"
                    tail -n 10 "$outputFile" >> "$buffLvMinmax"
                    #cat "$buffLvMinmax" | ./codeC/execratio | sort -t ";" -k2,2n > "$buffLvMinmax"
                    # Vérifier que le fichier a bien 20 lignes
                    cat "$buffLvMinmax" | ./codeC/execratio | sort -t ";" -k4,4n | cut -d ";" -f1-3  > "$lvMinmax"
                ;;
                'comp' )
                    # Company consumer data
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;[0-9-]+;-;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n > "$outputFile"
                ;;
                'indiv' )
                    # Individuals consumers data
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;-;[0-9-]+;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n > "$outputFile"

                ;;
            esac
            # Success
            echo "Extraction terminée. Les données des postes et des consommateurs LV nécessaires sont dans $outputFile"
        ;;
        'hva' )
            # HV-A data
            # Output file
            # Read every line (except the first (categories)) of the input file
            # Check if it's a HV-A (column 3 and 7 not empty (different of '-') and column 4 empty)

            grep -E "^$pwrPlantNbr;[0-9-]+;[^-]+;-;[0-9-]+;-;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n > "$outputFile"

            # Success
            echo "Extraction terminée. Les données HV-A des postes et des consommateurs sont dans $outputFile"
        ;;
        'hvb' )
            # HV-B data
            # Output file
            # Read every line (except the first (categories)) of the input file
            # Check if it's a HV-B (column 2 and 7 not empty (different of '-') and column 3 empty)
            # Add columns 1, 2 and 7 in the HV-B buffer file
            grep -E "^$pwrPlantNbr;[^-]+;-;-;([0-9-]+);-;([0-9-]+);([0-9-]+)$" "$inputFile" | cut -d ";" -f2,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n > "$outputFile"
           
            # Success
            echo "Extraction terminée. Les données HV-B des postes et des consommateurs sont dans $outputFile"
        ;;
    esac

# Delete execution file and check if it's successful
    echo "____ CLEAN ____" >> make.log
    echo "$(date): Suppression des exécutables" >> make.log
    make clean -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection globale ou juste l'erreur
    if [ $? -eq 0 ]; then
        echo "Suppression des exécutables réussie." >> make.log
    else
        echo "Echec de la suppression des exécutables. Voir les erreurs dans le fichier make.log."
        exit 113
    fi

# Delete buffer file and check if it's successful
    echo "____ CLEANFILE____" >> make.log
    echo "$(date): Suppression des fichiers tampons" >> make.log
    # make cleanfile -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection globale ou juste l'erreur 
    #if [ $? -eq 0 ]; then
        #echo "Suppression des fichiers tampons réussie" >> make.log
    #else
        #echo "Echec de suppression des fichiers tampons. Voir erreurs dans le fichier make.log."
        #exit 114
    #fi

# Confirm end of the treatment
    echo "Traitement terminé. Les résultats sont dans le fichier du dossier tests."
    timeEnd=$(date +%s.%N)
    totalTime=$( echo "($timeEnd - $timeStart) - $compilationTime" | bc )
    # Conversion of the locale to use printf (conversion point and coma)
    LC_NUMERIC=C printf "Durée de la compilation : %.3f secondes\n" "$compilationTime"
    LC_NUMERIC=C printf "Durée totale du script hors compilation et création de dossier : %.3f secondes\n" "$totalTime"