.data
Q:		.space 3	
QUEUE_ENEMIES:	.space 804		#Espaço para 40 enemies -> 20(espaço ocupado por cada um) x 40 = 640

GHOST_SIZE:	.half 23, 23

ZOMBIE_SIZE:	.half 30, 46

Death_enemy_size:	.half 32, 32
Heart_size:		.half 17, 17		
Ritcher_damaged: 	.byte 0	#(se estiver ferido = 1, caso contrario, 0.)
.text

.eqv GHOST_VELOCITY		1
.eqv GHOST_HP			1

.eqv ZOMBIE_VELOCITY		1
.eqv ZOMBIE_HP			20

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
li t1, GHOST_HP
sw t1, 0(t0)		#Vida ghost = 1
addi t0, t0, 4		#Proxima posicao
sw a1, 0(t0)		#Armazena posicao x fixa para movimentação
addi t0, t0, 4		#Proxima posicao
sw a1, 0(t0)		#Armazena posicao x
addi t0, t0, 4		#Proxima posicao
sw a2, 0(t0)		#Armazena posicao y
addi s10, s10, 20
ret


###################### ADD_ZOMBIE ###############################
#	ARGUMENTOS:						#
#		a1 = posicao x					#
#		a2 = posicao y					#
#								#
#								#
#################################################################
ADD_ZOMBIE:
la t0, QUEUE_ENEMIES 
add t0, t0, s10		#soma posicao s10 como a ultima posicao da queue, para colocar proximo enemy no final da queue
addi t0, t0, 4		#Proxima posicao
li t1, 39
sw t1, 0(t0)		#Stance primario ghost = 0
addi t0, t0, 4		#Proxima posicao
li t1, ZOMBIE_HP
sw t1, 0(t0)		#Vida
addi t0, t0, 4		#Proxima posicao
sw a1, 0(t0)		#Armazena posicao x fixa para movimentação
addi t0, t0, 4		#Proxima posicao
sw a1, 0(t0)		#Armazena posicao x
addi t0, t0, 4		#Proxima posicao
sw a2, 0(t0)		#Armazena posicao y
addi s10, s10, 20
ret


