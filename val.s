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

#-------------------Science-------------------------
.eqv MAX_GRAV 		10
.eqv BOOST_LIMIT 	22
.eqv JUMP_H		-4










.data

#Enemies
Enemy:				.string 		"./Imagens/Enemies.bin"
Enemy_size:			.half 1064, 527	#sempre fazer x += 1(não sei o porque)




HITBOX_MAP_SIZE:		.half 4352, 2856
HITBOX:				.string 		"./Imagens/Map_matriz.bin"




#MAPAS:
BACKGROUND:			.byte 0	#(1 para que tem background e 0 que nao tem)

#Ritcher
Ritcher:			.string 		"./Imagens/Ritcher.bin"
Ritcher_size:			.half 952, 896	#sempre fazer x += 1(não sei o porque)

#Weapon
Pocket:				.string 		"./Imagens/Pocket.bin"
Pocket_size:			.half 3344, 620


#Library
Map:			.string 		"./Imagens/MAPA.bin"
FILE_MAP_SIZE:			.half 4356, 2860	#sempre fazer x += 1(não sei o porque)

#--------------------setores------------------------------------------------
SETOR: 				.byte 1
NEW_SECTOR:			.byte 0

NEW_PLAYER_POS:			.word 380, 900	# posicao nova para proximo loop caso haja transicao

#PARTE1
Backgorund_library_size: 	.half  640, 485
POS_Backgorund_library:		.half 1215, 1141

P1_library_size:		.half 1280, 975
POS_P1_library:			.half 113, 48
.include "./Imagens/setores_matriz/P1_Map_library.data"

#PARTE2
P2_library_size:           .half 512, 240
POS_P2_library:            .half 3022, 1440
.include "./Imagens/setores_matriz/P2_Map_library.data"

#PARTE3
Backgorund_2_library_size: 	.half  300, 333
POS_Backgorund_2_library:	.half 2155, 1029

P3_library_size:           .half 320, 719
POS_P3_library:            .half 2660, 1195
.include "./Imagens/setores_matriz/P3_Map_library.data"

#PARTE4
P4_library_size:           .half 320, 240
POS_P4_library:            .half 3022, 1179
.include "./Imagens/setores_matriz/P4_Map_library.data"

#PARTE5
P5_library_size:           .half 1792, 719
POS_P5_library:            .half 2450, 48
.include "./Imagens/setores_matriz/P5_Map_library.data"

#PARTE6 
P6_library_size:           .half 512, 240
POS_P6_library:            .half 3022, 1713
.include "./Imagens/setores_matriz/P6_Map_library.data"

#PARTE7
P7_library_size:           .half 320, 240
POS_P7_library:            .half 3387, 1179
.include "./Imagens/setores_matriz/P7_Map_library.data"

#PARTE8
P8_library_size:           .half 768, 240
POS_P8_library:            .half 3022, 1983
.include "./Imagens/setores_matriz/P8_Map_library.data"

#Area do mapa e da tela
SCREEN_SIZE:		.half 320, 240

