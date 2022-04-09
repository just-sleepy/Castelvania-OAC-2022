.data



.text
KEY:		
		#create stack
			#addi	sp,sp,-48
			#save s10
			#sw	s10,44(sp)
			#update s10
			#addi	s10,sp,48	
						
		
		mv t6, s10	#estado inicial								
												
												
		csrr		t5, 3073														
		# O framerate de 60 fps
			#Se for 60 FPS, por exemplo, 1 segundo / 60 = 0.01666, ou 16 ms#
																
		K:																
																					
		#li 	t1, KDMMIO	# carrega o endere?o de controle do KDMMIO
		li 	t1,0xFF200000
		lw 	t0,0(t1)			# Le bit de Controle Teclado
		andi 	t0,t0,0x0001		# mascara o bit menos significativo
  	 	beqz	t0, KEY_END	# se nao tiver tecla pressionada, vai para o fim
  	 	
		lw	t0, 4(t1)	# se houver tecla pressionada, pega o valor  pra comparacao

		sw	t0,-400(s10)	#armazena no buffer a tecla na posicao atual
		addi	s10, s10, 4	#move para proxima casa
		
KEY_END:
		csrr		t0, 3073		# t0 = tempo atual
		sub		t0, t0, t5		# t0 = tempo atual - ultimo frame
		li		t1, 16	# 16ms 
		
		li t2, 0
		addi 		t2, t6, 40		#s10 em posicao 0
		beq 		s10, t2, BUFFER_MOVEMENTS
		bltu		t0, t1, K
		#j K
					
				
								
BUFFER_MOVEMENTS:
		

		li t2, 0	#se tecla w foi pressionada(0 = False, 1 = True)
		li t3, 0	#se tecla a foi pressionada(0 = False, 1 = True)
		li t4, 0	#se tecla s foi pressionada(0 = False, 1 = True)	
		li t5, 0	#se tecla d foi pressionada(0 = False, 1 = True)
LOOP_BUFFER:	
			
		#se confere todas as teclas pressionadas, e sem repetir, determina qual seram ativadas	
		beq, s10, t6, SELECT_KEYS
		addi	s10, s10, -4
		lw	t0, -400(s10)	#armazena 
		
	
		

		


		# Movimentos 
  		li		t1, 'w'
  		beq		t0, t1, KEY_W_VERIFY
  		li		t1, 'a'
  		beq		t0, t1, KEY_A_VERIFY
  		li		t1, 's'
  		beq		t0, t1, KEY_S_VERIFY
  		li		t1, 'd'
		beq		t0, t1, KEY_D_VERIFY
		j LOOP_BUFFER
		
    		KEY_W_VERIFY:		
			li t2, 1
			j LOOP_BUFFER
		
		KEY_A_VERIFY:		
			li t3, 1
			j LOOP_BUFFER
		
		KEY_S_VERIFY:		
			li t4, 1
			j LOOP_BUFFER
		
		KEY_D_VERIFY:		
			li t5, 1
			j LOOP_BUFFER
			
			
			
		
#KEY_NONE:	li a0, 0
#		li a1, 0	
#		ret		
		
#se soma valores que apos o call Key serao somados na posicao do personagem(movimentacao em pixels) sem fisica de velocidade inclusa
#a0 = x
#a1 = y	
SELECT_KEYS:
		
li a0, 0
li a1, 0

KEY_W:		beq t2, zero, KEY_A 	#se tecla nao esta pressionada vai para proximo												
		addi a0, a0, 0
		addi a1, a1, -4	


KEY_A:		beq t3, zero, KEY_S 	#se tecla nao esta pressionada vai para proximo	
		addi a0, a0, -4
		addi a1, a1, 0
		li t2, -1
		fcvt.s.w fs2, t2

KEY_S:		beq t4, zero, KEY_D 	#se tecla nao esta pressionada vai para proximo	
		addi a0, a0, 0
		addi a1, a1, 4
		

KEY_D:		beq t5, zero, FINISH_KEY 	#se tecla nao esta pressionada vai para proximo	
		addi a0, a0, 4
		addi a1, a1, 0
		li t2, 1
		fcvt.s.w fs2, t2
		
		
		
		
FINISH_KEY:
	ret		
		
		
		
							