###################### ENEMIES ##################################
#	RESULTADO:						#
#		a1 = posicao x	no bitmap			#
#		a2 = posicao y	no bitmap			#
#		a6 = posicao x	no mapa de enemies		#
#		a7 = posicao y	no mapa de enemies		#
#								#
#################################################################
#Determina a1, a2, a6, a7 para print do inimigo
ENEMIES:	la t0, QUEUE_ENEMIES 
		add t0, t0, s10		#soma posicao s10 como a ultima posicao da queue
		#Posicao y
		lw t1, 0(t0)		#carrega y
		#Posicao x
		addi t0, t0, -4		#Proxima posicao
		lw t2, 0(t0)		#carrega x
		#Posicao fixa de x
		addi t0, t0, -4		#Proxima posicao
		lw s7, 0(t0)		#carrega x
		#Vida enemy
		addi t0, t0, -4		#Proxima posicao
		lw s5, 0(t0)		#carrega vida
		#Stance do enemy
		addi t0, t0, -4		#Proxima posicao
		lw t5, 0(t0)		#carrega stance
		addi t0, t0, -4		#Proxima posicao
		addi s10, s10, -20	

		
		#------------------------------Se esta dentro da tela do jogador-----------------------------------------------------
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
		#enemy y(t1) - posicao mapa y(s4)  
		sub a2, t1, s4
		
		
		#------------------------------Se esta dentro do hitbox de ataque-----------------------------------------------------
		#Determina altura do inimigo
		
		
		li t0, 38
		bge t0, t5, GHOST_HEIGHT
		
		li t0, 50
		bge t0, t5, ZOMBIE_HEIGHT
		
		li t0, -72
		bge t5, t0, DEATH_HEIGHT
		
		li t0, -73
		bge t5, t0, HEART_HEIGHT
		
		
		GHOST_HEIGHT:
		la t0, GHOST_SIZE
		lh t4, 2(t0)
		j START_HITBOX_ENEMY 
		
		ZOMBIE_HEIGHT:
		la t0, ZOMBIE_SIZE
		lh t4, 2(t0)
		j START_HITBOX_ENEMY 
		
		DEATH_HEIGHT:
		la t0, Death_enemy_size
		lh t4, 2(t0)
		j START_HITBOX_ENEMY 
		
		HEART_HEIGHT:
		la t0, Heart_size
		lh t4, 2(t0)
		j START_HITBOX_ENEMY 
		
		#-----------------------------------------------------------------------
		START_HITBOX_ENEMY :
		la	t0, PLAYER_POS
		lw 	t3, 0(t0)			
		bge 	t2, t3, DIR_HITBOX	#Esta a esquerda
		#Enemy pela esquerda
		la 	t0, Whip_HITBOX
		lh 	t3, 0(t0)
		sub 	s6, t2, s3
		ble 	s6, t3, DAMAGE_BY_ENEMY		#se pos_whip x > enemy x, not in
		lh 	t3, 2(t0)
		sub 	s6, t1, s4
		ble 	t3, s6, DAMAGE_BY_ENEMY		#se pos_whip y < enemy y, not in
		add 	s6, s6, t4
		
		ble 	s6, t3, DAMAGE_BY_ENEMY		#se pos_whip y  > enemy y + Height_enemy, not in
		j DAMAGE_ENEMY
		
		DIR_HITBOX:
		#Ghost peladireita
		la 	t0, Whip_HITBOX
		lh 	t3, 0(t0)
		sub 	s6, t2, s3
		ble 	t3, s6, DAMAGE_BY_ENEMY		#se pos_whip x < enemy x, not in
		lh 	t3, 2(t0)
		sub 	s6, t1, s4
		ble 	t3, s6, DAMAGE_BY_ENEMY		#se pos_whip y < enemy y, not in
		add 	s6, s6, t4
		
		ble 	s6, t3, STANCE_ENEMY		#se pos_whip y  > enemy y + Height_enemy, not in
		j DAMAGE_ENEMY
		
		
		
		
		NOT_IN_SCREEN:
		li a1, -1
		j DAMAGE_BY_ENEMY
		
		
		DAMAGE_ENEMY:
		li t0, -73
		beq t0, t5, DAMAGE_BY_ENEMY
		li t0, -1
		bge t0, t5, DEATH_ENEMY
		#Damage
		addi s5, s5, -1
		beqz s5, ENEMY_DEAD
		
		la	t0, PLAYER_POS
		lw 	t3, 0(t0)			
		bge 	t2, t3, DIR_HITBOX_IMPULSION	#Esta a esquerda
		addi 	t2, t2, -3
		j DAMAGE_BY_ENEMY
		DIR_HITBOX_IMPULSION:
		addi 	t2, t2, 3
		
		j DAMAGE_BY_ENEMY
		
		ENEMY_DEAD:
		bge t5, zero, DEATH_INIT
		j DEATH_ENEMY
		
		
DAMAGE_BY_ENEMY:
	li t0, -73
	beq t0, t5, HEART_HEIGHT2
	li t0, -1
	#bge t0, t5, DEATH_ENEMY
	#Determina altura do inimigo para t4
	la t0, Ritcher_damaged
	lb t4, 0(t0)
	bne t4, zero, STANCE_ENEMY	#Se damaged, fica invulneravel 	
		
		li t0, 38
		bge t0, t5, GHOST_HEIGHT2
		
		li t0, 50
		bge t0, t5, ZOMBIE_HEIGHT2	
					
		GHOST_HEIGHT2:
		la t0, GHOST_SIZE
		lh t4, 2(t0)
		j DAMAGE_BY_ENEMY_INIT
		
		ZOMBIE_HEIGHT2:
		la t0, ZOMBIE_SIZE
		lh t4, 2(t0)
		j DAMAGE_BY_ENEMY_INIT	
		
		HEART_HEIGHT2:
		la t0, Heart_size
		lh t4, 2(t0)
		j DAMAGE_BY_ENEMY_INIT	
								
