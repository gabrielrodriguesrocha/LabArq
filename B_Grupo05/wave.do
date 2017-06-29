wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 10000ps sim:/projetofinal/reset
wave create -driver freeze -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 10000ps sim:/projetofinal/clockPB
wave edit insert_pulse -duration 425ps -time 0ps Edit:/projetofinal/reset
add wave  \
sim:/projetofinal/DataInstr \
sim:/projetofinal/PCAddr \
sim:/projetofinal/DMemoryOut \
sim:/projetofinal/auxAluOp \
sim:/projetofinal/EXE/Alu_ctl
sim:/projetofinal/ALUResult \
sim:/projetofinal/readData1 \
sim:/projetofinal/readData2