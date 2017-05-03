wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 1000ps sim:/exp03/reset
wave create -driver freeze -pattern clock -initialvalue 0 -period 100ps -dutycycle 50 -starttime 0ps -endtime 1000ps sim:/exp03/clock
add wave  \
sim:/exp03/saidaDmemory
add wave  \
sim:/exp03/auxMemRead