DAMAGE_BY_ENEMY_INIT:
	la	t0, PLAYER_POS	
	lw 	t3, 4(t0)	
	beq 	t3, t1, ENEMY_X_DAMAGE
	bge 	t3, t1, ENEMY_UP_DAMAGE	#Esta encima
	
	#senao esta abaixo
	#DAMAGE?
	addi 	t0, t3, 48		#Altura Ricther
	addi 	t0, t0, -10		#Correção maunal
	bge 	t1, t0, STANCE_ENEMY	#NO_DAMAGE_BY_ENEMY
	#continua	
	j  	ENEMY_X_DAMAGE
	
	ENEMY_UP_DAMAGE:
	#senao esta acima
	#DAMAGE?
	add 	t0, t1, t4		#Altura enemy
	addi 	t0, t0, -10		#Correção manual
	bge 	t3, t0, STANCE_ENEMY	#NO_DAMAGE_BY_ENEMY
	#continua	
	
	ENEMY_X_DAMAGE:						
	#Determina largura do inimigo para t4
		li t0, -73
		beq t0, t5, HEART_HEIGHT3
		
		li t0, 38
		bge t0, t5, GHOST_HEIGHT3
			
		GHOST_HEIGHT3:
		la t0, GHOST_SIZE
		lh t4, 0(t0)
		j ENEMY_X_DAMAGE_INIT
		
		ZOMBIE_HEIGHT2:
		la t0, ZOMBIE_SIZE
		lh t4, 0(t0)
		j ENEMY_X_DAMAGE_INIT
		
		HEART_HEIGHT3:
		la t0, Heart_size
		lh t4, 0(t0)
		j ENEMY_X_DAMAGE_INIT
					
		
	ENEMY_X_DAMAGE_INIT:
	
	la	t0, PLAYER_POS					
	lw 	t3, 0(t0)	
	beq 	t3, t2, DAMAGED_BY_ENEMY_LEFT
	bge 	t3, t2, ENEMY_RIGHT_DAMAGE	#Esta a direita		
	#senao esta a esquerda
	#DAMAGE?
	addi 	t0, t3, 24		#largura Ricther
	addi 	t0, t0, 0		#Correção maunal
	bge 	t2, t0, STANCE_ENEMY	#NO_DAMAGE_BY_ENEMY
	#continua	
	j  	DAMAGED_BY_ENEMY_LEFT
	
	ENEMY_RIGHT_DAMAGE:
	#senao esta a direita
	add 	t0, t2, t4		#largura enemy
	addi 	t0, t0, 0		#Correção manual
	bge 	t3, t0, STANCE_ENEMY	#NO_DAMAGE_BY_ENEMY
	
	
	
DAMAGED_BY_ENEMY_RIGHT:	
li t0, -71
beq t0, t5, HEART_COLLECT
li t4, -1
bge t4, t5, DEATH_ENEMY
	
la 	t0, HP
lb 	t3, 0(t0)	
addi 	t3, t3, -1
sb 	t3, 0(t0)	#Pega o valor de HP e diminue em 1

la t0, 	Ritcher_damaged
li t4, 1
sb t4, 0(t0)	#Ativa o ritvher_damaged para a stance			
li t0, 	3
fcvt.s.w fs2, t0	#lançado para direita
li t0, 	-2
fcvt.s.w fs3, t0	#lançado para cima										
j STANCE_ENEMY

DAMAGED_BY_ENEMY_LEFT:
li t0, -71
beq t0, t5, HEART_COLLECT
li t4, -1
bge t4, t5, DEATH_ENEMY

la 	t0, HP
lb 	t3, 0(t0)	
addi 	t3, t3, -1
sb 	t3, 0(t0)	#Pega o valor de HP e diminue em 1

la t0, 	Ritcher_damaged
li t4, 1
sb t4, 0(t0)	#Ativa o ritvher_damaged para a stance	
li t0, 	-3
fcvt.s.w fs2, t0	#lançado para esquerda
li t0, 	-2
fcvt.s.w fs3, t0	#lançado para cima
																																																
STANCE_ENEMY:



li a6, 0
li a7, 0

li t0, -1
bge t0, t5, DEATH_ENEMY

li t0, 6
bge t0, t5, Ghost0
li t0, 12
bge t0, t5, Ghost1
li t0, 18
bge t0, t5, Ghost2
li t0, 26
bge t0, t5, Ghost3
li t0, 30
bge t0, t5, Ghost4
li t0, 34
bge t0, t5, Ghost5
li t0, 38
bge t0, t5, Ghost6

