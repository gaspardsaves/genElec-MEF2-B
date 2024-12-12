set terminal pngcairo size 800,600
set output "bar.png"

set boxwidth 0.5
set style fill solid 0.5 border -1
set yrange [0:*]
set xlabel "Categorie"
set ylabel "Valeur"
set title "Graph baton"

set style line 1 lc rgb '#FF0000'
set style line 2 lc rgb '#00FF00'

plot "test.csv" using  0:2:(column(2) > 25 ? 1 : 2) with boxes linecolor variable title "graph col"