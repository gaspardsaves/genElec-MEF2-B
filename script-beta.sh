    # [0-9-]

    # Data treatment
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
            grep -E "^$pwrPlantNbr;-;[^-]+;[^-]+;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f4,7,8 >> "$outputFileLv"
            case "$typeCons" in
                'all' )
                    # All consumers data
                    grep -E "^$pwrPlantNbr;-;-;[^-]+;-|[0-9]+;-|[0-9]+;-;[^-]+$" "$inputFile" | cut -d ";" -f4,7,8 >> "$outputFileLv"
                ;;
                'comp' )
                    # Company consumer data
                    grep -E "^$pwrPlantNbr;-;-;[^-]+;[^-]+;-;-;[^-]+$" "$inputFile" | cut -d ";" -f4,7,8 >> "$outputFileLv"
                ;;
                'indiv' )
                    # Individuals consumers data
                    grep -E "^$pwrPlantNbr;-;-;[^-]+;-;[^-]+;-;[^-]+$" "$inputFile" | cut -d ";" -f4,7,8 >> "$outputFileLv"
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
            grep -E "^$pwrPlantNbr;[^-]+;[^-]+;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f3,7,8 >> "$outputFileHva"
            grep -E "^$pwrPlantNbr;-;[^-]+;-;[^-]+;-;-;[^-]+$" "$inputFile" | cut -d ";" -f3,7,8 >> "$outputFileHva"
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
            grep -E "^$pwrPlantNbr;[^-]+;-;-;-;-;[^-]+;-$" "$inputFile" | cut -d ";" -f2,7,8 >> "$outputFileHvb"
            grep -E "^$pwrPlantNbr;[^-]+;-;-;[^-]+;-;-;[^-]+$" "$inputFile" | cut -d ";" -f2,7,8 >> "$outputFileHvb"
            # Success
            echo "Extraction terminée. Les données HV-B des postes et des consommateurs sont dans $outputFileHvb"
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