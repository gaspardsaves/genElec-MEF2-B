# Save

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
                        #awk '{print NR ":" $0}' "$buffLvMinmax" | cut -d ":" -f1,2,5 > "$buffGnuPlotLvMinmax"
                    else
                        echo "Le réseau contient moins de 20 postes LV, il n'y aura pas de fichier $outputMinmax"
                        rm "$outputMinmax"
                        tail -n +2 "$outputFile" | ./codeC/execratio | sort -t ":" -k4,4n > "$buffLvMinmax"
                        #awk '{print NR ":" $0}' "$buffLvMinmax" | cut -d ":" -f1,2,5 > "$buffGnuPlotLvMinmax"
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

# Graphs generation function
    generateGraphs () {
        # Necessité de réaliser un passage d'argument avec des fichiers d'entrée et de sortie pour être générique
        # Manque la vérification du retour
        gnuplot <<EOF
            # Histogram image generation
            set terminal pngcairo size 1000,600 enhanced font "Arial,12"
            set output "$graphLvMinmax"

            # Display management
            set style fill solid 0.8 border -1
            set style line 1 lc rgb "red"
            set style line 2 lc rgb "green"
            set boxwidth 0.9
            set grid

            # Title and legend management
            set xlabel 'Identifiant du poste'
            set ylabel 'Charge nette (capacité - consommation)'
            set title 'Histogramme de charge des postes LV ayant la plus forte et la plus faible consommation'
            set xtics rotate by -45 font "Arial,10"

            # Clarification on reading the .csv file
            set datafile separator ":"
            set key autotitle columnhead

            #set palette model RGB defined (0 'red', 1 'green')

            # Complete graphic creation with conditions on selected colors
            plot '$buffGnuPlotLvMinmax' using 1:3:(\$3 < 0 ? 1 : 2):xtic(2) with boxes lc variable notitle
            #plot '$buffGnuPlotLvMinmax' using 1:3:(\$3 < 0 ? 0 : 1):xtic(2) with boxes lc variable notitle
            #plot '$buffGnuPlotLvMinmax' using 1:3:(\$3 < 0 ? 'red' : 'green'):xtic(2) with boxes lc variable notitle
            # plot '$buffGnuPlotLvMinmax' using 1:3:((\$3 < 0) ? 1 : 2) with boxes lc rgb 'red' notitle, '$buffGnuPlotLvMinmax' using 1:3:((\$3 > 0) ? 1 : 2) with boxes lc rgb 'green' notitle
EOF
    }

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
                    echo "Les 10 stations LV avec le plus de consommation et les 10 avec le moins" >> "$outputMinmax"
                    echo "Tri par quantité absolue d'énergie consommée (capacité - consommation)" >> "$outputMinmax"
                    echo "Station LV:Capacité:Consommation (tous)" >> "$outputMinmax"
                    sort -t ":" -k3,3n "$outputFile" | tail -n +2 | head -n 10 >> "$buffGnuPlotLvMinmax"
                    sort -t ":" -k3,3n "$outputFile" | tail -n 10 >> "$buffGnuPlotLvMinmax"
                    cat "$buffGnuPlotLvMinmax" | ./codeC/execratio | sort -t ":" -k4,4n > "$buffLvMinmax"
                    cut -d ":" -f1-3 "$buffLvMinmax" >> "$outputMinmax"
                    awk '{print NR ":" $0}' "$buffLvMinmax" | cut -d ":" -f1,2,5 > "$buffGnuPlotLvMinmax"
                    generateGraphs "$buffGnuPlotLvMinmax"
                else
                        echo "Le réseau contient moins de 20 postes LV, il n'y aura pas de fichier $outputMinmax"
                        rm "$outputMinmax"
                        tail -n +2 "$outputFile" | ./codeC/execratio | sort -t ":" -k4,4n > "$buffLvMinmax"
                        awk '{print NR ":" $0}' "$buffLvMinmax" | cut -d ":" -f1,2,5 > "$buffGnuPlotLvMinmax"
                        gnuplot -e "dataFile='${buffGnuPlotLvMinmax}'; graphOutput='${graphLvMinmax}'" script-gnuplot-lv.plt
                        #generateGraphs "$buffGnuPlotLvMinmax"
                        if [ $? -eq 0 ]; then
                            echo "Construction du graphique réussie."
                        else
                            echo "Erreur de génération du graphique."
                            #exit 117
                        fi
                    fi
            ;;

