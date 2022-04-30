.include "val.s"



.data 

PLAYER_POS:	.word 450, 900	# posicao atual do player/inicial
#PLAYER_POS:	.word 3100 , 713	# posicao atual do player/inicial
PLAYER_SIZE:	.half 30,48	#tamanho do Ritcher



#CHAR_POS:	.float 704, 648

#RESPAWN_POS:	.half 704, 648	# respawn pos (x, y)




.text

# Registradores que devem permanecer inalterados
#
# s0 = Map
# s1 = frame
# s3 = mapa x
# s4 = mapa y
#s9 = enemies queue inicial
#s10 = enemies generator time
#s11 = frame control


# Open MAPA file	
			#create stack
			#addi	sp,sp,-1480
			#save s10
			#sw	s10,1480(sp)
			#update s10
			#addi	s10,sp,1480	
			
			la		t0, PLAYER_POS
			flw		fs0, 0(t0)		# fs0 = char x
			flw		fs1, 4(t0)		# fs1 = char y

			fcvt.s.w	fs2, zero		# fs2 = x velocity
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
			
			
			
			li a1, 690
			li a2, 450
			call ADD_GHOST

			li a1, 650
			li a2, 900
			call ADD_GHOST
			
			li a1, 600
			li a2, 950
			call ADD_GHOST
			
			li a1, 600
			li a2, 450
			call ADD_GHOST
			
			li a1, 450
			li a2, 850
			call ADD_GHOST

			
			
MAIN_LOOP:		# O framerate de 60 fps
			#Se for 60 FPS, por exemplo, 1 segundo / 60 = 0.01666, ou 16 ms#
			csrr		t0, 3073		# t0 = tempo atual
			sub		t0, t0, s11		# t0 = tempo atual - ultimo frame
			li		t1, 0		# 16ms 
			bltu		t0, t1, MAIN_LOOP	


			

			call 	KEY	#verifica teclado
			call    GRAVITY	#SE no ar, aumenta a velocidade da gravidade
			
			#Confere se está correndo para aumentar velocidade
			la t0, RUNNING
			lb t1, 0(t0)
			beq t1, zero, NO_RUN	#Se igual a zero, nao esta correndo
			li t1, 2
			mul a0, a0, t1
			NO_RUN:
			
			
			#Soma as posicoes novas da KEY
			la t0, PLAYER_POS
			lw t1, 0(t0)			#x
			fcvt.s.w ft1, a0
			fmul.s ft0, ft1, fs2		#deslocamento x velocidade horizontal
			fcvt.w.s a0, ft0
			add t1, t1, a0
			sh t1, 0(t0)
				
			
			lw t1, 4(t0)			#y
			fcvt.s.w ft1, a1
			fmul.s ft0, ft1, fs3		#deslocamento y velocidade horizontal
			fcvt.w.s a1, ft0
			add t1, t1, a1
			sh t1, 4(t0)
			
			
			li a0, 0
			li a1, 0
			
			
			la		t0, PLAYER_POS
			lw		t1, 0(t0)		# fs0 = char x
			lw		t2, 4(t0)		# fs1 = char y
			
			fcvt.s.w fs0, t1
			fcvt.s.w fs1, t2
			
					
			call SELECT_SECTOR #select sector para colisao
			call SCIENCE_COLLISION

			#calcular a camera do jogador como visao do mapa levando em conta a posicao central do jogador, serve de base para movimentacao do parallax
			call SELECT_SECTOR #select sector para colisao
			call VERIFY_MAP_POS		
						
																																				
																		
MAP_BACKGROUND:		
			call SELECT_BACKGROUND
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
			
OFF_BACKGROUND:		#procedimento PREPARE_BACKGROUND pula aqui caso nao haja background																							

			
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
			call 	STANCE
			call	PRINT	
						
ENEMY_PRINT:		
			li	a7, 1024
			la	a0, Enemy
			li	a1, 0
			ecall
			mv t6, sp		#guarda valor 
ENEMY_PRINT_LOOP:	beq s10, zero, OUT_ENEMY_LOOP		
			
			
			call ENEMIES
			li t0, -1
			beq a1, t0, ENEMY_PRINT_LOOP#Se nao esta na tela, volta loop 	
			#a1 determinado em proc
			#a2 determinado em proc	
			la a3, Enemy_size
			#a4 determinado em proc
			mv	a5, s1
			#li a5, 1
			#li a5, 0
			#a6 determinado em proc
			#a7 determinado em proc
			call PRINT
			j ENEMY_PRINT_LOOP
			
	
						
			
OUT_ENEMY_LOOP:																											
#Restaura s10
beq t6, sp, WEAPON
la t1, QUEUE_ENEMIES

OUT_ENEMY_LOOP_J:
addi 	s10, s10, 4		#Proxima posicao
add t1, t1, s10
#pop()
lw	t0, 0(sp)	#armazena 
addi 	sp, sp, 4
sw 	t0, 0(t1)
j OUT_ENEMY_LOOP
	
	
	
	
	
						
WEAPON:	la	 t0, ATTACKING
	lb 	t1, 0(t0)
	beqz 	t1, FIM_MAIN_LOOP#(nao esta atacando)
		
	li	a7, 1024
	la	a0, Pocket
	li	a1, 0											
	ecall
	
	call WEAPON_POS
	
	la a3, Pocket_size
	#a4 determinado em WEAPON_POS
	mv	a5, s1
	# x = player x - map x
			
	call PRINT																																																																		
																					
FIM_MAIN_LOOP:		
csrr		t0, 3073		# t0 = tempo atual
sub		t0, t0, s11		# t0 = tempo atual - ultimo frame
li		t1, 24#16ms 
bltu		t0, t1, FIM_MAIN_LOOP
					




call SWITCH_FRAME		#mostra a nova tela	
beq s1, zero,FRAME_1
li s1, 0
j FRAME_0
FRAME_1:								
li s1, 1
FRAME_0:																																																																																																											
csrr		s11, 3073	#tempo do primeiro frame






#Verifica se vai ter transicao de fase
la t0, NEW_SECTOR
lb t1, 0(t0)
beqz t1, MAIN_LOOP
#j MAIN_LOOP1
#Novos valores de setor e posicao player
la t2, SETOR
lb t1, 0(t0) 
sb t1, 0(t2)
sb zero, 0(t0)

la t0, PLAYER_POS
la t2, NEW_PLAYER_POS

lw t1, 0(t2)	 #novo x
sw t1, 0(t0)

lw t1, 4(t2)	 #novo y
sw t1, 4(t0)



j MAIN_LOOP





li a7,10
ecall

#Procedimentos
.include "Enemies.s"
.include "Stance.s"
.include "Proc.s"	
.include "Keyboard.s"
.include "Pure_science.s"
.include "Weapon.s"
