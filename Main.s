.include "val.s"

.data 

PLAYER_POS:	.half 450, 725	# posicao atual do player



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


#calcular a camera do jogador como visao do mapa levando em conta 
#a posicao central do jogador
#MAP_VERIFY_MAP_POS:	fcvt.w.s a0, fs0			# a0 = char x

			#addi	a0, a0, MAP_OFFSET_X	# a0 = char x - offset x do mapa (o mapa fica x pixels pra esquerda do personagem)
			#mv	a1, zero		# a1 = 0
			#call	MAX			# faz um MAX entre o resultado da conta e 0 (garante que o x do mapa seja >= 0)

			#li	a1, MAP_MAX_X		# a1 = maximo que o mapa pode ir no eixo X
			#call	MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo X

			#mv	s3, a0			# move o resultado pra s3

			# Calculo do y
			#fcvt.w.s a0, fs1			# a0 = char y
			#addi	a0, a0, MAP_OFFSET_Y	# a0 = char y - offset y do mapa (o mapa fica x pixels pra cima do personagem)
			#mv	a1, zero		# a1 = zero
			#call	MAX			# faz um MAX entre o resultado da conta e 0 (garante que o y do mapa seja >= 0)

			#li	a1, MAP_MAX_Y		# a1 = maximo que o mapa pode ir no eixo Y
			#call	MIN			# faz um MIN entre o resultado da conta e o MAXIMO que o mapa pode ir no eixo Y

			#mv	s4, a0			# move o resultado pra s4

			#j	MAP_PRINT




			
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


