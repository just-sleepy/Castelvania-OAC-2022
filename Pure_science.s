.data
ON_AIR:		.byte 1 #(0 = no chao, 1 = no ar)
JUMP:		.byte 0 #(0 = jump not pressed, 1 = jump pressed)
JUMP_BOOST_LIMIT: .byte 0 #(so pode ser usado 12 vezes)

v:		.string "debugar "

.text

###################### PROCEDIMENTO SCIENCE #####################
#	ARGUMENTOS:						#
#		a0 = posicao setor				#
#		a1 = setor adress				#
#		a2 = setor adress size				#
#################################################################
#Verifica colisao


SCIENCE:

GRAVITY:		la t0, ON_AIR
			lb t2, 0(t0)
			beq t2, zero, ON_GROUND	#se for igual a zero significa que esta no chao
			fcvt.w.s t1, fs3
			li t3, MAX_GRAV
			beq t1, t3, GRAV_J	#se ultrapassar a gravidade maxima 
			li t1, 1
			fcvt.s.w  ft1, t1
			li t2, 2
			fcvt.s.w ft2, t2
			fdiv.s ft1, ft1, ft2	#ft1 = 1/2 = 0.5
			fadd.s fs3, fs3, ft1	#velocidade vertical += 0.25 (AUMENTA A GRAVIDADE APESAR DE POSITIVO)
			GRAV_J:
			li a0, 1
			li a1, 1
			la t0, JUMP
			lb t1, 0(t0)
			li t2, 1
			beq t1, t2 JUMP_BOOST #Se t1 = 1, boost no pulo
			ret
			
			ON_GROUND:
			la t0, JUMP
			lb t1, 0(t0)
			beqz t1, NOT_JUMP #Se t1 estiver zerado, não pula
			li t0, 0	#Reseta velocidade
			j JUMPING
			
			NOT_JUMP:
			li t2, 1
			fcvt.s.w  fs3,t2	#Gravidade resetada
			ret
			
JUMP_BOOST:		la t0, JUMP_BOOST_LIMIT
			lb t1, 0(t0)
			blt t1, zero, JUMP_RET	#t1 = -1, napo pode mais usar o boost
			addi t1, t1, 1
			li t2, BOOST_LIMIT
			bge t2, t1, LIMIT_NOT_EXC
			ret
			LIMIT_NOT_EXC:
			sb t1,0(t0)	
			li t0, 0	#Reseta velocidade
			
						
			
JUMPING:		li a1, 1
			li t0, JUMP_H	#Reseta velocidade
			fcvt.s.w  fs3, t0
			la t0, ON_AIR
			li t1, 1
			sb t1, 0(t0)
			JUMP_RET:
			ret
																										

SCIENCE_COLLISION:	mv 		t6, a1

			fcvt.s.w	ft0, zero
			fadd.s		ft6, ft0, fs0
			fcvt.s.w	ft0, zero
			fadd.s		ft7, ft0, fs1

SCIENCE_COLLISION_Y:	# Colisao vertical
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs3		# Speed.X > 0
			bnez		t1, SCIENCE_COLLISION_Y_DOWN
			flt.s		t1, fs3, ft0		# Speed.X < 0
			bnez		t1, SCIENCE_COLLISION_Y_UP
			la t0, ON_AIR
			li t2, 1
			sb t2, 0(t0)
			
				
	
			
SCIENCE_COLLISION_X:	# Colisao horizontal								
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs2		# Speed.X > 0
			bnez		t1, SCIENCE_COLLISION_X_R
			flt.s		t1, fs2, ft0		# Speed.X < 0
			bnez		t1, SCIENCE_COLLISION_X_L
			
			
			# Colisao vertical
			#j		PHYSICS.COLL.Y
			

			ret

			
