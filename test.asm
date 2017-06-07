.text
	addi $t0, $zero, 8
	addi $t1, $zero, 9
	and $t2, $t0, $t1
	or $t2, $t0, $t1
	add $t2, $t0, $t1
	sub $t2, $t0, $t1
	slt $t2, $t1, $t0
	add $t2, $zero, $t0
.L1:
	beq $t1, $t2, .L3
	beq $t0, $t2, .L2
	add $t4, $t2, $t1
.L2:
	bne $t0, $t2, .L1
	add $t2, $zero, $t1
	bne $t0, $t1, .L1
.L3:
	jal .L4
	j .exit
.L4:
	jr $ra
.exit: