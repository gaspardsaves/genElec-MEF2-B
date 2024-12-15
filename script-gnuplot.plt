# Histogram image generation
set terminal pngcairo size 1000,600
set output "./graphs/lv_all_minmax.png"


# Display management
set style fill solid 0.8 border -1
set style line 1 lc rgb 'red'
set style line 2 lc rgb 'green'
set boxwidth 0.9

set grid

# Title and legend management
set xlabel 'Identifiant du poste'
set ylabel 'Consommation nette'
set title 'Histogramme de consommation nette'
set xtics rotate by -45 font "Arial,10"

# Clarification on reading the .csv file
set datafile separator ":"
set key autotitle columnhead

# Complete graphic creation with conditions on selected colors
plot './tmp/buff_plt_lv_all_minmax.csv' using 2:($2):($2 <= 0 ? 1 : 2):xtic(1) with boxes lc variable notitle