SCIENCE_COLLISION_Y_DOWN:						
			fadd.s		ft0, ft0, ft7		# ft0 = y 
			li		t1, -1			#Algum problema na calibragem faz com que haja sempre esse erro de um pixel, essa foi a solucao pratica	
			fcvt.s.w	ft5, t1			# ft4 = x offset
			fadd.s		ft0, ft0, ft5		# ft0 = y + y offset
			
			lh 		t1, 2(a0)		#offset do mapa	setor
			fcvt.s.w	ft4 , t1
			fsub.s 		ft0, ft0, ft4		#subtrai posicao do setor para determinar posicao do player dentro do setor
			
			li		t1, PLAYER_HEIGHT	#Soma altura para pegar parte debaixo do personagem
			fcvt.s.w	ft5, t1			# ft4 = x offset
			fadd.s		ft0, ft0, ft5		# ft0 = y + y offset
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			lh 		t1, 0(a2)		#size do setor x
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map x
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t4 += t1 + pos hitbox
			
			li		t1, 0	
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft6, ft4		# ft4 = player x + offset
			
			lh 		t1, 0(a0)		# pos setor, que vai servir de offset para posicao do setor atual
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			fsub.s		ft0, ft0, ft4		# ft0 = x - oofset setor
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1			# t1 = floor(ft0)
			
			add		t2, t4, t1		# t2 = pos y + posx (with offset)
			
			
			#Se confere 4 pontos do personagem 
			#
			#RITCHER:	X = 12:12(x:y)
			#
			#	YY
			#
			#	XX 			
			#	XX 		Se verfica os pontos Y a frente do personagem representado por X's
			#	XX 
			#	XX 		
			
				
			li		t1, PLAYER_WIDTH
			li 		t3, 2
			div 		t1, t1, t3
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------1/1 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_Y_EFFECT
			
				#Sem colisao significa que esta flutuando e a gravidade começa a fazer efeito
				la t0, ON_AIR
				lb t2, 0(t0)
				bne t2, zero, ON_AIR_J	#Se igual a zero passa a ser um
				li t2, 1
				sb t2, 0(t0)
				li t2, -1
				fcvt.s.w  fs3, t2			
				ON_AIR_J:
				
			
			j SCIENCE_COLLISION_X
			
					
																			
SCIENCE_COLLISION_Y_UP:						
			fadd.s		ft0, ft0, ft7		# ft0 = y 
			li		t1, -1			#Algum problema na calibragem faz com que haja sempre esse erro de um pixel, essa foi a solucao pratica	
			fcvt.s.w	ft5, t1			# ft4 = x offset
			fadd.s		ft0, ft0, ft5		# ft0 = y + y offset
			
			lh 		t1, 2(a0)		#offset do mapa	setor
			fcvt.s.w	ft4 , t1
			fsub.s 		ft0, ft0, ft4		#subtrai posicao do setor para determinar posicao do player dentro do setor
			
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			lh 		t1, 0(a2)		#size do setor x
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map x
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t4 += t1 + pos hitbox
			
			li		t1, 0	
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft6, ft4		# ft4 = player x + offset
			
			lh 		t1, 0(a0)		# pos setor, que vai servir de offset para posicao do setor atual
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			fsub.s		ft0, ft0, ft4		# ft0 = x - oofset setor
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1			# t1 = floor(ft0)
			
			add		t2, t4, t1		# t2 = pos y + posx (with offset)

			
			#Se confere 4 pontos do personagem 
			#
			#RITCHER:	X = 12:12(x:y)
			#
			#	YY
			#
			#	XX 			
			#	XX 		Se verfica os pontos Y a frente do personagem representado por X's
			#	XX 
			#'	XX 		
			
			
			li		t1, PLAYER_WIDTH
			li 		t3, 2
			div 		t1, t1, t3
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------1/1 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_Y_EFFECT
			j SCIENCE_COLLISION_X
														
																		
																								
			
