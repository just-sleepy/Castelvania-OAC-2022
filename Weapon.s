.data
	
		

WHIP: 			.byte 0 #(0 = chicote n ativado, 1 = ativafo)
WHIP_size:		.half 48, 10
Whip_HITBOX:		.half 0, 0

SHURIKEN_POWER: 	.byte 0 #(0 = churiken n ativado, 1>  ativo, também determina o alcance)
SHURIKEN_size:		.half 16, 16
Shuriken_HITBOX:	.half 0, 0

.text



SHURIKEN_T:	la t0, Shuriken_HITBOX
		#Posicao y
		lw t1, 2(t0)		#carrega y
		#Posicao x
		lw t2, 0(t0)		#carrega x
		
		la t0, SHURIKEN_POWER
		#Alncace
		lb t5, 0(t0)
		
		#------------------------------Se esta dentro da tela do jogador-----------------------------------------------------
		#posicao mapa x(s3) <= enemy x(t2) and s3 + screen width >= t2 + enemy_width
		blt t2, s3, NOT_IN_SCREEN2
		addi t3, s3, SCREEN_WIDTH #t3 = s3 + screen width
		addi t4, t2, 30
		blt t3, t4, NOT_IN_SCREEN2
		#posicao mapa y(s4) <= enemy y(t1) and s4 + screen height >= t1 + enemy height
		blt t1, s4, NOT_IN_SCREEN2
		addi t3, s4, SCREEN_WIDTH #t3 = s4 + screen height
		addi t4, t1, 30
		blt t3, t4, NOT_IN_SCREEN2
		
		#Calcular posicao no mapa
		#enemy x(t2) - posicao mapa x(s3)  
		sub a1, t2, s3
		#enemy y(t1) - posicao mapa y(s4)  
		sub a2, t1, s4	
		j SHURIKEN_COLLISION
		#---------------------------------------------------------------------------------------------------------------
		NOT_IN_SCREEN2:
		li a1, 100
		li a2, 100
		
		SHURIKEN_COLLISION:
		la t0, PLAYER_POS
		lb t3, 0(t0)
		bge t2, t3, SHURIKEN_DIR
		addi t2, t2, -5	#Shuriken indo para esquerda
		j SPRITE_SHURIKEN
		
		SHURIKEN_DIR:
		addi t2, t2, 5	#Shuriken indo para direita
		
		SPRITE_SHURIKEN:
		li a6, 21
		li a7, 157
		
		addi t5, t5, -1 	#diminue alcance
		beqz t5, FIM_SHURIKEN2	#Acabou o alcance do shuriken	
		
		la t0, Shuriken_HITBOX
		sh t2, 0(t0)
		sh t1, 2(t0)
																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																		
		
		FIM_SHURIKEN:
		ret
		
		FIM_SHURIKEN2:
		la t0, SHURIKEN_POWER
		sb zero, 0(t0)
		ret
################### WEAPON_POS #################################
#								#
#################################################################
WEAPON_POS: 
#Zera pos hitbox do chicote
la t0, Whip_HITBOX
sh t1, 0(t0)
sh t1, 2(t0)


la t0, WHIP
lb t1, 0(t0)
la t4, PLAYER_LOOK
bnez t1, WHIP_POS #se whip ativo vai pra whip



WHIP_POS:
la t0, PLAYER_STANCE
lh t1, 0(t0)
la a4, WHIP_size

lb t0, 0(t4)
beq t0, zero, WHIP_DIR

la 	t0, PLAYER_POS
lw	a1,0(t0)
sub	a1, a1, s3
addi 	a1, a1, -48

la 	t0, PLAYER_POS
lw	a2,4(t0)
sub	a2, a2, s4
addi 	a2, a2, 13
j WHIP_DIRECTION_END

WHIP_DIR:
la 	t0, PLAYER_POS
lw	a1,0(t0)
sub	a1, a1, s3
addi 	a1, a1, 30

la 	t0, PLAYER_POS
lw	a2,4(t0)
sub	a2, a2, s4
addi 	a2, a2, 13
WHIP_DIRECTION_END:


li t0, 97
bge t0, t1, Whip0
li t0, 99
bge t0, t1, Whip1
li t0, 101
bge t0, t1, Whip2
li t0, 103
bge t0, t1, Whip3
li t0, 104
bge t0, t1, Whip3
li t0, 105
bge t0, t1, Whip4
li t0, 106
bge t0, t1, Whip3
li t0, 107
bge t0, t1, Whip5
li t0, 108
bge t0, t1, Whip3
li t0, 109
bge t0, t1, Whip6
li t0, 110
bge t0, t1, Whip3
li t0, 111
bge t0, t1, Whip7
li t0, 112
bge t0, t1, Whip3
li t0, 113
bge t0, t1, Whip8
li t0, 114
bge t0, t1, Whip3
li t0, 115
bge t0, t1, Whip9
li t0, 116
bge t0, t1, Whip3
li t0, 118
bge t0, t1, Whip10

	
	Whip0:
	li a6, 150
	li a7, 210
	lb t0, 0(t4)
	beq t0, zero, Whip0_J
	addi a6, a6, 0
	addi a7, a7, 0
		Whip0_J:
		li a1, 0
		li a2, 0
		ret	


	Whip1:
	li a6, 84
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip1_J
	addi a6, a6, 2481
	addi a7, a7, 0
		Whip1_J:
		ret
		
	Whip2:
	li a6, 202
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip2_J
	addi a6, a6, 2246
	addi a7, a7, 0
		Whip2_J:
		j WHIP_HITBOX	
		
	Whip3:
	li a6, 319
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip3_J
	addi a6, a6, 2012
	addi a7, a7, 0
		Whip3_J:
		j WHIP_HITBOX	
		
	Whip4:
	li a6, 436
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip4_J
	addi a6, a6, 1777
	addi a7, a7, 0
		Whip4_J:
		j WHIP_HITBOX
	
	Whip5:
	li a6, 553
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip5_J
	addi a6, a6, 1564
	addi a7, a7, 0
		Whip5_J:
		j WHIP_HITBOX
		
	Whip6:
	li a6, 670
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip6_J
	addi a6, a6, 1192
	addi a7, a7, 0
		Whip6_J:
		j WHIP_HITBOX	
		
	Whip7:
	li a6, 787
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip7_J
	addi a6, a6, 959
	addi a7, a7, 0
		Whip7_J:
		ret	
		
	Whip8:
	li a6, 904
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip8_J
	addi a6, a6, 724
	addi a7, a7, 0
		Whip8_J:
		ret	
		
	Whip9:
	li a6, 1021
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip9_J
	addi a6, a6, 490
	addi a7, a7, 0
		Whip9_J:
		ret
		
	Whip10:
	li a6, 1138
	li a7, 366
	lb t0, 0(t4)
	beq t0, zero, Whip10_J
	addi a6, a6, 1075
	addi a7, a7, 0
		Whip10_J:
		la t0, Whip_HITBOX
		sh zero, 0(t0)
		sh zero, 2(t0)
		ret
		
	
				
			WHIP_HITBOX:	lb t0, 0(t4)
					beq t0, zero, WHIP_HITBOX_DIR
			
					la t0, Whip_HITBOX
					addi t1, a1,-42
					sh t1, 0(t0)
					addi t1, a2, 5
					sh t1, 2(t0)
					ret																							
					
					WHIP_HITBOX_DIR:
					la t0, Whip_HITBOX
					addi t1, a1, 42
					sh t1, 0(t0)
					addi t1, a2, 5
					sh t1, 2(t0)
					ret	
