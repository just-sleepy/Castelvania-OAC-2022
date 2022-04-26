.data
PLAYER_LOOK:    .byte 0 	#(0: olhando para direita, 1: olhando para esquerda)

ATTACKING:	.byte 0 #(0 = not attacking, 1 = attacking)

PLAYER_STANCE:	.half 0

MOVING:		.byte 0

RUNNING:	.byte 0	#(0: andando, 1: correndo)


.text


STANCE:
	la t3, PLAYER_STANCE
	lh t1, 0(t3)
	
	la t4, PLAYER_LOOK
	

	
	li a6, 0
	li a7, 0
	
	
	#Attack
	la t0, ATTACKING
	lb t2, 0(t0)
	bne t2, zero, ATTACK_A	#se jump = 1 ou stance < 0
		

	#Jump
	la t0, JUMP
	lb t2, 0(t0)
	bne t2, zero, JUMP_A	#se jump = 1 ou stance < 0
	
	
	
	#Running
	la t0, RUNNING
	lb t2, 0(t0)
	beqz t2, RUN_JJ	#If RUNNING != 0, comeca animacao de correr
	la t0, MOVING
	lb t2, 0(t0)
	bne t2, zero, RUN
					
	RUN_JJ:
	
	
	
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
	addi a6, a6, 0
	li a7, 9
	lb t0, 0(t4)
	beq t0, zero,Stance0_J
	addi a6, a6, 917
	addi a7, a7, -2
		Stance0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Stance1:
	addi a6, a6, 31
	li a7, 9
	lb t0, 0(t4)
	beq t0, zero,Stance1_J
	addi a6, a6, 855
	addi a7, a7, -2
		Stance1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Stance2:
	addi a6, a6, 63
	li a7, 9
	lb t0, 0(t4)
	beq t0, zero,Stance2_J
	addi a6, a6, 791
	addi a7, a7, -2
		Stance2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Stance3:
	addi a6, a6, 99
	li a7, 9
	lb t0, 0(t4)
	beq t0, zero,Stance3_J
	addi a6, a6, 719
	addi a7, a7, -2
		Stance3_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Stance4:
	addi a6, a6, 0
	li a7, 9
	lb t0, 0(t4)
	beq t0, zero,Stance4_J
	addi a6, a6, 917
	addi a7, a7, -2
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
j RUN
ret
	
	Walk0:
	addi a6, a6, 1
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk0_J
	addi a6, a6, 918
	addi a7, a7, -3
		Walk0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk1:
	addi a6, a6, 33
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk1_J
	addi a6, a6, 854
	addi a7, a7, -3
		Walk1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Walk2:
	addi a6, a6, 62
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk2_J
	addi a6, a6, 795
	addi a7, a7, -3
		Walk2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Walk3:
	addi a6, a6, 92
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk3_J
	addi a6, a6, 731
	addi a7, a7, -3
		Walk3_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	Walk4:
	addi a6, a6, 129
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk4_J
	addi a6, a6, 660
	addi a7, a7, -3
		Walk4_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
																																																																					
	Walk5:
	addi a6, a6, 159
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk5_J
	addi a6, a6, 603
	addi a7, a7, -3
		Walk5_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk6:
	addi a6, a6, 188
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk6_J
	addi a6, a6, 544
	addi a7, a7, -3
		Walk6_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk7:
	addi a6, a6, 215
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk7_J
	addi a6, a6, 490
	addi a7, a7, -3
		Walk7_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Walk8:
	addi a6, a6, 1
	li a7, 147
	lb t0, 0(t4)
	beq t0, zero,Walk8_J
	addi a6, a6, 918
	addi a7, a7, -3
		Walk8_J:
		li t1, 17
		sh t1, 0(t3)
		ret
	

	
RUN:	
li t0, 52		#Se a stance for menor ou igual a 52, inicia a stance de correr em 53
bge t1, t0, RUNNING_INIT
li t1, 53
sh t1, 0(t3)		
			
				
RUNNING_INIT:																																																																		
li t0, 55
bge t0, t1, Run0
li t0, 57
bge t0, t1, Run1
li t0, 60
bge t0, t1, Run2
li t0, 64
bge t0, t1, Run3
li t0, 67
bge t0, t1, Run4
li t0, 70
bge t0, t1, Run5
li t0, 73
bge t0, t1, Run6
li t0, 76
bge t0, t1, Run7
li t0, 79
bge t0, t1, Run8
ret					
						
							
								
	Run0:
	addi a6, a6, 1
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run0_J
	addi a6, a6, 918
	addi a7, a7, -2
		Run0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Run1:
	addi a6, a6, 36
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run1_J
	addi a6, a6, 845
	addi a7, a7, -2
		Run1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Run2:
	addi a6, a6, 72
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run2_J
	addi a6, a6, 774
	addi a7, a7, -2
		Run2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret

	Run3:
	addi a6, a6, 110
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run3_J
	addi a6, a6, 699
	addi a7, a7, -2
		Run3_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret									
										
	Run4:
	addi a6, a6, 141
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run4_J
	addi a6, a6, 637
	addi a7, a7, -2
		Run4_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret																									
																	
	Run5:
	addi a6, a6, 178
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run5_J
	addi a6, a6, 565
	addi a7, a7, -2
		Run5_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret																			
	
	Run6:
	addi a6, a6, 217
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run6_J
	addi a6, a6, 488
	addi a7, a7, -2
		Run6_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret																																										
	
	Run7:
	addi a6, a6, 255
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run7_J
	addi a6, a6, 411
	addi a7, a7, -2
		Run7_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret																						
	
	Run8:
	addi a6, a6, 1
	li a7, 195
	lb t0, 0(t4)
	beq t0, zero,Run8_J
	addi a6, a6, 918
	addi a7, a7, -2
		Run8_J:
		li t1, 53
		sh t1, 0(t3)
		ret																																																																																																																														
																								
