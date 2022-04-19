.data
ON_AIR:		.byte 1 #(0 = no chao, 1 = no ar)
JUMP:		.byte 0 #(0 = jump not pressed, 1 = jump pressed)
JUMP_BOOST_LIMIT: .byte 0 #(so pode ser usado 12 vezes)
v:		.string "debugar "

.text

.eqv MAX_GRAV 		10
.eqv BOOST_LIMIT 	12
.eqv JUMP_H		-4
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
			beqz		t1, COLLISION_Y_EFFECT
			
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
			beqz		t1, COLLISION_Y_EFFECT
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
			beqz		t1, COLLISION_X_EFFECT
			
					
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
			beqz		t1, COLLISION_X_EFFECT
			
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
			beqz		t1, COLLISION_X_EFFECT
			
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
			beqz		t1, COLLISION_X_EFFECT
			
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
			beqz		t1, COLLISION_X_EFFECT
			
			ret
			#j		PHYSICS.COLL.Y

			



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
			beqz		t1, COLLISION_X_EFFECT
			
					
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
			beqz		t1, COLLISION_X_EFFECT
			
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
			beqz		t1, COLLISION_X_EFFECT
			
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
			beqz		t1, COLLISION_X_EFFECT
			
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
			beqz		t1, COLLISION_X_EFFECT
			

			ret




COLLISION_Y_EFFECT:	li		t3, 0			# wall = 0
			beq		t1, t3, HIT_FLOOR		
			ret	

	HIT_FLOOR:	
			la t0, JUMP
			sb zero,0(t0)
			
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
			lh t1,0(a2)	
			add 		t2, t2, t1
			lbu		t1, 0(t2)
			beqz		t1,  HIT_FLOOR_DOWN
			ret	
			
			
										
			HIT_FLOOR_DOWN:	
			la 		t0, ON_AIR
			sb 		zero, 0(t0)	#Houve colisao de chao, logo, n esta mais flutuando
			
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
			beqz		t1,  HIT_FLOOR_DOWN
			ret					
																								

COLLISION_X_EFFECT:	
			li 		a0, 0
			li	 	a1, 0
			li		t3, 0			# wall = 0
			beq		t1, t3, HIT_WALL
			
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
