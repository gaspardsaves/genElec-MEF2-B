#!/bin/bash

# Primary data processing
    # Name and adress of the input file
    inputFile="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/inputs/c-wire_v00.dat"
    #inputFile="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/inputs/c-wire_v25.dat"

    # Output files
        # Name and address of the lv buffer file
        outputFileLv="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/tmp/buff-lv.dat"
        # Name and address of the HV-B buffer file
        outputFileHvb="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/tmp/buff-hvb.dat"
         # Name and address of the HV-A buffer file
        outputFileHva="/home/savesgaspa/Documents/GitHub/genElec-MEF2-B/tmp/buff-hva.dat"
        
        # Create or clean the LV buffer file 
        > "$outputFileLv"
        # Create or clean the HV-B buffer file 
        > "$outputFileHvb"
        # Create or clean the HV-A buffer file 
        > "$outputFileHva"

    # Data processing
        # Read every line (except the first (categories)) of the input file
        tail -n +2 "$inputFile" | while IFS=';' read -r col1 col2 col3 col4 col5 col6 col7 col8; do
            # Check if it's a LV (column 4 and 7 not empty (different of '-'))
            if [[ "$col4" != "-" && "$col7" != "-" ]]; then
                    # Add columns in the lv buffer file
                    echo "$col4;$col7" >> "$outputFileLv"
            fi
            # Check if it's a HV-A (column 3 and 7 not empty (different of '-') and column 4 empty)
            if [[ "$col3" != "-" && "$col4" = "-" && "$col7" != "-" ]]; then
                    # Add columns in the hv-a buffer file
                    echo "$col3;$col7" >> "$outputFileHva"
            fi
            # Check if it's a HV-B (column 2 and 7 not empty (different of '-') and column 3 empty)
            if [[ "$col2" != "-" && "$col3" = "-" && "$col7" != "-" ]]; then
                    # Add columns in the HV-B buffer file
                    echo "$col2;$col7" >> "$outputFileHvb"
            fi
        done

        # Success
            echo "Extraction terminée. Les données LV sont dans $outputFileLv"
            echo "Extraction terminée. Les données HV-A sont dans $outputFileHva"
            echo "Extraction terminée. Les données HV-B sont dans $outputFileHvb"