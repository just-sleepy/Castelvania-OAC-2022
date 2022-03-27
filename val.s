# Endereço do Bitmap Display
# (ja foi somado +30 na linha pra compensar a altura da tela que nao e 240)
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
.eqv CHAR_WIDTH			32
.eqv CHAR_HEIGHT		32

#
# Offset do mapa em relação ao personagem
# Calculo pra chegar no offset:
#	x = (largura da tela - char width) / 2
#	y = (altura da tela - char height) / 2
# Com MAP_OFFSET_Y = -78 o personagem fica no meio,
# mas acredito que o personagem deveria ficar um pouco mais abaixo da linha do meio,
# por isso coloquei -120.
#
.eqv MAP_OFFSET_X		-144
.eqv MAP_OFFSET_Y		-130