SCIENCE_COLLISION_X_R:	
			fadd.s		ft0, ft0, ft7		# ft0 = y 
			li		t1, -1			#Algum problema na calibragem faz com que haja sempre esse erro de um pixel, essa foi a solucao pratica	
			fcvt.s.w	ft5, t1			# ft4 = x offset
			fadd.s		ft0, ft0, ft5		# ft0 = y + y offset
			
			lh 		t1, 2(a0)		#offset do mapa	setor
			fcvt.s.w	ft4 , t1
			fsub.s 		ft0, ft0, ft4		#subtrai posicao do setor para determinar posicao do player dentro do setor
			
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			lh 		t1, 0(a2)		#size do setor x
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map x
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t4 += t1 + pos hitbox
			
			li		t1, PLAYER_WIDTH	
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft6, ft4		# ft4 = player x + offset
			
			lh 		t1, 0(a0)		# pos setor, que vai servir de offset para posicao do setor atual
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			fsub.s		ft0, ft0, ft4		# ft0 = x - oofset setor
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1			# t1 = floor(ft0)
			
			add		t2, t4, t1		# t2 = pos y + posx (with offset)
			
			
			#Se confere 4 pontos do personagem 
			#
			#RITCHER:	X = 12:12(x:y)
			#
			#	XX Y			
			#	XX Y		Se verfica os pontos Y a frente do personagem representado por X's
			#	XX Y
			#'	XX Y		
			#------------------------0/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
					
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------1/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------2/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------3/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------4/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			ret
			
			
SCIENCE_COLLISION_X_L:	fadd.s		ft0, ft0, ft7		# ft0 = y 
			li		t1, -1			#Algum problema na calibragem faz com que haja sempre esse erro de um pixel, essa foi a solucao pratica	
			fcvt.s.w	ft5, t1			# ft4 = x offset
			fadd.s		ft0, ft0, ft5		# ft0 = y + y offset
			
			lh 		t1, 2(a0)		#offset do mapa	setor
			fcvt.s.w	ft4 , t1
			fsub.s 		ft0, ft0, ft4		#subtrai posicao do setor para determinar posicao do player dentro do setor
			
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			lh 		t1, 0(a2)		#size do setor x
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map x
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t4 += t1 + pos hitbox
			
			li		t1, 0
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft6, ft4		# ft4 = player x + offset
			
			lh 		t1, 0(a0)		# pos setor, que vai servir de offset para posicao do setor atual
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			fsub.s		ft0, ft0, ft4		# ft0 = x - oofset setor
			
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1			# t1 = floor(ft0)
			
			add		t2, t4, t1		# t2 = pos y + posx (with offset)
			
			
			#Se confere 4 pontos do personagem 
			#
			#RITCHER:	X = 12:12(x:y)
			#
			#	XX Y			
			#	XX Y		Se verfica os pontos Y a frente do personagem representado por X's
			#	XX Y
			#'	XX Y		
			#------------------------0/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
					
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------1/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------2/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------3/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			
			li		t1, PLAYER_HEIGHT	
			li 		t0, 4
			div		t1, t1, t0
			fcvt.s.w	ft4, t1			# ft4 = y offset
			lh 		t1, 0(a2)		# size do setor x
			fcvt.s.w	ft3, t1			# ft3 = hitbox map x
			fmul.s		ft2, ft3, ft4		# ft2 = ft3 * map x
			fcvt.wu.s	t1, ft2			# t1 = floor(ft0)
			add		t2, t2, t1		# t4 += t1 + pos hitbox
			#------------------------4/4 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			li 		t0, 255
			bne 		t1, t0,COLLISION_X_EFFECT
			

			ret




