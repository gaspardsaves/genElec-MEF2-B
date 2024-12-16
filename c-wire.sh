#!/bin/bash

# Checking the existence and clean-up of 'tmp', 'graphs' and 'outputs' directories using a function
    directory1="tmp"
    directory2="graphs"
    directory3="outputs"
    checkDirectory () {
        # Use of a local variable to avoid conflicts
        local directory=$1
        if [ -d "$directory" ]; then
            # Check of writing right to clean the directory
            if [ -w "$directory" ]; then
                # Clean the directory
                rm -f "$directory"/*
                # Check if cleaning is successful
                if [ $? -eq 0 ]; then
                    echo "Le dossier '$directory' a été nettoyé avec succès."
                else
                    echo "Problème lors du nettoyage du répertoire '$directory'. Vérifiez si vous n'avez pas des fichiers protégés."
                    exit 101
                fi
            else
                echo "Droits d'écriture manquants sur le répertoire '$directory'."
                echo "Veuillez corriger les permissions et réitérer la demande"
                exit 102
            fi
        else
            # Create the directory
            mkdir -m 755 "$directory"
            # Check if creation is successful
            if [ $? -eq 0 ]; then
                echo "Le répertoire '$directory' n'existait pas et a été créé avec succès"
            else
                echo "Impossible de créer le répertoire '$directory'. Vérifiez vos permissions."
                exit 103
            fi
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
                exit 104
            fi
        done

    # Checking the minimum number of arguments
        if [[ $# -lt 3 ]] ; then
            echo "Nombre d'arguments insuffisant. Consultez l'aide ci-dessous."
            cat "help.txt"
            exit 105
        fi

    # Checking the maximum number of arguments
        if [[ $# -gt 4 ]] ; then
            echo "Nombre d'arguments trop important. Consultez l'aide ci-dessous."
            cat "help.txt"
            exit 106
        fi

    # Assignement and checking consistency of arguments
        # First argument of the script
            # Adress of the input file
            inputFile="$1"

            # Checking the existence and the possibility of reading the file
                if [[ ! ( -f "$inputFile" ) ]] ; then
                    echo "Le fichier de données n'existe pas à cet emplacement. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 107
                elif [[  ! ( -r "$inputFile" ) ]] ; then
                    echo "Droit de lecture manquant sur ce fichier."
                    echo "Veuillez corriger les permissions et réitérer la demande. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 108
                fi
        # Second argument
            # Type of electric post to be treated (hvb, hva, lv)
            typeStation="$2"

            # Checking validity of the second argument
                if [[ "$typeStation" != "hvb" && "$typeStation" != "hva" && "$typeStation" != "lv" ]] ; then
                    echo "Type de poste électrique invalide. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 109
                fi

        # Third argument
            # Type of consumer to be treated (comp, indiv, all)
            typeCons="$3"

            # Checking validity of the third argument
                if [[ "$typeCons" != "comp" && "$typeCons" != "indiv" && "$typeCons" != "all" ]] ; then
                    echo "Type de consommateur invalide. Consultez l'aide ci-dessous."
                    cat "help.txt"
                    exit 110
                fi

        # Checking argument combinations
            if [[ "$typeStation" == "hvb" && "$typeCons" != "comp" ]] ; then
                echo "La station HV-B n'a pour consommateur que des entreprises (argument 'comp'). Consultez l'aide ci-dessous."
                cat "help.txt"
                exit 111
            elif [[ "$typeStation" == "hva" && "$typeCons" != "comp" ]] ; then
                echo "La station HV-A n'a pour consommateur que des entreprises (argument 'comp'). Consultez l'aide ci-dessous."
                cat "help.txt"
                exit 112
            fi

        # Fourth argument
            # Assigning and checking validity of the fourth argument if it's present
                if [[ $# = 4 ]] ; then
                    pwrPlantNbr="$4"
                    if [[ "$pwrPlantNbr" != "1" && "$pwrPlantNbr" != "2" && "$pwrPlantNbr" != "3" && "$pwrPlantNbr" != "4" && "$pwrPlantNbr" != "5" ]] ; then
                        echo "Le numéro de centrale est incorrect. Consultez l'aide ci-dessous."
                        cat "help.txt"
                        exit 113
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
    make -C ./codeC >> make.log 2>&1
    if [[ $? -eq 0 ]] ; then
        echo "Compilation data réussie." >> make.log
    else
        echo "Echec de compilation data. Voir erreurs dans le fichier make.log."
        exit 114
    fi

    if [[ "$typeCons" == "all" ]] ; then
        echo "____ RATIO ____" >> make.log
        echo "$(date): Compilation ratio" >> make.log
        make ratio -C ./codeC >> make.log 2>&1
        if [ $? -eq 0 ]; then
            echo "Compilation ratio réussie." >> make.log
        else
            echo "Echec de compilation ratio. Voir erreurs dans le fichier make.log."
            exit 115
        fi
    fi

# End of measure of compilation time
    compilationEnd=$(date +%s.%N)
    compilationTime=$( echo "$compilationEnd - $compilationStart" | bc )

# Data treatment

    # Output(s) file(s) naming and initialization of the file(s)
        if [[ $# = 4 ]] ; then
            outputFile=./outputs/${typeStation}_${typeCons}_${pwrPlantNbr}.csv
            if [[ "$typeCons" == "all" ]] ; then
                outputMinmax=./outputs/${typeStation}_${typeCons}_${pwrPlantNbr}_minmax.csv
                buffLvMinmax=./tmp/buff_${typeStation}_${typeCons}_${pwrPlantNbr}_minmax.csv
                buffGnuPlotLvMinmaxNeg=./tmp/buff_plt_${typeStation}_${typeCons}_${pwrPlantNbr}_minmax_neg.csv
                buffGnuPlotLvMinmaxPos=./tmp/buff_plt_${typeStation}_${typeCons}_${pwrPlantNbr}_minmax_pos.csv
                graphLvMinmaxNeg=./graphs/${typeStation}_${typeCons}_${pwrPlantNbr}_minmax_neg.png
                graphLvMinmaxPos=./graphs/${typeStation}_${typeCons}_${pwrPlantNbr}_minmax_pos.png
            fi
        else
            outputFile=./outputs/${typeStation}_${typeCons}.csv
            if [[ "$typeCons" == "all" ]] ; then
                outputMinmax=./outputs/${typeStation}_${typeCons}_minmax.csv
                buffLvMinmax=./tmp/buff_${typeStation}_${typeCons}_minmax.csv
                buffGnuPlotLvMinmaxNeg=./tmp/buff_plt_${typeStation}_${typeCons}_minmax_neg.csv
                buffGnuPlotLvMinmaxPos=./tmp/buff_plt_${typeStation}_${typeCons}_minmax_pos.csv
                graphLvMinmaxNeg=./graphs/${typeStation}_${typeCons}_minmax_neg.png
                graphLvMinmaxPos=./graphs/${typeStation}_${typeCons}_minmax_pos.png
            fi
        fi
        > "$outputFile"
        if [[ "$typeCons" == "all" ]] ; then
            > "$outputMinmax"
            > "$buffLvMinmax"
            > "$buffGnuPlotLvMinmaxNeg"
            > "$buffGnuPlotLvMinmaxPos"
            > "$graphLvMinmaxNeg"
            > "$graphLvMinmaxPos"
        fi

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
                    # Initialization of output file columns
                    echo "Station LV:Capacité:Consommation (tous)" > "$outputFile"
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n >> "$outputFile"
                    if [[ "$(wc -l < "$outputFile")" -ge 21 ]] ; then
                        echo "Tri par quantité absolue d'énergie consommée (capacité - consommation)" >> "$outputMinmax"
                        echo "Les 10 stations LV avec la plus forte sous-consommation et les 10 avec la plus forte surconsommation" >> "$outputMinmax"
                        echo "Station LV:Capacité:Consommation (tous)" >> "$outputMinmax"
                        tail -n +2 "$outputFile" | ./codeC/execratio | sort -t ":" -k4,4n > "$buffGnuPlotLvMinmaxNeg"
                        head -n 10 "$buffGnuPlotLvMinmaxNeg" >> "$buffLvMinmax"
                        tail -n 10 "$buffGnuPlotLvMinmaxNeg" >> "$buffLvMinmax"
                        cut -d ":" -f1-3 "$buffLvMinmax" >> "$outputMinmax"
                        awk -F ":" '$4 < 0' "$buffLvMinmax" | cut -d ":" -f1-3 | sort -t ":" -k2,2n > "$buffGnuPlotLvMinmaxNeg"
                        awk -F ":" '$4 >= 0' "$buffLvMinmax" | cut -d ":" -f1-3 | sort -t ":" -k3,3n > "$buffGnuPlotLvMinmaxPos"
                    else
                        echo "Le réseau contient moins de 20 postes LV, il n'y aura pas de fichier $outputMinmax"
                        rm "$outputMinmax"
                        tail -n +2 "$outputFile" | ./codeC/execratio | sort -t ":" -k4,4n > "$buffLvMinmax"
                        awk -F ":" '$4 < 0' "$buffLvMinmax" | cut -d ":" -f1-3 | sort -t ":" -k2,2n > "$buffGnuPlotLvMinmaxNeg"
                        awk -F ":" '$4 >= 0' "$buffLvMinmax" | cut -d ":" -f1-3 | sort -t ":" -k3,3n > "$buffGnuPlotLvMinmaxPos"
                    fi
                    gnuplot -e "dataFile='${buffGnuPlotLvMinmaxNeg}'; graphOutput='${graphLvMinmaxNeg}'" script-gnuplot-lv-neg.plt
                    if [ $? -eq 0 ]; then
                        echo "Construction du graphique des postes les plus chargés réussie."
                    else
                        echo "Erreur de génération du graphique des postes les plus chargés."
                    fi
                    gnuplot -e "dataFile='${buffGnuPlotLvMinmaxPos}'; graphOutput='${graphLvMinmaxPos}'" script-gnuplot-lv-pos.plt
                    if [ $? -eq 0 ]; then
                        echo "Construction du graphique des postes les moins chargés réussie."
                    else
                        echo "Erreur de génération du graphique des postes les moins chargés."
                    fi
                ;;
                'comp' )
                    # Company consumer data
                    # Initialization of output file columns
                    echo "Station LV:Capacité:Consommation (entreprises)" > "$outputFile"
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;[0-9-]+;-;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n >> "$outputFile"
                ;;
                'indiv' )
                    # Individuals consumers data
                    # Initialization of output file columns
                    echo "Station LV:Capacité:Consommation (particuliers)" > "$outputFile"
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;-;[0-9-]+;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n >> "$outputFile"

                ;;
            esac
            # Success
            echo "Extraction terminée. Les données LV des postes et des consommateurs sont dans $outputFile"
        ;;
        'hva' )
            # HV-A data
            # Read every line (except the first (categories)) of the input file
            # Check if it's a HV-A (column 3 and 7 not empty (different of '-') and column 4 empty)

            # Initialization of output file columns
            echo "Station HV-A:Capacité:Consommation (entreprises)" > "$outputFile"
            grep -E "^$pwrPlantNbr;[0-9-]+;[^-]+;-;[0-9-]+;-;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n >> "$outputFile"
            # Success
            echo "Extraction terminée. Les données HV-A des postes et des consommateurs sont dans $outputFile"
        ;;
        'hvb' )
            # HV-B data
            # Read every line (except the first (categories)) of the input file
            # Check if it's a HV-B (column 2 and 7 not empty (different of '-') and column 3 empty)
            # Add columns 1, 2 and 7 in the HV-B buffer file

            # Initialization of output file columns
            echo "Station HV-A:Capacité:Consommation (entreprises)" > "$outputFile"
            grep -E "^$pwrPlantNbr;[^-]+;-;-;([0-9-]+);-;([0-9-]+);([0-9-]+)$" "$inputFile" | cut -d ";" -f2,7,8 | tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n >> "$outputFile"
            # Success
            echo "Extraction terminée. Les données HV-B des postes et des consommateurs sont dans $outputFile"
        ;;
    esac

# Delete execution file and check if it's successful
    echo "____ CLEAN ____" >> make.log
    echo "$(date): Suppression des exécutables data" >> make.log
    make clean -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection globale ou juste l'erreur
    if [ $? -eq 0 ]; then
        echo "Suppression des exécutables réussie." >> make.log
    else
        echo "Echec de la suppression des exécutables. Voir les erreurs dans le fichier make.log."
        exit 118
    fi

    if [[ "$typeCons" == "all" ]] ; then
        echo "____ CLEAN RATIO ____" >> make.log
        echo "$(date): Suppression de l'exécutable ratio" >> make.log
        make cleanratio -C ./codeC >> make.log 2>&1
        if [ $? -eq 0 ]; then
            echo "Suppression de l'exécutable ratio réussie" >> make.log
        else
            echo "Echec de suppression de l'exécutable ratio. Voir erreurs dans le fichier make.log."
            exit 119
        fi
    fi

# Delete buffer file and check if it's successful
    echo "____ CLEANFILE____" >> make.log
    echo "$(date): Suppression des fichiers tampons" >> make.log
    #make cleanfile -C ./codeC >> make.log 2>&1 # Voir si on garde cette redirection globale ou juste l'erreur 
    #if [ $? -eq 0 ]; then
        #echo "Suppression des fichiers tampons réussie" >> make.log
    #else
        #echo "Echec de suppression des fichiers tampons. Voir erreurs dans le fichier make.log."
        #exit 120
    #fi

# Confirm end of the treatment
    echo "Traitement terminé. Les résultats sont dans le fichier du dossier 'outputs'."
# Calculation of processing time
    timeEnd=$(date +%s.%N)
    totalTime=$( echo "($timeEnd - $timeStart) - $compilationTime" | bc )
# Display processing time
    # Conversion of the locale (conversion point and coma) to use printf
    LC_NUMERIC=C printf "Durée de la compilation : %.3f secondes\n" "$compilationTime"
    LC_NUMERIC=C printf "Durée totale du script hors compilation et création de dossier : %.3f secondes\n" "$totalTime"