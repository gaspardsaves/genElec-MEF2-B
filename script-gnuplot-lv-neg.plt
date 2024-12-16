# Graphs generation function

# Histogram image generation
    set terminal pngcairo size 1000,600 enhanced font "Arial,12"
    set output graphOutput

# Display management
    set style fill solid 0.8 border -1
    set boxwidth 0.9
    set grid

# Title and legend management
    set xlabel 'Identifiant du poste'
    set ylabel 'Capacité théorique (bleu) et surconsommation (rouge)'
    set title 'Histogramme de charge des postes LV les plus chargés'
    set xtics rotate by -45 font "Arial,10"

# Clarification on reading the .csv file
    set datafile separator ":"
    set key autotitle columnhead

# Complete graphic creation with conditions on selected colors
    plot dataFile using 3:xtic(1) with boxes title "Surconsommation" lc rgb "red", \
     '' using 2:xtic(1) with boxes title "Capacité théorique du poste" lc rgb "blue"