.data
Q:		.space 3	
QUEUE_ENEMIES:	.space 60

GHOST_SIZE:	.half 23, 23
.text


###################### ADD_GHOST ###############################
#	ARGUMENTOS:						#
#		a1 = posicao x					#
#		a2 = posicao y					#
#								#
#								#
#################################################################
ADD_GHOST:
la t0, QUEUE_ENEMIES 
add t0, t0, s10		#soma posicao s10 como a ultima posicao da queue, para colocar proximo enemy no final da queue
addi t0, t0, 4		#Proxima posicao
sw zero, 0(t0)		#Stance primario ghost = 0
addi t0, t0, 4		#Proxima posicao
sw a1, 0(t0)		#Armazena posicao x
addi t0, t0, 4		#Proxima posicao
sw a2, 0(t0)		#Armazena posicao y
addi s10, s10, 12
ret





#Determina a0, a1, a6, a7 para print do inimigo
ENEMIES:	la t0, QUEUE_ENEMIES 
		add t0, t0, s10		#soma posicao s10 como a ultima posicao da queue
		#Posicao y
		lw t1, 0(t0)		#carrega y
		#Posicao x
		addi t0, t0, -4		#Proxima posicao
		lw t2, 0(t0)		#carrega x
		
		#Stance do enemy
		addi t0, t0, -4		#Proxima posicao
		lw t5, 0(t0)		#carrega stance
		addi t0, t0, -4		#Proxima posicao
		addi s10, s10, -12	

		
		#Se esta dentro da tela do jogador
		#posicao mapa x(s3) <= enemy x(t2) and s3 + screen width >= t2 + enemy_width
		blt t2, s3, NOT_IN_SCREEN
		addi t3, s3, SCREEN_WIDTH #t3 = s3 + screen width
		addi t4, t2, 30
		blt t3, t4, NOT_IN_SCREEN
		#posicao mapa y(s4) <= enemy y(t1) and s4 + screen height >= t1 + enemy height
		blt t1, s4, NOT_IN_SCREEN
		addi t3, s4, SCREEN_WIDTH #t3 = s4 + screen height
		addi t4, t1, 30
		blt t3, t4, NOT_IN_SCREEN
		
		#Calcular posicao no mapa
		#enemy x(t2) - posicao mapa x(s3)  
		sub a1, t2, s3
		#enemy y(t1) - posicao mapa x(s4)  
		sub a2, t1, s4
		
		#Stance do enemy
		j STANCE_ENEMY
		
		NOT_IN_SCREEN:
		li a1, -1
		
		
		
STANCE_ENEMY:

li a6, 0
li a7, 0

#li t0, 4
#bge t0, t5, Ghost0
#li t0, 8
#bge t0, t5, Ghost1
#li t0, 12
#bge t0, t5, Ghost2
li t0, 16
bge t0, t5, Ghost3
li t0, 20
bge t0, t5, Ghost4
li t0, 24
bge t0, t5, Ghost5
ret		




Ghost3:
	la a4, GHOST_SIZE
	addi a6, a6, 90
	li a7, 0
	#lb t0, 0(t4)
	#beq t0, zero,Ghost4_J
	#addi a6, a6, 918
	#addi a7, a7, -3
	addi t5, t5, 1		#Rmove stance
		#Armazena na pilha temporaria
		#Push()
		addi sp, sp, -4
		sw t1,0(sp)	#armazena y
		addi sp, sp, -4
		sw t2,0(sp)	#armazena x
		addi sp, sp, -4
		sw t5,0(sp)	#armazena stance
	
		Ghost4_J:
		#addi t1, t1, 1
		#li t1, 0
		#sh t1, 0(t3)
		ret

Ghost4:
	la a4, GHOST_SIZE
	addi a6, a6, 116
	li a7, 0
	#lb t0, 0(t4)
	#beq t0, zero,Ghost4_J
	#addi a6, a6, 918
	#addi a7, a7, -3
	addi t5, t5, 1		#Rmove stance
		#Armazena na pilha temporaria
		#Push()
		addi sp, sp, -4
		sw t1,0(sp)	#armazena y
		addi sp, sp, -4
		sw t2,0(sp)	#armazena x
		addi sp, sp, -4
		sw t5,0(sp)	#armazena stance
	
		Ghost4_J:
		#addi t1, t1, 1
		#li t1, 0
		#sh t1, 0(t3)
		ret



Ghost5:
	la a4, GHOST_SIZE
	addi a6, a6, 90
	li a7, 0
	#lb t0, 0(t4)
	#beq t0, zero,Ghost4_J
	#addi a6, a6, 918
	#addi a7, a7, -3
	li t5, 12		#Reseta stance
		#Armazena na pilha temporaria
		#Push()
		addi sp, sp, -4
		sw t1,0(sp)	#armazena y
		addi sp, sp, -4
		sw t2,0(sp)	#armazena x
		addi sp, sp, -4
		sw t5,0(sp)	#armazena stance
	
		Ghost4_J:
		#addi t1, t1, 1
		#li t1, 0
		#sh t1, 0(t3)
		ret
