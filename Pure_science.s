
.text
###################### PROCEDIMENTO SCIENCE #####################
#	ARGUMENTOS:						#
#		a0 = posicao setor				#
#								#
#################################################################
#Verifica colisao


SCIENCE:


SCIENCE_COLLISION:	la		t6, HITBOX		# t0 = block address

			
			fcvt.s.w	ft0, zero
			fadd.s		ft2, ft0, fs0
			fcvt.s.w	ft0, zero
			fadd.s		ft3, ft0, fs1
			
			# Colisao horizontal
			
			li		t1, 1			#cada ponto do hitbox contempla 8x8 pixels
			fcvt.s.w	ft1, t1			# ft1 = 8
			
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
SCIENCE_COLLISION_X_R:	li		t1, PLAYER_HEIGHT
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft3, ft4		# ft0 = y + y offset
			
			lh 		t1, 2(a0)		#offset do mapa	setor
			fcvt.s.w	ft4 , t1
			fadd.s 		ft0, ft0, ft4
			
			
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			la		t0, HITBOX_MAP_SIZE
			lh 		t1, 0(t0)		#x
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map x
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t4 += t1 + pos hitbox
			
			li		t1, PLAYER_WIDTH	
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft0, ft2, ft4		# ft4 = palyer x + offset
			
			lh 		t1, 0(a0)		#y do pos setor, que vai servir de offset para posicao do setor atual
			fcvt.s.w	ft4, t1			# ft4 = hitbox map x
			fadd.s		ft0, ft0, ft4		# ft0 = x + oofset setor
			
			
			#fdiv.s		ft5, ft4, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			
			add		t2, t4, t1		# t2 = pos y + posx (with offset)
			
			lbu		t1, 0(t2)
			beqz		t1, COLLISION_X_EFFECT
				
			la		t0, HITBOX_MAP_SIZE
			lh 		t3, 0(t0)		#x	
			add 		t2, t2, t3		#soma ao x do mapa	
			lbu		t1, 0(t2)
			beqz		t1, COLLISION_X_EFFECT
			
			
			li a0, 0
			li a1, 0
			ret
			#j		PHYSICS.COLL.Y

SCIENCE_COLLISION_X_L:	li		t1, OFFSET_Y_HITBOX
			fcvt.s.w	ft4, t1			# ft4 = y offset
			
			fadd.s		ft0, ft3, ft4		# ft0 = y + y offset
			fdiv.s		ft0, ft0, ft1		# ft0 = y / 8
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			fcvt.s.wu	ft0, t1
			
			
			la		t0, HITBOX_MAP_SIZE
			lh 		t1, 0(t0)		#x
			fcvt.s.w	ft4, t1			# ft4 = hitbox map width
			
			fmul.s		ft0, ft0, ft4		# ft0 = ft0 * map width
			fcvt.wu.s	t1, ft0			# t1 = floor(ft0)
			add		t4, t6, t1		# t0 += t1
			
			li		t1, OFFSET_Y_HITBOX
			fcvt.s.w	ft4, t1			# ft4 = x offset
			
			fadd.s		ft4, ft2, ft4		# ft4 = char x + offset
			fdiv.s		ft5, ft4, ft1		# ft5 = x / 8
			fcvt.wu.s	t1, ft5			# t1 = floor(ft2)
			
			add		t2, t4, t1		# t2 = t0 + t1
			
			lbu		t1, 0(t2)
			bnez		t1, COLLISION_X_EFFECT

			#lbu		t1, size_x(t2)
			#bnez		t1, COLLISION_X_EFFECT
			
			li a0, 0
			li a1, 0
			ret


COLLISION_X_EFFECT:	
			li a0, 0
			li a1, 0
			li		t2, 0			# wall = 0
			beq		t1, t2, HIT_WALL
			
			ret	


HIT_WALL:
		
		addi a0, a0 -1
		addi t2, t2, -1
		beq t2, zero, HIT_WALL	#Volta 1 pixel até estar fora da colisao
		ret
