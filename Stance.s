.data
PLAYER_LOOK:    .byte 0 	#(0: olhando para direita, 1: olhando para esquerda)
PLAYER_STANCE:	.half 0
MOVING:		.byte 0
RUNNING:	.byte 0		#(0: andando, 1: correndo)
V: 		.string " aaaaaaaa "
.text

.eqv BOOST_LIMIT 	12

STANCE:
	la t3, PLAYER_STANCE
	lh t1, 0(t3)
	
	la t4, PLAYER_LOOK
	

	
	li a6, 0
	li a7, 0
		
	#Jump
	la t0, JUMP
	lb t2, 0(t0)
	bne t2, zero, JUMP_A	#se jump = 1 ou stance < 0
	
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

la t0, RUNNING
lb t2, 0(t0)
bnez t2, RUNNING_INIT	#If RUNNING != 0, comeca animacao de correr																					
																																																																		
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
	

	
		
			
				
RUNNING_INIT:																																																																		
li t0, 20
bge t0, t1, Run0
li t0, 24
bge t0, t1, Run1
li t0, 28
bge t0, t1, Run2
li t0, 32
bge t0, t1, Run3
li t0, 36
#bge t0, t1, Run4
li t0, 40
#bge t0, t1, Run5
li t0, 44
#bge t0, t1, Run6
li t0, 48
#bge t0, t1, Run7
li t0, 52
#bge t0, t1, Run8
ret					
						
							
								
	Run0:
	addi a6, a6, 3
	li a7, 200
	lb t0, 0(t4)
	beq t0, zero,Run0_J
	addi a6, a6, 922
	addi a7, a7, -1
		Run0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Run1:
	addi a6, a6, 31
	li a7, 200
	lb t0, 0(t4)
	beq t0, zero,Run1_J
	addi a6, a6, 849
	addi a7, a7, -2
		Run1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Run2:
	addi a6, a6, 69
	li a7, 200
	lb t0, 0(t4)
	beq t0, zero,Run2_J
	addi a6, a6, 795
	addi a7, a7, -2
		Run2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Run3:
	addi a6, a6, 101
	li a7, 199
	lb t0, 0(t4)
	beq t0, zero,Run3_J
	addi a6, a6, 728
	addi a7, a7, -2
		Run3_J:
		li t1, 17
		sh t1, 0(t3)
		ret									
										
																										
																		
																			
																				
																					
																						
																								
JUMP_A:	

#Confere se o boost acabou pra continuar animacao
la t0, JUMP_BOOST_LIMIT	
lb t2, 0(t0)
li t5, BOOST_LIMIT
bge t2, t5, JUMP_MID	#Boost acabou chegando em 12
bge zero, t2, JUMP_MID	#Boost igual a -1

#Se a stance for menor ou igual a 52, inicia a stance de pula em 53
blt t1, zero, JUMP_INIT
li t1, -1
sh t1, 0(t3)	

JUMP_INIT:
li t0, -8
bge t1, t0, Jump0

li t0, -9
bge t1, t0, Jump1


JUMP_MID:
li t0, -12
bge t1, t0, Jump2

li t0, -14
bge t1, t0, Jump3

li t0, -17
bge t1, t0, Jump4

li t0, -20
bge t1, t0, Jump5


JUMP_FALLING:
li t0, -23
bge t1, t0, Falling
ret


	Jump0:
	addi a6, a6, 7		
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump0_J
	addi a6, a6, 914
	addi a7, a7, -2
		Jump0_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret
		
	Jump1:
	addi a6, a6, 35		
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump1_J
	addi a6, a6, 859
	addi a7, a7, -2
		Jump1_J:
		li t1, -9
		sh t1, 0(t3)
		ret	

	Jump2:
	addi a6, a6, 61		
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump2_J
	addi a6, a6, 807
	addi a7, a7, -2
		Jump2_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret	

	Jump3:
	addi a6, a6, 84	
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump3_J
	addi a6, a6, 761
	addi a7, a7, -2
		Jump3_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret	
	
	Jump4:
	addi a6, a6, 108
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump4_J
	addi a6, a6, 713
	addi a7, a7, -2
		Jump4_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret	
		
	Jump5:
	addi a6, a6, 136
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump5_J
	addi a6, a6, 655
	addi a7, a7, -2
		Jump5_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret
		
	Falling:
	addi a6, a6, 166
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Falling_J
	addi a6, a6, 595
	addi a7, a7, -2
		Falling_J:
		li t1, -23
		sh t1, 0(t3)
		ret					