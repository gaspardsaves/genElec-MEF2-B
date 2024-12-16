# Graphs generation function

# Histogram image generation
    set terminal pngcairo size 1000,600 enhanced font "Arial,12"
    set output graphOutput

# Display management
    set style fill solid 0.8 border -1
    #set style line 1 lc rgb "red"
    #set style line 2 lc rgb "green"
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
    
    #plot dataFile using (($4 > 0) ? ($2 > $3 ? $2 : 0) : NaN):xtic(1) with boxes title "Sous-consommation" lc rgb "green", \
     #'' using (($4 > 0) ? $3 : 0):xtic(1) with boxes title "Capacité" lc rgb "blue", \
     #'' using (($4 <= 0) ? $2 : 0):xtic(1) with boxes title "Capacité" lc rgb "blue", \
     #'' using (($4 <= 0) ? ($2 >= $3 ? $2 : 0) : NaN):xtic(1) with boxes title "Surconsommation" lc rgb "red"

    #plot dataFile using ($2 > $3 ? $2 : 0):xtic(1) with boxes title "Sous-consommation" lc rgb "green", \
     #'' using ($3 > $2 ? $3 : 0):xtic(1) with boxes title "Surconsommation" lc rgb "red", \
     #'' using ($2 >= $3 ? $2 : 0):xtic(1) with boxes title "Capacité" lc rgb "grey"
    #plot dataFile using 1:3:($3 < 0 ? 1 : 2):xtic(2) with boxes title 'Consommation normale' lc rgb "green", '' using ($3 < 0 ? 1 : 2):xtic(1) with boxes title 'Surconsommation' lc rgb "red"
    #plot dataFile using ($3 > $2 ? $2 : $3):xtic(2) with boxes title 'Capacité' lc rgb "grey", '' using ($3 > $2 ? $3-$2 : 0):xtic(1) with boxes title 'Surconsommation' lc rgb "red", '' using ($3 > $2 ? $3-$2 : 0):xtic(1) with boxes title 'Sous-consommation' lc rgb "green"
    #plot dataFile using 1:3:($3 < 0 ? 1 : 2):xtic(2) with boxes lc variable notitle
    #plot graphOutput using 1:3:($3 < 0 ? 0 : 1):xtic(2) with boxes lc variable notitle
    #plot graphOutput using 1:3:($3 < 0 ? 'red' : 'green'):xtic(2) with boxes lc variable notitle
    # plot graphOutput using 1:3:(($3 < 0) ? 1 : 2) with boxes lc rgb 'red' notitle, dataFile using 1:3:((\$3 > 0) ? 1 : 2) with boxes lc rgb 'green' notitle

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

set terminal pngcairo size 800,600
set output "./graphs/bar.png"
set boxwidth 0.5
set style fill solid 0.5 border -1
set ylabel "ratio"
set xlabel "ID"
set yrange [0:*] 
set xtic font 'arial,12'
set ytic font 'arial,10'
set title "Graphique en bâtons"
set grid
set boxwidth 1
set style data histograms
set style histogram cluster gap 1
set style fill solid noborder
set style line 1 lc rgb 'red'
set style line 2 lc rgb 'green' 
set datafile separator ";"  
set key autotitle columnhead  
set xtics rotate by -45 
plot "test.csv" using 1:($2 > 0 ? abs($2) : abs($2)):(column(2) > 0 ? 1 : 2) with boxes lc variable notitle