JUMP_A:	

#Confere se o boost acabou pra continuar animacao
la t0, JUMP_BOOST_LIMIT	
lb t2, 0(t0)
li t5, BOOST_LIMIT
bge t2, t5, JUMP_MID	#Boost acabou chegando em 12
bge zero, t2, JUMP_MID	#Boost igual a -1

#Se a stance for menor ou igual a 0, inicia a stance de pula em -1
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
	addi a6, a6, 1		
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump0_J
	addi a6, a6, 915
	addi a7, a7, -2
		Jump0_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret
		
	Jump1:
	addi a6, a6, 30		
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump1_J
	addi a6, a6, 856
	addi a7, a7, -2
		Jump1_J:
		li t1, -9
		sh t1, 0(t3)
		ret	

	Jump2:
	addi a6, a6, 63		
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump2_J
	addi a6, a6, 784
	addi a7, a7, -2
		Jump2_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret	

	Jump3:
	addi a6, a6, 107
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump3_J
	addi a6, a6, 701
	addi a7, a7, -2
		Jump3_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret	
	
	Jump4:
	addi a6, a6, 142
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump4_J
	addi a6, a6, 631
	addi a7, a7, -2
		Jump4_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret	
		
	Jump5:
	addi a6, a6, 192
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Jump5_J
	addi a6, a6, 532
	addi a7, a7, -2
		Jump5_J:
		addi t1, t1, -1
		sh t1, 0(t3)
		ret
		
	Falling:
	addi a6, a6, 237
	li a7, 98
	lb t0, 0(t4)
	beq t0, zero,Falling_J
	addi a6, a6, 443
	addi a7, a7, -2
		Falling_J:
		li t1, -23
		sh t1, 0(t3)
		ret					

ATTACK_A:
li t0, 80		#Se a stance for maior ou igual a 80, inicia a stance de correr em 81
bge t1, t0, ATTACK_INIT
li t1, 81
sh t1, 0(t3)	
		

ATTACK_INIT:																																																																		
li t0, 85
bge t0, t1, Atk0
li t0, 89
bge t0, t1, Atk1
li t0, 93
bge t0, t1, Atk2
li t0, 97
bge t0, t1, Atk3
li t0, 104
bge t0, t1, Atk4
li t0, 111
bge t0, t1, Atk5
li t0, 118
bge t0, t1, Atk6
li t0, 124
bge t0, t1, Atk7
li t0, 128
bge t0, t1, Atk8
ret		

	Atk0:
	addi a6, a6, 0
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk0_J
	addi a6, a6, 916
	addi a7, a7, 0
		Atk0_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
		
	Atk1:
	addi a6, a6, 31
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk1_J
	addi a6, a6, 855
	addi a7, a7, 0
		Atk1_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret	
		
	Atk2:
	addi a6, a6, 61
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk2_J
	addi a6, a6, 794
	addi a7, a7, 0
		Atk2_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
		
	Atk3:
	addi a6, a6, 87
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk3_J
	addi a6, a6, 703
	addi a7, a7, 0
		Atk3_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret				
	
	Atk4:
	addi a6, a6, 129
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk4_J
	addi a6, a6, 660
	addi a7, a7, 0
		Atk4_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		
		ret
		
	Atk5:
	addi a6, a6, 164
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk5_J
	addi a6, a6, 589
	addi a7, a7, 0
		Atk5_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		
		ret
		
		
	Atk6:
	addi a6, a6, 201
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk6_J
	addi a6, a6, 515
	addi a7, a7, 0
		Atk6_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret						
	
	Atk7:
	addi a6, a6, 238
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk7_J
	addi a6, a6, 442
	addi a7, a7, 0
		Atk7_J:
		addi t1, t1, 1
		sh t1, 0(t3)
		ret
	
	Atk8:
	addi a6, a6, 238
	li a7, 793
	lb t0, 0(t4)
	beq t0, zero,Atk8_J
	addi a6, a6, 442
	addi a7, a7, 0
		Atk8_J:
		la t0, ATTACKING
		sb zero, 0(t0)
		la t0, WHIP
		sb zero, 0(t0)
		sh zero, 0(t3)
		ret