COLLISION_Y_EFFECT:	li		t3, 0			# wall = 0
			beq		t1, t3, HIT_FLOOR
			li		t3, 148
			beq		t1, t3, TRANSITION_P1A_P3A
			li		t3, 105
			beq		t1, t3, TRANSITION_P1B_P3B
			li		t3, 175
			beq		t1, t3, TRANSITION_P2_P3C
			li		t3, 31
			beq		t1, t3, TRANSITION_P3A_P5B
			li		t3, 163
			beq		t1, t3, TRANSITION_P3B_P5C
			li		t3, 55
			beq		t1, t3, TRANSITION_P3C_P6
			li		t3,183
			beq		t1, t3, TRANSITION_P4_P5A
			li		t3, 63
			beq		t1, t3, TRANSITION_P6_P7
			li		t3, 93
			beq		t1, t3, TRANSITION_P7_P8
			li		t3, 146
			beq		t1, t3, TRANSITION_P5D_P7	
			ret	

	HIT_FLOOR:	
			
			la t0, Ritcher_damaged
			sb zero, 0(t0) #desativa stance de damaged
			
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs3		# Speed.X > 0
			bnez		t1, HIT_FLOOR_DOWN
			flt.s		t1, fs3, ft0		# Speed.X < 0
			bnez		t1, HIT_FLOOR_UP
			
			HIT_FLOOR_UP:
			
			
			#muda posicao player		
			la t0, PLAYER_POS		
			lw t1, 4(t0)			#y
			addi t1, t1, 4
			sh t1, 4(t0)		
			fcvt.s.w fs3, zero 
			#Confere nova posicao
			lh 		t1,0(a2)	
			add 		t2, t2, t1
			lbu		t1, 0(t2)
			beqz		t1,  HIT_FLOOR_DOWN2
			ret	
			
			
										
			HIT_FLOOR_DOWN:	
			la 		t0, ON_AIR
			sb 		zero, 0(t0)	#Houve colisao de chao, logo, n esta mais flutuando
			la 		t0, JUMP
			sb 		zero,0(t0)
			HIT_FLOOR_DOWN2:
			la t0, JUMP_BOOST_LIMIT
			sb zero,0(t0)			#Reseta o boost do pulo				
															
			#muda posicao player		
			la t0, PLAYER_POS		
			lw t1, 4(t0)			#y
			addi t1, t1, -1
			sh t1, 4(t0)		
			
			#Confere nova posicao
			lh t1,0(a2)
			sub 		t2, t2, t1
			lbu		t1, 0(t2)
			beqz		t1,  HIT_FLOOR_DOWN2
			ret					
																								

