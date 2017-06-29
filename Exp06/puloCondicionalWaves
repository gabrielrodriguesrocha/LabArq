onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /exp06/reset
add wave -noupdate /exp06/clockPB
add wave -noupdate -radix hexadecimal /exp06/DataInstr
add wave -noupdate -radix hexadecimal /exp06/PCAddr
add wave -noupdate -radix hexadecimal /exp06/readData1
add wave -noupdate -radix hexadecimal /exp06/readData2
add wave -noupdate /exp06/SignExtend
add wave -noupdate /exp06/auxAluSrc
add wave -noupdate /exp06/auxBranch
add wave -noupdate /exp06/auxZero
add wave -noupdate /exp06/auxAddResult
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {844 ps}
view wave 
wave clipboard store
wave create -driver freeze -pattern constant -value 0 -starttime 0ps -endtime 2000ps sim:/exp06/reset 
wave create -driver freeze -pattern clock -initialvalue 1 -period 100ps -dutycycle 50 -starttime 0ps -endtime 2000ps sim:/exp06/clockPB 
wave edit insert_pulse -duration 425ps -time 0ps Edit:/exp06/reset 
WaveCollapseAll -1
wave clipboard restore
