wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10000ps sim:/exp06/reset
wave create -driver freeze -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 10000ps sim:/exp06/clockPB
wave edit insert_pulse -duration 425ps -time 0ps Edit:/exp06/reset
add wave  \
sim:/exp06/DataInstr \
sim:/exp06/PCAddr \
sim:/exp06/DMemoryOut \
sim:/exp06/auxAluOp \
sim:/exp06/EXE/Alu_ctl