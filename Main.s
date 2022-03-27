.include "val.s"

.data 

MAPA_POS:	.half 616, 320	# posicao atual no mapa

Map_library:		.string "./Imagens/Map_library.bin"

#Area do mapa e da tela
SCREEN_SIZE:		.half 320, 240
FILE_MAP_SIZE:		.half 1283, 979

#CHAR_POS:	.float 704, 648

#RESPAWN_POS:	.half 704, 648	# respawn pos (x, y)
.text




MAIN:
# Open MAPA file
			li		a7, 1024
			la		a0, Map_library
			li		a1, 0
			ecall
			mv		s0, a0


			#flw		fs0, 0(t0)		# fs0 = char x

			
GAME.POS:		la		t0, MAPA_POS
			lhu		s4, 0(t0)
			lhu		s3, 2(t0)									
			
GAME.PRINT:		
			li		s1, 0
			# Define os argumentos a0-a5 e desenha o mapa
			# os calculos pros argumentos a6-a7 s?o definidos acima
			mv		a0, s0
			li		a1, 0
			li		a2, 0
			la		a3, FILE_MAP_SIZE
			la		a4, SCREEN_SIZE
			mv		a5, s1
			mv		a6, s3
			mv		a7, s4
			call		PRINT_MAP			
			


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


