.text
###################### PROCEDIMENTO SCIENCE #####################
#	ARGUMENTOS:						#
#		a0 = posicao setor				#
#		a1 = setor adress				#
#		a2 = setor adress size				#
#################################################################
#Verifica colisao


SCIENCE:


SCIENCE_COLLISION:	mv t6, a1

			
			fcvt.s.w	ft0, zero
			fadd.s		ft6, ft0, fs0
			fcvt.s.w	ft0, zero
			fadd.s		ft7, ft0, fs1
			
SCIENCE_COLLISION_Y:	# Colisao vertical
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs3		# Speed.X > 0
			bnez		t1, SCIENCE_COLLISION_Y_DOWN
			flt.s		t1, fs3, ft0		# Speed.X < 0
			#bnez		t1, SCIENCE_COLLISION_Y_UP
			
	

			
SCIENCE_COLLISION_X:	# Colisao horizontal								
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs2		# Speed.X > 0
			bnez		t1, SCIENCE_COLLISION_X_R
			flt.s		t1, fs2, ft0		# Speed.X < 0
			bnez		t1, SCIENCE_COLLISION_X_L
			
			
			# Colisao vertical
			#j		PHYSICS.COLL.Y
			
			li a0, 0
			li a1, 0
			ret

			
SCIENCE_COLLISION_Y_DOWN:						
			fadd.s		ft0, ft0, ft7		# ft0 = y 
			li		t1, -1			#Algum problema na calibragem faz com que haja sempre esse erro de um pixel, essa foi a solucao pratica	
			fcvt.s.w	ft5, t1			# ft4 = x offset
			
			li		t1, PLAYER_HEIGHT
			fcvt.s.w	ft4, t1			# ft4 = x offset	
			fadd.s		ft0, ft4, ft5		# ft0 = y + y offset
			
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
			
			fadd.s		ft0, ft0, ft6		# ft4 = player x + offset
			
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
			#------------------------0/1 do personagem----------------------------------------------------------------------
			lbu		t1, 0(t2)
			beqz		t1, COLLISION_Y_EFFECT
				
			li		t1, PLAYER_WIDTH	
			li 		t0, 2
			div		t1, t1, t0
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
			
			li a0, 0
			li a1, 0
			ret
			#j		PHYSICS.COLL.Y

			



SCIENCE_COLLISION_X_L:	fadd.s		ft0, ft0, ft3		# ft0 = y 
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
			
			#li		t1, PLAYER_WIDTH
			li t1, 0	
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft2, ft4		# ft4 = player x + offset
			
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
			
			li a0, 0
			li a1, 0
			ret
			#j		PHYSICS.COLL.Y



COLLISION_Y_EFFECT:	li		t3, 0			# wall = 0
			beq		t1, t3, HIT_FLOOR
			
			ret	

	HIT_FLOOR:	
	
			fcvt.s.w	ft0, zero
			flt.s		t1, ft0, fs3		# Speed.X > 0
			bnez		t1, HIT_FLOOR_DOWN
			flt.s		t1, fs3, ft0		# Speed.X < 0
			#bnez		t1, HIT_FLOOR_UP
			
			HIT_FLOOR_DOWN:	
			#muda posicao player		
			la t0, PLAYER_POS		
			lw t1, 4(t0)			#y
			addi t1, t1, -1
			sh t1, 4(t0)		
			
			#Confere nova posicap
			#lw		t1, 0(a2) #largura do setor
			#sub 		t2, t2, t1
			#lbu		t1, 0(t2)
			#beqz		t1,  HIT_FLOOR_DOWN
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
			addi t1, t1, -1
			sh t1, 0(t0)
			
			#Confere nova posicap
			addi 		a0, a0 ,1
			addi 		t2, t2, 1
			lbu		t1, 0(t2)
			beqz		t1,  HIT_WALL_L	
			ret 	