COLLISION_X_EFFECT:	
			li 		a0, 0
			li	 	a1, 0
			li		t3, 0			# wall = 0
			beq		t1, t3, HIT_WALL
			li		t3, 148
			beq		t1, t3, TRANSITION_P1A_P3A
			li		t3, 105
			beq		t1, t3, TRANSITION_P1B_P3B
			li		t3, 175
			beq		t1, t3, TRANSITION_P2_P3C
			li		t3, 31
			beq		t1, t3, TRANSITION_P3A_P5B
			li		t3, 163
			beq		t1, t3, TRANSITION_P3B_P5C
			li		t3, 55
			beq		t1, t3, TRANSITION_P3C_P6
			li		t3,183
			beq		t1, t3, TRANSITION_P4_P5A
			li		t3, 63
			beq		t1, t3, TRANSITION_P6_P7
			li		t3, 93
			beq		t1, t3, TRANSITION_P7_P8
			li		t3, 146
			beq		t1, t3, TRANSITION_P5D_P7
			ret	
			

	HIT_WALL:	fcvt.s.w 	ft0, zero
			flt.s		t1, ft0, fs2		# Speed.X > 0
			bnez		t1, HIT_WALL_R
			flt.s		t1, fs2, ft0		# Speed.X < 0
			bnez		t1, HIT_WALL_L
		
			HIT_WALL_R:
			#muda posicao player
			la t0, PLAYER_POS
			lw t1, 0(t0)			#x
			addi t1, t1, -1
			sh t1, 0(t0)
			
			#Confere nova posicap
			addi 		t2, t2, -1
			lbu		t1, 0(t2)
			beqz		t1,  HIT_WALL_R	
			ret
		
			HIT_WALL_L:
			#muda posicao player
			la t0, PLAYER_POS
			lw t1, 0(t0)			#x
			addi t1, t1, 1
			sh t1, 0(t0)
			
			#Confere nova posicap
			addi 		t2, t2, 1
			lbu		t1, 0(t2)
			beqz		t1,  HIT_WALL_L	
			ret 	

	
	TRANSITION_P1A_P3A:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 1	#Setor P1
	beq t1, t0, P1A_TO_P3A
	li t0, 3	#Setor P3
	beq t1, t0, P3A_TO_P1A
	
		P1A_TO_P3A:
		la t0, NEW_SECTOR
		li t1, 3
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2700 x 1283
		li t1, 2700
		sw t1, 0(t0)	#x
		li t1, 1283
		sw t1, 4(t0)	#y
		ret
		
		P3A_TO_P1A:
		la t0, NEW_SECTOR
		li t1, 1
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=1355 x 136
		li t1, 1355
		sw t1, 0(t0)	#x
		li t1, 136
		sw t1, 4(t0)	#y
		ret
	
	
	TRANSITION_P1B_P3B:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 1	#Setor P1
	beq t1, t0, P1B_TO_P3B
	li t0, 3	#Setor P3
	beq t1, t0, P3B_TO_P1B
	
		P1B_TO_P3B:
		la t0, NEW_SECTOR
		li t1, 3
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2700 x 1539
		li t1, 2700
		sw t1, 0(t0)	#x
		li t1, 1539
		sw t1, 4(t0)	#y
		ret
		
		P3B_TO_P1B:
		la t0, NEW_SECTOR
		li t1, 1
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=1355 x 392
		li t1, 1340
		sw t1, 0(t0)	#x
		li t1, 392
		sw t1, 4(t0)	#y
		ret	
		
		
	TRANSITION_P2_P3C:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 2	#Setor P2
	beq t1, t0, P2_TO_P3C
	li t0, 3	#Setor P3
	beq t1, t0, P3C_TO_P2
	
		P2_TO_P3C:
		la t0, NEW_SECTOR
		li t1, 3
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2700 x 1795
		li t1, 2700
		sw t1, 0(t0)	#x
		li t1, 1795
		sw t1, 4(t0)	#y
		ret
		
		P3C_TO_P2:
		la t0, NEW_SECTOR
		li t1, 2
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3496 x 1544
		li t1, 3460
		sw t1, 0(t0)	#x
		li t1, 1544
		sw t1, 4(t0)	#y
		ret		
		
		
	TRANSITION_P3A_P5B:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 3	#Setor P3
	beq t1, t0, P3A_TO_P5B
	li t0, 5	#Setor P5
	beq t1, t0, P5B_TO_P3A
	
		P3A_TO_P5B:
		la t0, NEW_SECTOR
		li t1, 5
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2458 x 392
		li t1, 2458
		sw t1, 0(t0)	#x
		li t1, 392
		sw t1, 4(t0)	#y
		ret
		
		P5B_TO_P3A:
		la t0, NEW_SECTOR
		li t1, 3
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2910 x 1283
		li t1, 2910
		sw t1, 0(t0)	#x
		li t1, 1283
		sw t1, 4(t0)	#y
		ret
		
				
		
	TRANSITION_P3B_P5C:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 3	#Setor P3
	beq t1, t0, P3B_TO_P5C
	li t0, 5	#Setor P5
	beq t1, t0, P5C_TO_P3B
	
		P3B_TO_P5C:
		la t0, NEW_SECTOR
		li t1, 5
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2458 x 648
		li t1, 2458
		sw t1, 0(t0)	#x
		li t1, 648
		sw t1, 4(t0)	#y
		ret
		
		P5C_TO_P3B:
		la t0, NEW_SECTOR
		li t1, 3
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2910 x 1539
		li t1, 2910
		sw t1, 0(t0)	#x
		li t1, 1539
		sw t1, 4(t0)	#y
		ret	
		
	TRANSITION_P3C_P6:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 3	#Setor P3
	beq t1, t0, P3C_TO_P6
	li t0, 6	#Setor P6
	beq t1, t0, P6_TO_P3C
	
		P3C_TO_P6:
		la t0, NEW_SECTOR
		li t1, 6
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3030 x 1817
		li t1, 3030
		sw t1, 0(t0)	#x
		li t1, 1817
		sw t1, 4(t0)	#y
		ret
		
		P6_TO_P3C:
		la t0, NEW_SECTOR
		li t1, 3
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2910 x 1795
		li t1, 2910
		sw t1, 0(t0)	#x
		li t1, 1795
		sw t1, 4(t0)	#y
		ret
		
	TRANSITION_P4_P5A:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 4	#Setor P4
	beq t1, t0, P4_TO_P5A
	li t0, 5	#Setor P5
	beq t1, t0, P5A_TO_P4
	
		P4_TO_P5A:
		la t0, NEW_SECTOR
		li t1, 5
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=2458 x 136
		li t1, 2458
		sw t1, 0(t0)	#x
		li t1, 136
		sw t1, 4(t0)	#y
		ret
		
		P5A_TO_P4:
		la t0, NEW_SECTOR
		li t1,4
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3272 x 1283
		li t1, 3272
		sw t1, 0(t0)	#x
		li t1, 1283
		sw t1, 4(t0)	#y
		ret
		
	TRANSITION_P6_P7:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 6	#Setor P4
	beq t1, t0, P6_TO_P7
	li t0, 7	#Setor P5
	beq t1, t0, P7_TO_P6
	
		P6_TO_P7:
		la t0, NEW_SECTOR
		li t1, 7
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3427 x 1283
		li t1, 3427
		sw t1, 0(t0)	#x
		li t1, 1283
		sw t1, 4(t0)	#y
		ret
		
		P7_TO_P6:
		la t0, NEW_SECTOR
		li t1,6
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3496 x 1817
		li t1, 3496
		sw t1, 0(t0)	#x
		li t1, 1817
		sw t1, 4(t0)	#y
		ret	
		
	
		
	TRANSITION_P7_P8:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 7	#Setor P7
	beq t1, t0, P7_TO_P8
	li t0, 8	#Setor P8
	beq t1, t0, P8_TO_P7
	
		P7_TO_P8:
		la t0, NEW_SECTOR
		li t1, 8
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3030 x 2087
		li t1, 3030
		sw t1, 0(t0)	#x
		li t1, 2087
		sw t1, 4(t0)	#y
		ret
		
		P8_TO_P7:
		la t0, NEW_SECTOR
		li t1, 7
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3637 x 1283
		li t1, 3637
		sw t1, 0(t0)	#x
		li t1, 1283
		sw t1, 4(t0)	#y
		ret
		
	TRANSITION_P5D_P7:
	la t0, SETOR
	lb t1, 0(t0)
	li t0, 5	#Setor P4
	beq t1, t0, P5D_TO_P7
	li t0, 7	#Setor P5
	beq t1, t0, P7_TO_P5D
	
		P5D_TO_P7:
		la t0, NEW_SECTOR
		li t1, 7
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3527 x1219
		li t1, 3527
		sw t1, 0(t0)	#x
		li t1, 1219
		sw t1, 4(t0)	#y
		ret
		
		P7_TO_P5D:
		la t0, NEW_SECTOR
		li t1, 5
		sb t1, 0(t0)
		la t0, NEW_PLAYER_POS	#POSICAO_INICIAL=3153 x 706
		li t1, 3153
		sw t1, 0(t0)	#x
		li t1, 706
		sw t1, 4(t0)	#y
		ret