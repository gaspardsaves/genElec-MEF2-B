#histogram image generation
set terminal pngcairo size 1000,600
set output "bar.png"


#bar display management
set style fill solid 0.8 border -1
set style line 1 lc rgb 'red'
set style line 2 lc rgb 'green'
set boxwidth 0.9

set grid

#title and legend management
set xlabel 'ID'
set ylabel 'CONSO'
set title 'Histogramme des consommation'
set xtics rotate by -45 font "Arial,10"

#clarification on reading the .csv file
set datafile separator ":"
set key autotitle columnhead

#complete graphic creation with conditions on selected colors
plot 'test.csv' using 2:($2):($2 <= 0 ? 1 : 2):xtic(1) with boxes lc variable notitle

