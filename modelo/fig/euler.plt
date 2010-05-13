#!/usr/bin/env gnuplot

set terminal postscript eps monochrome 20

set xrange [-4.1:0.1]
set yrange [0:1]
set xtics 1
set ytics 0.1
set xlabel "-E/T"
set ylabel "e ** (-E/T)"
set key box

euler(x) = 2.71828182845904523536 ** x
some_quadratic_function(x) = 0.1 * x**2

#set output "euler.eps"
plot euler(x) title "Euler", \
     some_quadratic_function(x) title "Some Quadratic Function"