li t0, 39
bge t0, t5, Zombie0
li t0, 45
bge t0, t5, Zombie1
li t0, 51
bge t0, t5, Zombie2
li t0, 57
bge t0, t5, Zombie3
li t0, 63
bge t0, t5, Zombie4
li t0, 67
bge t0, t5, Zombie5
li t0, 71
bge t0, t5, Zombie6
li t0, 72
bge t0, t5, Zombie7
ret		



Ghost0:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 0
	li 	a7, 0
	addi 	t5, t5, 1		#move stance
		j  Ghost_behaviour

	


Ghost1:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 18
	li 	a7, 0
	addi 	t5, t5, 1		#move stance
		j  Ghost_behaviour
		ret


Ghost2:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 44
	li 	a7, 0
	addi 	t5, t5, 1		#move stance
		j  Ghost_behaviour


Ghost3:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 65
	li 	a7, 0
	addi 	t5, t5, 1		#move stance	
		j  Ghost_behaviour

		
		
Ghost4:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 90
	li 	a7, 0
	la	t0, PLAYER_POS
	lw 	t3, 0(t0)	#se aproxima do y do personagem
	bge 	t2, t3, GHOST_LEFT4	#Esta a esquerda
	addi 	a6, a6, 413
		GHOST_LEFT4:
		addi 	t5, t5, 1		#move stance
		j  Ghost_behaviour
	
		
		

Ghost5:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 116
	li 	a7, 0
	la	t0, PLAYER_POS
	lw 	t3, 0(t0)	#se aproxima do y do personagem
	bge 	t2, t3, GHOST_LEFT5	#Esta a esquerda
	addi 	a6, a6, 362
		GHOST_LEFT5:
		addi 	t5, t5, 1		#stance
		j  Ghost_behaviour




Ghost6:
	la 	a4, GHOST_SIZE
	addi 	a6, a6, 90
	li 	a7, 0
	la	t0, PLAYER_POS
	lw 	t3, 0(t0)	#se aproxima do y do personagem
	bge 	t2, t3, GHOST_LEFT6	#Esta a esquerda
	addi 	a6, a6, 413	
		GHOST_LEFT6:
		li 	t5, 27		#Reseta stance
		j  Ghost_behaviour


Ghost_behaviour:	

	la	t0, PLAYER_POS	
	lw 	t3, 4(t0)	#se aproxima do y do personagem
	li 	t4, GHOST_VELOCITY
	beq 	t3, t1, GHOST_X
	bge 	t3, t1, GHOST_UP	#Esta encima
	
	#senao esta abaixo
	sub 	t1, t1, t4	
	j  	GHOST_X
	
	GHOST_UP:
	#senao esta acima
	add	t1, t1, t4
	
	GHOST_X:						
	la	t0, PLAYER_POS					
	lw 	t3, 0(t0)	#se aproxima do y do personagem
	beq 	t3, t2, ENEMY_NEXT
	bge 	t3, t2, GHOST_RIGHT	#Esta a direita
	
	#senao esta a esquerda
	sub	t2, t2, t4
	j 	ENEMY_NEXT
	GHOST_RIGHT:		
	add 	t2, t2, t4
	j ENEMY_NEXT	
																																																												

Zombie0:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 227
	li 	a7, 72
	addi 	t5, t5, 0		#move stance
	j  Zombie_behaviour

Zombie1:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 194
	li 	a7, 72
	addi 	t5, t5, 1		#move stance
	j  Zombie_behaviour
	
Zombie2:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 160
	li 	a7, 72
	addi 	t5, t5, 1		#move stance
	j  Zombie_behaviour
	
Zombie3:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 126
	li 	a7, 72
	addi 	t5, t5, 1		#move stance
	j   Zombie_behaviour			

Zombie4:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 484
	li 	a7, 72
	la	t0, PLAYER_POS
	lw 	t3, 0(t0)	
	bge 	t2, t3, ZOMBIE_RIGHT_S	#Esta a esquerda ritcher
	li 	a6, 93
		ZOMBIE_RIGHT_S:
		addi 	t5, t5, 1		#stance
		j   Zombie_behaviour	
