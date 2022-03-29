.include "val.s"

#imagens
.include "./Imagens/Ritcher_Stand0.data"

.data 

PLAYER_POS:	.half 450, 425	# posicao atual do player



Map_library:		.string "./Imagens/Map_library.bin"

#Area do mapa e da tela
SCREEN_SIZE:		.half 320, 240
FILE_MAP_SIZE:		.half 1284, 979		#sempre fazer x += 1(não sei o porque)

#CHAR_POS:	.float 704, 648

#RESPAWN_POS:	.half 704, 648	# respawn pos (x, y)













.text




MAIN:
# Open MAPA file
			li	a7, 1024
			la	a0, Map_library
			li	a1, 0
			ecall
			mv	s0, a0


			#flw		fs0, 0(t0)		# fs0 = char x

MAIN_LOOP:		call 	KEY	#verifica teclado
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
			#Determinar x
			la t0, PLAYER_POS
			lh t1, 0(t0)			#x
			addi	t1, t1, OFFSET_X	# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
			bge t1, zero,VERIFY_MAP_POS_JUMP #t1 > 0
			mv t1, zero			#senao t1 = 0
		VERIFY_MAP_POS_JUMP:
			la t0, FILE_MAP_SIZE
			lh t2, 0(t0)
			addi t2, t2, -320		#largura maxima de x = largura do mapa - largura da tela
			bge t2,t1, VERIFY_MAP_POS_JUMP2	#pega o menor entre os valores
			mv t1, t2
		VERIFY_MAP_POS_JUMP2:
			mv	s3, t1			# move o resultado pra s3

			#Determinar y
			la t0, PLAYER_POS
			lh t1, 2(t0)			#y
			addi t1, t1, OFFSET_X		# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
			bge t1, zero, VERIFY_MAP_POS_JUMP3 #t1 > 0
			mv t1, zero			#senao t1 = 0
		VERIFY_MAP_POS_JUMP3:
			la t0, FILE_MAP_SIZE
			lh t2, 0(t0)
			addi t2, t2, -320		#largura maxima de x = largura do mapa - largura da tela
			bge t2,t1, VERIFY_MAP_POS_JUMP4	#pega o menor entre os valores
			mv t1, t2
		VERIFY_MAP_POS_JUMP4:
			mv	s4, t1			# move o resultado pra s4
			
			
			j	MAP_PRINT




			
MAP_POS:		la	t0, PLAYER_POS
			lhu	s3, 0(t0)
			lhu	s4, 2(t0)									
			
MAP_PRINT:		
			li		s1, 0
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
			call	PRINT_MAP			
			

j MAIN_LOOP
# Registradores que devem permanecer inalterados
#
# s0 = Map
# s1 = frame
# s3 = mapa x
# s4 = mapa y



li a7,10
ecall

#Procedimentos
.include "Proc.s"	
.include "Keyboard.s"


