.data
PLAYER_LOOK:    .byte 0 	#(0: olhando para direita, 1: olhando para esquerda)
PLAYER_STANCE:	.half 0
MOVING:		.byte 0

.text

STANCE:
	la t3, PLAYER_STANCE
	lh t1, 0(t3)

	#Walk
	la t0, MOVING
	lb t2, 0(t0)
	bne t2, zero, WALK
	
	#Stand
	li t0, 16
	bge t0, t1, STAND

STAND:
bge zero, t1, Stance0
li t0, 4
bge t0, t1, Stance1
li t0, 8
bge t0, t1, Stance2
li t0, 12
bge t0, t1, Stance3
li t0, 16
bge t0, t1, Stance4
ret
#Determina a posicao do sprite de acordo com sua stance 
	Stance0:
	li a6, 8
	li a7, 10
	addi t1, t1, 1
	sh t1, 0(t3)
	ret
	
	Stance1:
	li a6, 30
	li a7, 10
	addi t1, t1, 1
	sh t1, 0(t3)
	ret

	Stance2:
	li a6, 52
	li a7, 10
	addi t1, t1, 1
	sh t1, 0(t3)
	ret	

	Stance3:
	li a6, 74
	li a7, 10
	addi t1, t1, 1
	sh t1, 0(t3)
	ret

	Stance4:
	li a6, 8
	li a7, 10
	li t1, 0
	sh t1, 0(t3)
	ret

WALK:	
li t0, 16		#Se a stance for menor ou igual a 16, inicia a stance de correr em 17
bge t1, t0, WALK_INIT
li t1, 17
sh t1, 0(t3)
																						
WALK_INIT:																																																																		
li t0, 20
bge t0, t1, Walk0
li t0, 23
bge t0, t1, Walk1
li t0, 26
bge t0, t1, Walk2
li t0, 29
bge t0, t1, Walk3
li t0, 32
bge t0, t1, Walk4
li t0, 35
bge t0, t1, Walk5
li t0, 38
bge t0, t1, Walk6
li t0, 41
bge t0, t1, Walk7
ret
	Walk0:
	li a6, 5
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret
	
	Walk1:
	li a6, 39
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret

	Walk2:
	li a6, 69
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret	

	Walk3:
	li a6, 101
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret

	Walk4:
	li a6, 131
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret
																																																																					
	Walk5:
	li a6, 167
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret
	
	Walk6:
	li a6, 196
	li a7, 147
	addi t1, t1, 1
	sh t1, 0(t3)
	ret
	
	Walk7:
	li a6, 221
	li a7, 147
	li t1, 17
	sh t1, 0(t3)
	ret