.data



.text
KEY:		

						
		
		mv t6, sp	#estado inicial								
												
												
		csrr		t5, 3073														
		# O framerate de 60 fps
		#Se for 60 FPS, por exemplo, 1 segundo / 60 = 0.01666, ou 16 ms#
																
		K:																
																					
		#li 	t1, KDMMIO	# carrega o endere?o de controle do KDMMIO
		li 	t1,0xFF210000
		lw 	t0,0(t1)			# Le bit de Controle Teclado
		andi 	t0,t0,0x0001		# mascara o bit menos significativo
  	 	beqz	t0, KEY_END	# se nao tiver tecla pressionada, vai para o fim
  	 	
		lw	t0, 4(t1)	# se houver tecla pressionada, pega o valor  pra comparacao

		#Push()
		addi sp, sp, -4
		sw	t0,0(sp)	#armazena no buffer a tecla na posicao atual
		
		
KEY_END:
		csrr		t0, 3073		# t0 = tempo atual
		sub		t0, t0, t5		# t0 = tempo atual - ultimo frame
		li		t1, 16	#16ms 
		
		#li 		t2, 0
		#addi 		t2, t6, 400		#s10 em posicao 0
		#beq 		s10, t2, BUFFER_MOVEMENTS
		bltu		t0, t1, K
					
									
BUFFER_MOVEMENTS:
		li t2, 0	#se tecla w foi pressionada(0 = False, 1 = True)
		li t3, 0	#se tecla a foi pressionada(0 = False, 1 = True)
		li t4, 0	#se tecla s foi pressionada(0 = False, 1 = True)	
		li t5, 0	#se tecla d foi pressionada(0 = False, 1 = True)
LOOP_BUFFER:	
			
		#se confere todas as teclas pressionadas, e sem repetir, determina qual seram ativadas	
		beq, sp, t6, SELECT_KEYS
		#pop()
		lw	t0, 0(sp)	#armazena 
		addi sp, sp, 4

		# Movimentos 
  		li		t1, 'w'
  		beq		t0, t1, KEY_W_VERIFY
  		li		t1, 'a'
  		beq		t0, t1, KEY_A_VERIFY
  		li		t1, 's'
  		beq		t0, t1, KEY_S_VERIFY
  		li		t1, 'd'
		beq		t0, t1, KEY_D_VERIFY
		li		t1, 'r'
		beq		t0, t1, KEY_R_VERIFY
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
			
		KEY_R_VERIFY:		
			li s5, 1
			j LOOP_BUFFER	
			
			

#se soma valores que apos o call Key serao somados na posicao do personagem(movimentacao em pixels) sem fisica de velocidade inclusa
#a0 = x
#a1 = y	
SELECT_KEYS:
bne t3, zero,  STILL_MOVING
bne t5, zero, STILL_MOVING
la t0, MOVING		#Determina q o personagem nao se move
sb zero, 0(t0)

la t0, ON_AIR
lb t1, 0(t0)
li t0, 1
beq t1, t0, MOMENTO 		#Se t1 igual a zero, significa que nao esta no ar e nao precisa de momento
fcvt.s.w fs2, zero
MOMENTO: #Nao zera a velocidade de fs2

la t0, PLAYER_STANCE		
lh t1, 0(t0)
li a0, 16
bge a0, t1, STILL_MOVING #Se a stance for maior que 16 significa q o personagem não estava parado
li t1, 0
sh t1, 0(t0)

STILL_MOVING:#COntinua se movendo se houver o pulo		
						
li a0, 0
li a1, 0

		la t0, JUMP
		lb t1, 0(t0)
		beq t1, zero, KEY_W	#Se jump diferente de 0, se nao tiver tecla pressionada, boost nao poderá ser usado até queda
		beq t2, zero, KEY_W_NOBOOST
KEY_W:		beq t2, zero, KEY_A 	#se tecla nao esta pressionada vai para proximo												
		la t0, JUMP
		li t1, 1
		sb t1, 0(t0)
		j KEY_A
KEY_W_NOBOOST:	la t0, JUMP_BOOST_LIMIT
		li t1, -1
		sb t1, 0(t0)		

KEY_A:		beq t3, zero, KEY_S 	#se tecla nao esta pressionada vai para proximo	
		addi a0, a0, 1	#movimento horizontal
		li t2, -2	
		fcvt.s.w fs2, t2	#velocidade horizontal
		la t0, MOVING		#Determina q o personagem se move
		li t1, 1
		sb t1, 0(t0)
		la t1, PLAYER_LOOK	#Olhando para a esquerda
		li t0, 1
		sb t0, 0(t1)

KEY_S:		beq t4, zero, KEY_D 	#se tecla nao esta pressionada vai para proximo	
		addi a0, a0, 0	#movimento horizontal
		addi a1, a1, 1	#movimento vertical
		li t2, -2
		fcvt.s.w fs3, t2	#velocidade vertical
		
		

KEY_D:		beq t5, zero, KEY_R 	#se tecla nao esta pressionada vai para proximo	
		addi a0, a0, 1	#movimento horizontal
		li t2, 2
		fcvt.s.w fs2, t2	#velocidade horizontal
		la t0, MOVING		#Determina q o personagem se move
		li t1, 1
		sb t1, 0(t0)
		
		la t0, PLAYER_LOOK      #Olhando para a direita
		sb zero, 0(t0)

KEY_R:		beq s5, zero, FINISH_KEY 	#se tecla nao esta pressionada vai para proximo
		la t0, RUNNING
		lb t1, 0(t0)
		beqz t1, START_RUNNING		#Se estiver correndo, para de correr, e vice versa
		sb zero, 0(t0)
		ret 
		START_RUNNING:
		li t1, 1
		sb t1, 0(t0)		
												
FINISH_KEY:
	ret		
		
		
		
							
