#!/bin/bash

# Parameters analysis

    # Check if the user need help
    for arg in "$@"; do
        if [[ "$arg" == "-h" || "$arg" == "--help" ]] ; then
            echo "Option d'aide détectée"
            cat "help.txt"
        fi
    done

    # Name and adress of the input file
    #inputFile="./inputs/c-wire_v00.dat"
    #inputFile="./inputs/c-wire_v25.dat"
    inputFile="$1"

    typeConso="$2"
    case "$typeConso" in
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