#Ne fonctionne pas avec trop de données

#!/bin/bash

# Primary data processing
    # Name and adress of the input file
    inputFile="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/inputs/c-wire_v00.dat"
    #inputFile="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/inputs/c-wire_v25.dat"

    # LV data
        # Name and address of the lv buffer file
        outputFileLv="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/tmp/buff-lv.dat"
        # Create the lv buffer file 
        > "$outputFileLv"

        # Read every line (except the first (categories)) of the input file and check if it's a LV (column 4 and 7 not empty (different of '-'))
        tail -n +2 "$inputFile" | while IFS=';' read -r col1 col2 col3 col4 col5 col6 col7 col8; do
            if [[ "$col4" != "-" && "$col7" != "-" ]]; then
                # Add columns in the lv buffer file
                echo "$col4;$col7" >> "$outputFileLv"
            fi
        done
        echo "Extraction terminée. Les données LV sont dans $outputFileLv"

    # HV-B data
        # Name and address of the HV-B buffer file
        outputFileHvb="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/tmp/buff-hvb.dat"
        # Create the HV-B buffer file 
        > "$outputFileHvb"

        # Read every line (except the first (categories)) of the input file and check if it's a HV-B (column 2 and 7 not empty (different of '-'))
        tail -n +2 "$inputFile" | while IFS=';' read -r col1 col2 col3 col4 col5 col6 col7 col8; do
            if [[ "$col2" != "-" && "$col3" = "-" && "$col7" != "-" ]]; then
                # Add columns in the HV-B buffer file
                echo "$col2;$col7" >> "$outputFileHvb"
            fi
        done
        echo "Extraction terminée. Les données HV-B sont dans $outputFileHvb"

    # HV-A data
        # Name and address of the HV-A buffer file
        outputFileHva="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/tmp/buff-hva.dat"
        # Create the HV-A buffer file 
        > "$outputFileHva"

        # Read every line (except the first (categories)) of the input file and check if it's a HV-A (column 3 and 7 not empty (different of '-'))
        tail -n +2 "$inputFile" | while IFS=';' read -r col1 col2 col3 col4 col5 col6 col7 col8; do
            if [[ "$col3" != "-" && "$col4" = "-" && "$col7" != "-" ]]; then
                # Add columns in the hv-a buffer file
                echo "$col3;$col7" >> "$outputFileHva"
            fi
        done
        echo "Extraction terminée. Les données HV-A sont dans $outputFileHva"