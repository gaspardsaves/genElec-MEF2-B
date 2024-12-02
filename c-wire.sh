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

    # Assignement and checking consistency of arguments
        # Adress of the input file
        #inputFile="./inputs/c-wire_v00.dat"
        #inputFile="./inputs/c-wire_v25.dat"
        inputFile="$1"

        # Checking the existence and the possibility of reading the file
        if [[ ! ( -f "$inputFile" ) ]] ; then
            echo "Le fichier de données n'existe pas à cet emplacement"
            exit 103
        elif [[  ! ( -r "$inputFile" ) ]] ; then
            echo "Droit de lecture manquant sur ce fichier."
            echo "Veuillez corriger les permissions et réitérer la demande."
            exit 104
        fi

        # Type of electric post to be treated (hvb, hva, lv)
        typeStation="$2"

        # Checking validity of the second argument
        # à faire

        # Type of consumer to be treated
        typeCons="$3"

        # Checking validity of the third argument
        # à faire

        # Checking argument combinations
        if [[ "$typeStation" == "hvb" && "$typeCons" != "comp" ]] ; then
            echo "La station HV-B n'a pour consommateur que des entreprises (argument 'comp')"
            echo "Utilisez -h ou --help pour afficher l'aide."
            exit 104
        elif [[ "$typeStation" == "hva" && "$typeCons" != "comp" ]] ; then
            echo "La station HV-A n'a pour consommateur que des entreprises (argument 'comp')"
            echo "Utilisez -h ou --help pour afficher l'aide."
            exit 105
        fi

        echo "Arguments corrects"
        if [[ $# = 3 ]] ; then
            echo "Nous étudions les consommateurs '$typeCons' branchés sur les '$typeStation' du fichier '$inputFile'."
        elif [[ $# = 4 ]] ; then
            echo "Nous étudions les consommateurs '$typeCons' branchés sur les '$typeStation' de la centrale numéro $pwrPlantNbr du fichier '$inputFile'."
        fi

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
            grep -E "^[^-]+;-;[^-]+;[^-]+;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,3,4,7 >> "$outputFileLv"
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
            grep -E "^[^-]+;[^-]+;[^-]+;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,2,3,7 >> "$outputFileHva"
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
            grep -E "^[^-]+;[^-]+;-;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f1,2,7 >> "$outputFileHvb"
            # Success
            echo "Extraction terminée. Les données HV-B sont dans $outputFileHvb"
        ;;
    esac