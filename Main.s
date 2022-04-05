.include "val.s"



.data 

PLAYER_POS:	.half 380, 900	# posicao atual do player
PLAYER_SIZE:	.half 25, 48	#tamanho do Ritcher





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
			lh t1, 0(t0)			#x
			add t1, t1, a0
			sh t1, 0(t0)
			
			lh t1, 2(t0)			#y
			add t1, t1, a1
			sh t1, 2(t0)
			



#calcular a camera do jogador como visao do mapa levando em conta 
#a posicao central do jogador
VERIFY_MAP_POS:		
			#Determinar x limite
			la t0, PLAYER_POS
			lh t1, 0(t0)			#x
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
			lh t1, 2(t0)			#y
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
			#Verifica se tem background
			la t0, BACKGROUND
			lb t1, 0(t0)
			beq t1, zero, OFF_BACKGROUND

		#Calcular a1, a2 de acordo com pos do mapa	
			#X
			la t0, P1_library_size
			lh t1, 0(t0)
			li t2, 320
			
			fcvt.s.w ft1, t1		
			fcvt.s.w ft2, t2
			fdiv.s ft3, ft2, ft1, dyn		#valor x: de proporcao = (tamanho x da tela / tamanho do setor x)
			la t0,POS_P1_library
			lh t1, 0(t0)
			sub t4, s3, t1				#t4 = posicao atual no setor
			fcvt.s.w ft4, t4
			fmul.s  ft1, ft3, ft4	 #ft1 = posicao x setor  * proporcao de x = posicao na tela
			fcvt.w.s a1, ft1
			
			#calcular se o background n esta ultrapassando os limites da tela
			la t0, Backgorund_library_size
			lh t1, 0(t0)
			add t2, t1, a1 			#poiscao na tela mais tamanho do background x
			li t3, 319
			bge t3, t2, JUMP_BACKGROUND	#se t3(320) < t2(linha abaixo)
			add t3, t3, t1			#t3 = 320 - background x
			mv a1, t3
			JUMP_BACKGROUND:
			
			
			#Y
			la t0, P1_library_size
			lh t1, 2(t0)
			li t2, 240
			
			fcvt.s.w ft1, t1		
			fcvt.s.w ft2, t2
			fdiv.s ft3, ft2, ft1, dyn		#valor x: de proporcao = (tamanho x da tela / tamanho do setor x)
			la t0,POS_P1_library
			lh t1, 2(t0)
			sub t4, s4, t1				#t4 = posicao atual no setor
			fcvt.s.w ft4, t4
			fmul.s  ft1, ft3, ft4	 #ft1 = posicao x setor  * proporcao de x = posicao na tela
			fcvt.w.s a1, ft1
			
			#calcular se o background n esta ultrapassando os limites da tela
			la t0, Backgorund_library_size
			lh t1, 2(t0)
			add t2, t1, a1 			#poiscao na tela mais tamanho do background x
			li t3, 239
			bge t3, t2, JUMP_BACKGROUND2	#se t3(320) < t2(linha abaixo)
			add t3, t3, t1			#t3 = 320 - background x
			mv a1, t3
			JUMP_BACKGROUND2:
			
		
			
		
			
		
		
		
		
		
		
		
		
		#Calcular a6, a7 de acordo com pos do mapa
			#X
			la t0, P1_library_size
			lh t1, 0(t0)
			la t0, Backgorund_library_size
			lh t2, 0(t0)  
			div t3, t1, t2   #valor x: de proporcao = (tamanho x do mapa / tamanho background x) + 1
			addi t3, t3, 1	 #corretor de proporcao	
			
			la t0,POS_P1_library
			lh t1, 0(t0)
			sub t4, s3, t1	#posicao inicial do setor menos posicao atual no setor
			
			div a6, t4, t3	 #a6 = posicao x mapa / proporcao de x 
			la t0, POS_Backgorund_library
			lh t1, 0(t0)
			add a6, a6, t1	# soma da posicao inicial com a movimentacao dinamica
			
			#calcular se a camera na posicao dinamica n esta ultrapassando os limites do mapa
			la t0, FILE_MAP_SIZE
			lh t1, 0(t0)
			sub t2, t1, a6		#t2 = diferenca entre pos dinamica do background com o tamanho total		
			li t0, 320			
			bge t2, t0, J_BACKGROUND#se t2 < 320(linha abaixo)
			addi t1, t1, -320
			mv a6, t1
			J_BACKGROUND:
			la t0, Backgorund_library_size
			lh t1, 0(t0)
			
			
			
			
			
			
			
			
			
			
			
			#Y
			la t0, P1_library_size
			lh t1, 2(t0)
			la t0, Backgorund_library_size
			lh t2, 2(t0)  
			div t3, t1, t2	#valor y: de proporcao = valor y: de proporcao = (tamanho x do mapa / tamanho background x) + 1
			addi t3, t3, 1
			
			la t0,POS_P1_library
			lh t1, 2(t0)
			sub t4, s4, t1	#posicao inicial do setor menos posicao atual no setor
			
			
			div a7, t4, t3	#a7 = posicao x mapa / proporcao de y
			la t0, POS_Backgorund_library
			lh t1, 2(t0)
			add a7, a7, t1	# soma da posicao inicial com a movimentacao dinamica

			#calcular se a camera na posicao dinamica n esta ultrapassando os limites do mapa
			la t0, FILE_MAP_SIZE
			lh t1, 2(t0)
			sub t2, t1, a7		#t2 = diferenca entre pos dinamica do background com o tamanho total		
			li t0, 240			
			bge t2, t0, J_BACKGROUND2#se t2 < 240(linha abaixo)
			addi t1, t1, -240
			mv a7, t1
			J_BACKGROUND2:
			
			
			
			#print background:
			mv	a0, s0
			li	a1, 0
			li a2, 0
			#lh 	t2, 2(t0)
			la	a3, FILE_MAP_SIZE
			la	a4, Backgorund_library_size	#talvez seja maior do q devia
			mv	a5, s1
			#li a6, 500
			#li a7, 1200
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
			lh 	a1,0(t0)
			sub	a1, a1, s3
				
			# x = player x - map x
			la 	t0, PLAYER_POS
			lh 	a2,2(t0)
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

.data
#imagens
#.include "./Imagens/Ritcher_Stand0.data"
