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
.eqv PLAYER_WIDTH		22
.eqv PLAYER_HEIGHT		48

#
# Offset do mapa em relação ao personagem
# Calculo pra chegar no offset:
#	x = (largura da tela - char width) / 2
#	y = (altura da tela - char height) / 2

.eqv OFFSET_X		-148
.eqv OFFSET_Y		-96


.eqv OFFSET_X_HITBOX		24#88	
.eqv OFFSET_Y_HITBOX		48#40



.data



HITBOX_MAP_SIZE:		.half 4352, 2856
HITBOX:				.string 		"./Imagens/Map_matriz.bin"




#MAPAS:
BACKGROUND:			.byte 1	#(1 para que tem background e 0 que nao tem)

#Ritcher
Ritcher:			.string 		"./Imagens/Ritcher.bin"
Ritcher_size:			.half 952, 896	#sempre fazer x += 1(não sei o porque)

#Library
Map_library:			.string 		"./Imagens/Map_library.bin"
FILE_MAP_SIZE:			.half 4356, 2860	#sempre fazer x += 1(não sei o porque)

#PARTE1
Backgorund_library_size: 	.half  640, 485
POS_Backgorund_library:		.half 1215, 1141

P1_library_size:		.half 1280, 974
POS_P1_library:			.half 113, 48
.include "./Imagens/setores_matriz/P1_Map_library.data"


#Area do mapa e da tela
SCREEN_SIZE:		.half 320, 240

