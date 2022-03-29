# Endereço do Bitmap Display

.eqv F0_INIT_ADDR		0xff002580
.eqv F1_INIT_ADDR		0xff102580
.eqv FRAME_CONTROL_ADDRESS	0xFF200604

# KDMMIO
.eqv KDMMIO_CONTROL_ADDRESS	0xFF200000
.eqv KDMMIO_KEYDOWN_ADDRESS	0xFF210000

# Largura e altura da tela
.eqv SCREEN_WIDTH		320
.eqv SCREEN_HEIGHT		240



# Tamanho do mapa (mapa.bin)
.eqv MAPA_WIDTH			1283
.eqv MAPA_HEIGHT		979

# Tamanho do personagem (char.bin)
.eqv PLAYER_WIDTH		32
.eqv PLAYER_HEIGHT		324334

#
# Offset do mapa em relação ao personagem
# Calculo pra chegar no offset:
#	x = (largura da tela - char width) / 2
#	y = (altura da tela - char height) / 2

#.eqv OFFSET_X		?
#.eqv OFFSET_Y		?
