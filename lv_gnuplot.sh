set terminal pngcairo size 800,600
set output "bar.png"
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