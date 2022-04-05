# Endereço do Bitmap Display

.eqv F0_INIT_ADDR		0xff002580
.eqv F1_INIT_ADDR		0xff102580
.eqv FRAME_CONTROL_ADDRESS	0xFF200604

# KDMMIO
.eqv KDMMIO			0xFF200000


# Largura e altura da tela
.eqv SCREEN_WIDTH		320
.eqv SCREEN_HEIGHT		240



# Tamanho do mapa (mapa.bin)
.eqv MAPA_WIDTH			1283
.eqv MAPA_HEIGHT		979

# Tamanho do personagem (char.bin)
.eqv PLAYER_WIDTH		24
.eqv PLAYER_HEIGHT		48

#
# Offset do mapa em relação ao personagem
# Calculo pra chegar no offset:
#	x = (largura da tela - char width) / 2
#	y = (altura da tela - char height) / 2

.eqv OFFSET_X		-148
.eqv OFFSET_Y		-96



.data
#MAPAS:
BACKGROUND:			.byte 1	#(1 para que tem background e 0 que nao tem)

#Ritcher
Ritcher:			.string 		"./Imagens/Ritcher.bin"
Ritcher_size:			.half 476, 896	#sempre fazer x += 1(não sei o porque)

#Library
Map_library:			.string 		"./Imagens/Map_library.bin"
FILE_MAP_SIZE:			.half 4356, 1744	#sempre fazer x += 1(não sei o porque)

#PARTE1
Backgorund_library_size: 	.half  640, 485
POS_Backgorund_library:		.half 1215, 1141

P1_library_size:		.half 1280, 975
POS_P1_library:			.half 113, 48



#Area do mapa e da tela
SCREEN_SIZE:		.half 320, 240

