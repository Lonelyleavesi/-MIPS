.data
	a: .word 3
.text 0x0000
start:lui 	$1,0xffff
	andi	$28,$1,0xF000
switled:
	lw 	$1,0xC20($28)
	addi	$9,$0, 1 
	slt 	$8, $1, $9
	sw	$8,0xC60($28)
	j	switled