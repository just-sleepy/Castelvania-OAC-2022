KEY:		
		li 	t1, KDMMIO_KEYDOWN_ADDRESS	# carrega o endere?o de controle do KDMMIO
		lw 	t0,0(t1)			# Le bit de Controle Teclado
		andi 	t0,t0,0x0001		# mascara o bit menos significativo
  	 	beqz	t0, KEY_END	# se nao tiver tecla pressionada, vai para o fim
		lw	t0, 4(t1)	# se houver tecla pressionada, pega o valor  pra comparacao
		sw t2,12(t1)  		# escreve a tecla pressionada no display
	

		# Movimentos 
  		li		t1, 'w'
  		beq		t0, t1, KEY_W
  		li		t1, 'a'
  		beq		t0, t1, KEY_A
  		li		t1, 's'
  		beq		t0, t1, KEY_S
  		li		t1, 'd'
		beq		t0, t1, KEY_D
		
		
KEY_W:			
		ret

KEY_A:		
		ret

KEY_S:		
		ret

KEY_D:		
		ret		
		
		
		
		
KEY_END:	
		ret		
