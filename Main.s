.include "val.s"



.data 

PLAYER_POS:	.word 380, 900	# posicao atual do player
PLAYER_SIZE:	.half 25, 48	#tamanho do Ritcher
v: .string "colisao wall"




#CHAR_POS:	.float 704, 648

#RESPAWN_POS:	.half 704, 648	# respawn pos (x, y)




.text

# Registradores que devem permanecer inalterados
#
# s0 = Map
# s1 = frame
# s3 = mapa x
# s4 = mapa y
#s11 = frame control

MAIN:
# Open MAPA file	

			
			la		t0, PLAYER_POS
			flw		fs0, 0(t0)		# fs0 = char x
			flw		fs1, 4(t0)		# fs1 = char y
			li t0, 2
			fcvt.s.w	fs2, t0		# fs2 = x velocity
			fcvt.s.w	fs3, zero		# fs3 = y velocity
			#fcvt.s.w	fs4, zero		# fs4 = jump grace timer
			#fcvt.s.w	fs5, zero		# fs5 = varJumpTimer
			#fcvt.s.w	fs6, zero		# fs6 = varJumpSpeed
			#fcvt.s.w	fs7, zero		# fs7 = maxfall
			#fcvt.s.w	fs8, zero		# fs8 = dash timer
			
			
			
			
			li	a7, 1024
			la	a0, Map_library
			li	a1, 0
			ecall
			mv	s0, a0
			csrr		s11, 3073	#tempo do primeiro frame
			li		s1, 0		#FRAME inicial
			
			call SWITCH_FRAME
			
			
			
MAIN_LOOP:		# O framerate de 60 fps
			#Se for 60 FPS, por exemplo, 1 segundo / 60 = 0.01666, ou 16 ms#
			csrr		t0, 3073		# t0 = tempo atual
			sub		t0, s11, t0		# t0 = tempo atual - ultimo frame
			li		t1, 16			# 16ms 
			bltu		t0, t1, MAIN_LOOP	


			call 	KEY	#verifica teclado
			#Soma as posicoes novas da KEY
			la t0, PLAYER_POS
			lw t1, 0(t0)			#x
			add t1, t1, a0
			sh t1, 0(t0)
			
			lw t1, 4(t0)			#y
			add t1, t1, a1
			sh t1, 4(t0)
			li a0, 0
			li a1, 0
			#j VERIFY_MAP_POS
			
			
			la		t0, PLAYER_POS
			lw		t1, 0(t0)		# fs0 = char x
			lw		t2, 4(t0)		# fs1 = char y
			
			fcvt.s.w fs0, t1
			fcvt.s.w fs1, t2
			
			la a0, POS_P1_library
			call SCIENCE_COLLISION
			#Soma as posicoes novas da KEY
			la t0, PLAYER_POS
			lw t1, 0(t0)			#x
			add t1, t1, a0
			#sh t1, 0(t0)
			
			lw t1, 4(t0)			#y
			add t1, t1, a1
			#sh t1, 4(t0)

#calcular a camera do jogador como visao do mapa levando em conta 
#a posicao central do jogador
VERIFY_MAP_POS:		
			#Determinar x limite
			la t0, PLAYER_POS
			lw t1, 0(t0)			#x
			addi	t1, t1, OFFSET_X	# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
			bge t1, zero,VERIFY_MAP_POS_JUMP #t1 > 0
			mv t1, zero			#senao t1 = 0
		VERIFY_MAP_POS_JUMP:
			la t0, P1_library_size
			lh t2, 0(t0)
			addi t2, t2, -320		#largura maxima de x = largura do mapa - largura da tela + pos inicial
			la t0, POS_P1_library
			lh t3, 0(t0)			#pos inicial
			add t2, t2, t3
			bge t2,t1, VERIFY_MAP_POS_JUMP2		#pega o menor entre os valores
			mv t1, t2
		VERIFY_MAP_POS_JUMP2:
			#Determinar x inicial
			la t0, POS_P1_library
			lh t2, 0(t0)			
			bge t1, t2, VERIFY_MAP_POS_JUMP3	#se t1(camera) for menor que t2(pos inicial): mv t1, t2
			mv t1, t2	
		VERIFY_MAP_POS_JUMP3:
			mv	s3, t1			# move o resultado pra s3
				
		
			#Determinar y limite
			la t0, PLAYER_POS
			lw t1, 4(t0)			#y
			addi t1, t1, OFFSET_X		# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
			bge t1, zero, VERIFY_MAP_POS_JUMP4 #t1 > 0
			mv t1, zero			#senao t1 = 0
		VERIFY_MAP_POS_JUMP4:
			la t0, P1_library_size
			lh t2, 2(t0)
			addi t2, t2, -240		#largura maxima de y = largura do mapa - largura da tela + pos inicial
			la t0, POS_P1_library
			lh t3, 2(t0)			#pos inicial
			add t2, t2, t3
			bge t2,t1, VERIFY_MAP_POS_JUMP5	#pega o menor entre os valores
			mv t1, t2
		VERIFY_MAP_POS_JUMP5:
			#Determinar y inicial
			la t0, POS_P1_library
			lh t2, 2(t0)			
			bge t1, t2, VERIFY_MAP_POS_JUMP6	#se t1(camera) for menor que t2(pos inicial): mv t1, t2
			mv t1, t2	
		VERIFY_MAP_POS_JUMP6:
			mv	s4, t1			# move o resultado pra s4

						
											
																																				
																		
MAP_BACKGROUND:	
			#call SELECT_BACKGROUND
			la a0, P1_library_size				
			la a1, POS_P1_library				
			la a2, Backgorund_library_size					
			la a3, POS_Backgorund_library				
			la a4, FILE_MAP_SIZE
			call PREPARE_BACKGROUND

			#print background:
			mv	a0, s0
			li	a1, 0
			li 	a2, 0
			#a3 construido anteriormente
			#a4 construido anteriormente
			mv	a5, s1
			#a6 construido anteriormente
			#a7 construido anteriormente
			call	PRINT	
			
OFF_BACKGROUND:																								

			
MAP_PRINT:		
			# Define os argumentos a0-a5 e desenha o mapa
			# os calculos pros argumentos a6-a7 s?o definidos acima
			mv	a0, s0
			li	a1, 0
			li	a2, 0
			la	a3, FILE_MAP_SIZE
			la	a4, SCREEN_SIZE
			mv	a5, s1
			mv	a6, s3
			mv	a7, s4
			call	PRINT			

PLAYER_PRINT:		
			li	a7, 1024
			la	a0, Ritcher
			li	a1, 0
			ecall
			# Calculo da posicao do personagem na tela em relacao ao mapa
			# x = player x - map x
			la 	t0, PLAYER_POS
			lw	a1,0(t0)
			sub	a1, a1, s3
				
			# x = player x - map x
			la 	t0, PLAYER_POS
			lw	a2,4(t0)
			sub	a2, a2, s4
			la	a3, Ritcher_size
			la	a4, PLAYER_SIZE
			mv	a5, s1
			li 	a6, 6
			li	a7, 10
			call	PRINT	
						
												
						
#FIM_MAIN_LOOP		
call SWITCH_FRAME		#mostra a nova tela	
beq s1, zero,FRAME_1
li s1, 0
j FRAME_0
FRAME_1:								
li s1, 1
FRAME_0:																											
																																																																																	
csrr		s11, 3073	#tempo do primeiro frame
j MAIN_LOOP










li a7,10
ecall

#Procedimentos
.include "Proc.s"	
.include "Keyboard.s"
.include "Pure_science.s"
.data
#imagens
.include "./Imagens/matriz8x8testejogo.data"
