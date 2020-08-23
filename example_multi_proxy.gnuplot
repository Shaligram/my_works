set datafile separator ','
set key autotitle columnhead # use the first line as title
set grid ls 100 
set style line 100 lt 1 lc rgb "black" lw 0.5 # style for measuredValue (2) (light blue)
set style line 102 lt 1 lc rgb "blue" lw 1.0
set style line 101 lt 1 lc rgb "yellow" lw 1.5


set y2tics # enable second axis
set ytics nomirror # dont show the tics on that side

set y2label "Pacing rate(1MBps)" 
set xlabel "Time(millisec)" 
#set logscale y

set multiplot layout 2,1  title "generated with gnuplot 4.6"
#set multiplot layout 2,2 upwards

# this works with gnuplot 4.x and 5.x
x0 = y0 = NaN
#
#set xtics ("0" 0, "10" 1e9, "20" 2e9)
#plot 'dyn_pacing.csv' using 5:10 with linespoints ls 100, '' using 5:11 with linespoints ls 102 axis x1y2, '' using 5:6 with line ls 101
#plot 'dyn_pacing.csv' using ($7==0 ? (y0=$11*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 100, '' using ($7==0 ? (y0=$12*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 102 axis x1y2

#do for [id=0:3] {
x0 = y0 = NaN
set origin 0.0,0.0
plot 'proxy_ue.csv' using (stringcolumn(6) eq "TXUE" && $9==0 ? (y0=$10*1e-6,x0=$5*1e-6) : x0):(y0) with lines ls 100 title sprintf('proxyId %d',0), '' using (stringcolumn(6) eq "TXUE" && $9==1 ? (y0=$10*1e-6,x0=$5*1e-6) : x0):(y0) with lines ls 101 title sprintf('proxyId %d',1), '' using (stringcolumn(6) eq "TXUE" && $9==2 ? (y0=$10*1e-6,x0=$5*1e-6) : x0):(y0) with lines ls 102 title sprintf('proxyId %d',2)
#}


set origin 0.0,0.5
plot 'proxy_ue.csv' using (stringcolumn(6) eq "TXUE" ? (y0=$11*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 101 title sprintf('proxyId %d',2), '' using (stringcolumn(6) eq "TXUE" ? (y0=$12*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 102 title sprintf('proxyId %d',2)
#}



#plot 'dyn_pacing.csv' using (stringcolumn(6) eq "TXUE" && $9==0 ? (y0=$9*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 100
#, '' using ($7==0 ? (y0=$12*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 102 axis x1y2

set origin 0.0,0.0
#plot 'dyn_pacing.csv' using ($7==2 ? (y0=$11*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 100, ''  using ($7==2 ? (y0=$12*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 102 axis x1y2

unset multiplot

#plot 'dyn_pacing.csv' using 5:10 with linespoints ls 100, '' using 5:11 with linespoints ls 102 axis x1y2, '' using 5:6 with line ls 101
