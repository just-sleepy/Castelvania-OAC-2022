.data
PLAYER_LOOK:    .byte 0 	#(0: olhando para direita, 1: olhando para esquerda)
PLAYER_STANCE:	.half 0
MOVING:		.byte 0
V: 		.string " aaaaaaaa "
.text

STANCE:
	la t3, PLAYER_STANCE
	lh t1, 0(t3)
	
	la t4, PLAYER_LOOK
	

	
	li a6, 0
	li a7, 0
	
	#Walk
	la t0, MOVING
	lb t2, 0(t0)
	bne t2, zero, WALK

	
	#Stand
	li t0, 16
	bge t0, t1, STAND

STAND:

bge zero, t1, Stance0
li t0, 4
bge t0, t1, Stance1
li t0, 8
bge t0, t1, Stance2
li t0, 12
bge t0, t1, Stance3
li t0, 16
bge t0, t1, Stance4
ret
#Determina a posicao do sprite de acordo com sua stance 
	Stance0:
	addi a6, a6, 8
	li a7, 10
	lb t0, 0(t4)
	beq t0, zero,Stance0_J
	addi a6, a6, 912
	addi a7, a7, -1
		Stance0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Stance1:
	addi a6, a6, 30
	li a7, 10
	lb t0, 0(t4)
	beq t0, zero,Stance1_J
	addi a6, a6, 868
	addi a7, a7, -1
		Stance1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Stance2:
	addi a6, a6, 52
	li a7, 10
	lb t0, 0(t4)
	beq t0, zero,Stance2_J
	addi a6, a6, 824
	addi a7, a7, -1
		Stance2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Stance3:
	addi a6, a6, 74
	li a7, 10
	lb t0, 0(t4)
	beq t0, zero,Stance3_J
	addi a6, a6, 780
	addi a7, a7, -1
		Stance3_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Stance4:
	addi a6, a6, 8
	li a7, 10
	lb t0, 0(t4)
	beq t0, zero,Stance4_J
	addi a6, a6, 912
	addi a7, a7, -1
		Stance4_J:
		li t1, 0
		sh t1, 0(t3)
		ret

WALK:	
li t0, 16		#Se a stance for menor ou igual a 16, inicia a stance de correr em 17
bge t1, t0, WALK_INIT
li t1, 17
sh t1, 0(t3)
																						
WALK_INIT:																																																																		
li t0, 20
bge t0, t1, Walk0
li t0, 24
bge t0, t1, Walk1
li t0, 28
bge t0, t1, Walk2
li t0, 32
bge t0, t1, Walk3
li t0, 36
bge t0, t1, Walk4
li t0, 40
bge t0, t1, Walk5
li t0, 44
bge t0, t1, Walk6
li t0, 48
bge t0, t1, Walk7
li t0, 52
bge t0, t1, Walk8
ret
	
	Walk0:
	addi a6, a6, 5
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk0_J
	addi a6, a6, 917
	addi a7, a7, -2
		Walk0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk1:
	addi a6, a6, 39
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk1_J
	addi a6, a6, 849
	addi a7, a7, -2
		Walk1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Walk2:
	addi a6, a6, 69
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk2_J
	addi a6, a6, 795
	addi a7, a7, -2
		Walk2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Walk3:
	addi a6, a6, 101
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk3_J
	addi a6, a6, 728
	addi a7, a7, -2
		Walk3_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	Walk4:
	addi a6, a6, 131
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk4_J
	addi a6, a6, 664
	addi a7, a7, -2
		Walk4_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
																																																																					
	Walk5:
	addi a6, a6, 167
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk5_J
	addi a6, a6, 595
	addi a7, a7, -2
		Walk5_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk6:
	addi a6, a6, 196
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk6_J
	addi a6, a6, 539
	addi a7, a7, -2
		Walk6_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk7:
	addi a6, a6, 221
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk7_J
	addi a6, a6, 487
	addi a7, a7, -2
		Walk7_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk8:
	addi a6, a6, 5
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk8_J
	addi a6, a6, 917
	addi a7, a7, -2
		Walk8_J:
		li t1, 17
		sh t1, 0(t3)
		ret
	
	
