set datafile separator ','
set key autotitle columnhead # use the first line as title
set grid ls 100 
set style line 100 lt 1 lc rgb "yellow" lw 3
set style line 101 lt 1 lc rgb "black" lw 0.5 # style for measuredValue (2) (light blue)
set style line 102 lt 2 lc rgb "blue" lw 2


set y2tics # enable second axis
set ytics nomirror # dont show the tics on that side

set y2label "Pacing rate(MBps)" 
set xlabel "Time(sec)" 
#set logscale y
x0 = y0 = NaN


plot 'dyn_pacing.csv' using ($7!=1 ? (y0=$8*1e-6,x0=$5*1e-3) : x0):(y0) with linespoints ls 100 title "NEW_FLOW_RATE", \
 ''  using ($7!=2 ? (y0=$9*1e-6,x0=$5*1e-3) : x0):(y0) with linespoints ls 101 axis x1y2 title "SUM_RATE",\
''  using ($7!=2 ? (y0=$11*1e-6,x0=$5*1e-3) : x0):(y0) with line ls 102 title "NEW_SESSION_RATE"


#plot 'dyn_pacing.csv' using ($7!=1 ? (y0=$8*1e-6,x0=$5*1e-3) : x0):(y0) with linespoints ls 100, ''  using ($7!=2 ? (y0=$9*1e-6,x0=$5*1e-3) : x0):(y0) with linespoints ls 101 axis x1y2, ''  using ($7!=2 ? (y0=$11*1e-6,x0=$5*1e-3) : x0):(y0) with line ls 102
#plot 'dyn_pacing.csv' using ($7!=1 ? (y0=$8*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 100, ''  using ($7!=2 ? (y0=$9*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 101 axis x1y2, ''  using ($7!=2 ? (y0=$11*1e-6,x0=$5*1e-6) : x0):(y0) with linespoints ls 102

#Don't change below base version
#plot 'dyn_pacing.csv' using 5:8 with linespoints ls 100, '' using 5:9 with linespoints ls 101 axis x1y2, '' using 5:11 with line ls 102

