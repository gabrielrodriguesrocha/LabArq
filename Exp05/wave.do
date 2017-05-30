wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 4000ps sim:/exp05/reset
wave create -driver freeze -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 4000ps sim:/exp05/clock
wave edit insert_pulse -duration 425ps -time 0ps Edit:/exp05/reset
add wave  \
sim:/exp05/DataInstr \
sim:/exp05/PCAddr \
sim:/exp05/DMemoryOut \
sim:/exp05/auxAluOp