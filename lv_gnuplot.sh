set terminal pngcairo size 800,600
set output "bar.png"

set datafile separator ","
set style data histograms
set style fill solid 1.00 border -1
set xlabel "lv"
set ylabel "value"
set title "baton"
set grid

plot "f_x.csv" using 2:xtic(1) every ::0::1 title "value" lc rgb "red", \
 "f_x.csv" using 2:xtic(1) every ::2::3 title "value" lc rgb "green"