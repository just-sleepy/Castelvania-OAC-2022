.data



.text
KEY:					
		K:																
																					
		#li 	t1, KDMMIO	# carrega o endere?o de controle do KDMMIO
		li 	t1,0xFF200000
		lw 	t0,0(t1)			# Le bit de Controle Teclado
		andi 	t0,t0,0x0001		# mascara o bit menos significativo
  	 	beqz	t0, KEY_END	# se nao tiver tecla pressionada, vai para o fim
  	 	
		lw	t6, 4(t1)	# se houver tecla pressionada, pega o valor  pra comparacao
	
SELECT_KEYS:
li t1, 'w'
beq t6, t1, STILL_MOVING
li t1, 'a'
beq t6, t1, STILL_MOVING
la t0, MOVING		#Determina q o personagem nao se move
li t1, 0
sb t1, 0(t0)
la t0, PLAYER_STANCE		
lh t1, 0(t0)
li a0, 16
bge a0, t1, STILL_MOVING #Se a stance for maior que 16 significa q o personagem não estava parado
li t1, 0
sh t1, 0(t0)

STILL_MOVING:#COntinua se movendo se houver o pulo		
						
li a0, 0
li a1, 0		
			

		# Movimentos 
  		li		t1, 'w'
  		beq		t6, t1, KEY_W
  		li		t1, 'a'
  		beq		t6, t1, KEY_A
  		li		t1, 's'
  		beq		t6, t1, KEY_S
  		li		t1, 'd'
		beq		t6, t1, KEY_D
	
			
			
KEY_W:											
		addi a0, a0, 0	#movimento horizontal
		addi a1, a1, 1	#movimento vertical
		li t2, -4
		fcvt.s.w fs3, t2	#velocidade vertical
		ret

KEY_A:		
		addi a0, a0, 1	#movimento horizontal
		li t2, -1	
		fcvt.s.w fs2, t2	#velocidade horizontal
		la t0, MOVING		#Determina q o personagem se move
		li t1, 1
		sb t1, 0(t0)
		la t1, PLAYER_LOOK	#Olhando para a esquerda
		li t0, 1
		sb t0, 0(t1)
		ret

KEY_S:		
		addi a0, a0, 0	#movimento horizontal
		addi a1, a1, 1	#movimento vertical
		li t2, 1
		fcvt.s.w fs3, t2	#velocidade vertical
		ret
		

KEY_D:		
		addi a0, a0, 1	#movimento horizontal
		li t2, 1
		fcvt.s.w fs2, t2	#velocidade horizontal
		la t0, MOVING		#Determina q o personagem se move
		li t1, 1
		sb t1, 0(t0)
		
		la t0, PLAYER_LOOK      #Olhando para a direita
		sb zero, 0(t0)
		ret

		
KEY_END:
ret		
							