case "$typeCons" in
    'all' )
        # All consumers data
        # Initialization of output file columns
        echo "Station LV:Capacité:Consommation (tous)" > "$outputFile"
        grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdata | sort -t ":" -k2,2n >> "$outputFile"
        if [[ "$(wc -l < "$outputFile")" -ge 21 ]] ; then
            #echo "___LES 10 PLUS PETITES CAPACITÉS___" > "$buffLvMinmax"
            tail -n +2 "$outputFile" | head -n 10 >> "$buffLvMinmax"
            #echo "___LES 10 PLUS GROSSES CAPACITÉS___" >> "$buffLvMinmax"
            tail -n 10 "$outputFile" >> "$buffLvMinmax"
            #cat "$buffLvMinmax" | ./codeC/execratio | sort -t ";" -k2,2n > "$buffLvMinmax"
            # Vérifier que le fichier a bien 20 lignes
            cat "$buffLvMinmax" | ./codeC/execratio | sort -t ";" -k4,4n | cut -d ";" -f1-3  > "$outputMinmax"
        else
            echo "Le réseau contient moins de 20 postes LV, il n'y aura pas de fichier $outputMinmax"
            # Voir si on fait un tri et un graphique juste dans ce cas
            rm "$buffLvMinmax"
            rm "$outputMinmax"
        fi
    ;;

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
                    #grep -E "^$pwrPlantNbr;-;((-)|([0-9]+));[^-]+;((-)|([0-9]+));((-)|([0-9]+));((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdef > "$outputFileLv"
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;[0-9-]+;[0-9-]+;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileLv"
                    #grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;[0-9-]+;[0-9-]+;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileLv"
                    #grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;[0-9-]+;[0-9-]+;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 |  tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileLv"
                    #grep -E "^$pwrPlantNbr;-;((-)|([0-9]+));[^-]+;((-)|([0-9]+));((-)|([0-9]+));((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' > "$outputFileLv"
                    #outputFileDef="./tmp/buff-lvall-def.dat"
                    #(./codeC/execdef < $outputFileLv ) > $outputFileDef
                    #sort -t ";" -k2,2n "$outputFileDef"
                ;;
                'comp' )
                    # Company consumer data
                    #grep -E "^$pwrPlantNbr;-;((-)|([0-9]+));[^-]+;((-)|([0-9]+));-;((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n ) > "$outputFileLv"
                    #grep -E "^$pwrPlantNbr;-;-|[0-9]+;[^-]+;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f4,7,8 | ./codeC/execdef >> "$outputFileLv"
                    #grep -E "^$pwrPlantNbr;-;((-)|([0-9]+));[^-]+;((-)|([0-9]+));-;((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFilelv"
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;[0-9-]+;-;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileLv"
                    #outputFileDef="./tmp/buff-lvcomp-def.dat"
                    #(./codeC/execdef < $outputFileLv ) > $outputFileDef
                    #sort -t ";" -k2,2n "$outputFileDef"
                ;;
                'indiv' )
                    # Individuals consumers data
                    #grep -E "^$pwrPlantNbr;-;((-)|([0-9]+));[^-]+;-;((-)|([0-9]+));((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileLv"
                    #grep -E "^$pwrPlantNbr;-;-|[0-9]+;[^-]+;-;-|[0-9]+;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f4,7,8 | ./codeC/execdef >> "$outputFileLv"
                    grep -E "^$pwrPlantNbr;-;[0-9-]+;[^-]+;-;[0-9-]+;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f4,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileLv"

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
            #./codeC/execdef < ( grep -E "^$pwrPlantNbr;-|[0-9]+;[^-]+;-;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" "$inputFile" | cut -d ";" -f3,7,8 | sort -t ";" -k2,2n | tr '-' '0' ) > "$outputFileHva"
            
            #grep -E "^$pwrPlantNbr;((-)|([0-9]+));[^-]+;-;((-)|([0-9]+));-;((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileHva"
            grep -E "^$pwrPlantNbr;[0-9-]+;[^-]+;-;[0-9-]+;-;[0-9-]+;[0-9-]+$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileHva"
            # Test ok avec cette commande manque le tri par consommation croissante et nécessité de passer en long int car sinon chiffres négatifs
            #sort -t ";" -k2,2n "$outputFileHva"

            #( grep -E "^$pwrPlantNbr;((-)|([0-9]+));[^-]+;-;((-)|([0-9]+));-;((-)|([0-9]+));((-)|([0-9]+))$" "$inputFile" | cut -d ";" -f3,7,8 | tr '-' '0' ) > "$outputFileHva"
            #outputFileDef="./tmp/buff-hva-def.dat"
            #(./codeC/execdef < $outputFileHva ) > $outputFileDef
            #sort -t ";" -k2,2n "$outputFileDef"

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
            #grep -E "^$pwrPlantNbr;[^-]+;-;-;-|[0-9]+;-;-|[0-9]+;-|[0-9]+$" | cut -d ";" -f2,7,8 >> "$outputFileHvb"
            #grep -E "^$pwrPlantNbr;[^-]+;-;-;((-)|([0-9]+));-;((-)|([0-9]+));((-)|([0-9]+))$" | cut -d ";" -f2,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileHvb"
            #grep -E "^$pwrPlantNbr;[^-]+;-;-;([0-9-]+);-;([0-9-]+);([0-9-]+)$" | cut -d ";" -f2,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileHvb"
            #grep -E "^$pwrPlantNbr;[^-]+;-;-;([0-9-]+);-;([0-9-]+);([0-9-]+)$" "$inputFile" | cut -d ";" -f2,7,8 | tr '-' '0' > "$outputFileHvb"
            #outputFileDef="./tmp/buff-hvb-def.dat"
            #(./codeC/execdef < $outputFileHvb ) > $outputFileDef
            #sort -t ";" -k2,2n "$outputFileDef" > $outputFileDef

            grep -E "^$pwrPlantNbr;[^-]+;-;-;([0-9-]+);-;([0-9-]+);([0-9-]+)$" "$inputFile" | cut -d ";" -f2,7,8 | tr '-' '0' | ./codeC/execdef | sort -t ";" -k2,2n > "$outputFileHvb"

           
            # Success
            echo "Extraction terminée. Les données HV-B des postes et des consommateurs sont dans $outputFileHvb"
        ;;  
    
    
    # [0-9-]+

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