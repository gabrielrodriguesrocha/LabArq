transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {E:/Exp01/LCD_Display.vhd}
vcom -93 -work work {E:/Exp01/Ifetch.vhd}
vcom -93 -work work {E:/Exp01/Exp01.vhd}