Zombie5:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 551
	li 	a7, 72
	la	t0, PLAYER_POS
	lw 	t3, 0(t0)	
	bge 	t2, t3, ZOMBIE_RIGHT_S2	#Esta a esquerda ritcher
	li	 a6, 32
		ZOMBIE_RIGHT_S2:
		addi 	t5, t5, 1		#stance
		j   Zombie_behaviour
	
Zombie6:
	la 	a4, ZOMBIE_SIZE
	addi 	a6, a6, 582
	li 	a7, 72
	la	t0, PLAYER_POS
	lw 	t3, 0(t0)	
	bge 	t2, t3, ZOMBIE_RIGHT_S3	#Esta a esquerda ritcher
	li	 a6, 1
		ZOMBIE_RIGHT_S3:
		addi 	t5, t5, 1		#stance
		j   Zombie_behaviour
		
Zombie7:
	li t5, 63		#stance
	j   Zombie5
						
				
		
Zombie_behaviour:
	li t4, 40
	bge t5, t4, ZOMBIE_ATK
	
	la	t0, PLAYER_POS					
	lw 	t3, 0(t0)	
	bge	t3, t2, ZOMBIE_LEFT
	ZOMBIE_RIGHT:
	sub t3, t2, t3
	li t4, 100			#Distancia minima para zombie levantar do chao
	bge t4, t3, ZOMBIE_WAKE_UP_Y
	j ENEMY_NEXT
	ZOMBIE_LEFT:
	sub t3, t3, t2
	li t4, 100			#Distancia minima para zombie levantar do chao
	bge t4, t3, ZOMBIE_WAKE_UP_Y
	j ENEMY_NEXT
	
					
	ZOMBIE_WAKE_UP_Y:
	la	t0, PLAYER_POS					
	lw 	t3, 2(t0)	
	bge	t3, t1, ZOMBIE_UP
	ZOMBIE_DOWN:
	sub t3, t3, t1
	li t4, 100			#Distancia minima para zombie levantar do chao
	bge t4, t3, ZOMBIE_WAKE_UP
	j ENEMY_NEXT
	ZOMBIE_UP:
	sub t3, t1, t3
	li t4, 100			#Distancia minima para zombie levantar do chao
	bge t4, t3, ZOMBIE_WAKE_UP
	j ENEMY_NEXT
	
	ZOMBIE_WAKE_UP:
	addi t5, t5, 1			#Aumenta stance para levantar do chao																																																
	j ENEMY_NEXT

	ZOMBIE_ATK:
	la	t0, PLAYER_POS					
	lw 	t3, 0(t0)	
	bge	t3, t2, ZOMBIE_LEFT_ATK
	
	sub t0, s7, t2			#Posicao inicial - posicao fina
	li t4, 300			#Distancia maxima da posicao inicial
	ble t4, t0, ENEMY_NEXT	
	sub t3, t2, t3
	li t4, 120			#Distancia minima para zombie andar para tras
	bge t4, t3, ZOMBIE_ATKX
	li t4, 150			#Distancia maxima para zombie andar para tras
	bge t3, t4, ENEMY_NEXT
	
	
	
	addi 	t2, t2, 1
	j ENEMY_NEXT
	ZOMBIE_ATKX:
	addi 	t2, t2, -1
	j ENEMY_NEXT
	

	ZOMBIE_LEFT_ATK:
	sub t0, t2, s7			#Posicao inicial - posicao final
	li t4, 300			#Distancia maxima da posicao inicial
	ble t4, t0, ENEMY_NEXT	
	sub t3, t3, t2
	li t4, 120			#Distancia minima para zombie andar para tras
	bge t4, t3, ZOMBIE_ATKX2
	li t4, 150			#Distancia maxima para zombie andar para tras
	bge t3, t4, ENEMY_NEXT
	
	addi 	t2, t2, -1
	j ENEMY_NEXT
	ZOMBIE_ATKX2:
	addi 	t2, t2, 1
	j ENEMY_NEXT
	
DEATH_INIT:
li t5, -1

DEATH_ENEMY:

