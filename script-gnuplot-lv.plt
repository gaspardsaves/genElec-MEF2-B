# Graphs generation function

# Histogram image generation
    set terminal pngcairo size 1000,600 enhanced font "Arial,12"
    set output graphOutput

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
    plot dataFile using 1:3:($3 < 0 ? 1 : 2):xtic(2) with boxes lc variable notitle
    #plot graphOutput using 1:3:($3 < 0 ? 0 : 1):xtic(2) with boxes lc variable notitle
    #plot graphOutput using 1:3:($3 < 0 ? 'red' : 'green'):xtic(2) with boxes lc variable notitle
    # plot graphOutput using 1:3:(($3 < 0) ? 1 : 2) with boxes lc rgb 'red' notitle, dataFile using 1:3:((\$3 > 0) ? 1 : 2) with boxes lc rgb 'green' notitle