li t0, -5
bge t5, t0, Death0
li t0, -10
bge t5, t0, Death1
li t0, -15
bge t5, t0, Death2
li t0, -20
bge t5, t0, Death3
li t0, -25
bge t5, t0, Death4
li t0, -30
bge t5, t0, Death5
li t0, -35
bge t5, t0, Death6
li t0, -40
bge t5, t0, Death7
li t0, -45
bge t5, t0, Death8
li t0, -50
bge t5, t0, Death9
li t0, -55
bge t5, t0, Death10
li t0, -60
bge t5, t0, Death11
li t0, -65
bge t5, t0, Death12
li t0, -70
bge t5, t0, Death13
li t0, -73
bge t5, t0, HEART
ret

Death0:
	la 	a4, Death_enemy_size
	li	a6, 3
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT
		
Death1:
	la 	a4, Death_enemy_size
	li 	a6, 35
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT
		
Death2:
	la 	a4, Death_enemy_size
	li 	a6, 67
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT	
		
Death3:
	la 	a4, Death_enemy_size
	li 	a6, 100
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT	
		
Death4:
	la 	a4, Death_enemy_size
	li 	a6, 141
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT	
		
Death5:
	la 	a4, Death_enemy_size
	li 	a6, 175
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT
		
Death6:
	la 	a4, Death_enemy_size
	li 	a6, 207
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT	
		
Death7:
	la 	a4, Death_enemy_size
	li 	a6, 238
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT	
		
Death8:
	la 	a4, Death_enemy_size
	li 	a6, 281
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT
		
Death9:
	la 	a4, Death_enemy_size
	li 	a6, 314
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																																
		
Death10:
	la 	a4, Death_enemy_size
	li 	a6, 346
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT
		
Death11:
	la 	a4, Death_enemy_size
	li 	a6, 377
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT		
		
		
Death12:
	la 	a4, Death_enemy_size
	li 	a6, 422
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
		j  ENEMY_NEXT	
		
		
Death13:
	la 	a4, Death_enemy_size
	li 	a6, 455
	li 	a7, 489
	addi 	t5, t5, -1		#move stance
	
	
		#Ultima morte entao verifica a chance de dropar um coracao
		GERAR_ALEATORIO:
		#Guarda os registradores 
		mv t0, a7
		mv t3, a1
		mv t4, a0
		li a7, 40#RandSeed
		ecall
		li a1, 2	#Definir limite
		addi a0, a0, 272#Somar valor aleatorio (n sei pq)
		li a7, 42	#Gera o numero
		ecall
		mv t3, a0	#Armazena numero aleatorio (0 ou 1) em t3
		#Retorna os valores originais dos registradores a
		mv a7, t0
		mv a1, t3
		mv a0, t4
		
		#Se for 1:
		li t0, 1
		beq t3, t0, DROPA_CORACAO
		ret																											


HEART_COLLECT:
	la 	t0, MANA	#Aumenta mana 
	lb	t1, 0(t0) 
	li	t2, 15	#maximo
	beq	t1, t2, NO_MORE_MANA
	addi 	t1, t1, 4
	NO_MORE_MANA:
	sb 	t1, 0(t0)
	
	la 	t0, HP	#Aumenta vida
	lb	t1, 0(t0)
	li	t2, 15	#maximo
	beq	t1, t2, NO_MORE_HP
	addi 	t1, t1, 1
	NO_MORE_HP:	
	sb 	t1, 0(t0)
	
HEART:		
	la 	a4, Heart_size
	li 	a6, 569
	li 	a7, 499
				
				
					
							
DROPA_CORACAO:
li t5, -71	#Stance de coração				
							
													
ENEMY_NEXT:																																																																																																																											
	#Armazena na pilha temporaria
	#Push()
	addi sp, sp, -4
	sw t1,0(sp)	#armazena y
	addi sp, sp, -4
	sw t2,0(sp)	#armazena x
	addi sp, sp, -4	
	sw s7,0(sp)	#armazena fixo de x
	addi sp, sp, -4	
	sw s5, 0(sp)	#armazena vida
	addi sp, sp, -4
	sw t5,0(sp)	#armazena stance
	ret		
