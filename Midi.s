.data
MUSIC_NOTAS:		.word 67,147,64,147,61,147,62,882,60,147,52,147,53,147,54,882,60,882,50,147,52,147,54,147,62,441,61,294,56,294,53,294,52,147,60,735,60,882,67,147,64,147,61,147,62,882,60,147,52,147,53,147,54,882,60,882,62,294,57,147,62,441,61,294,56,294,53,294,52,147,60,1617,60,1764,68,147,67,147,71,147,68,1029,60,294,68,147,67,147,71,147,68,1029,60,294,67,294,64,294,60,294,66,882,65,882,60,882,0,0
#.word 60,657,62,109,64,109,61,876,60,657,62,109,64,109,65,293,64,289,62,293,60,293,59,289,57,293,62,293,60,289,59,293,60,1752, 0, 0
MUSIC_STATUS:		.word 0, 0

.text
MUSIC.SETUP:		# guarda prox. notas no MUSIC_STATUS
			la		t0, MUSIC_NOTAS
			la		t1, MUSIC_STATUS
			sw		t0, 4(t1)
			sw		zero, 0(t1)
		
			ret

###################### PROCEDIMENTO MUSIC ######################
#	ARGUMENTOS:						#
#		a0 = endereco status				#
#		a2 = instrumento				#
#		a3 = volume					#
#################################################################
MUSIC.PLAY:		la		a0, MUSIC_STATUS
			li		a2, 88
			li		a3, 40

			lw		t0, 0(a0)
			beqz		t0, MUSIC.PLAY.NOTE

			csrr		t1, 3073		# current time
			bltu		t1, t0, MUSIC.RET	# if (now < next note) do nothing ELSE play note

MUSIC.PLAY.NOTE:	lw		t0, 4(a0)		# t0 = current note address
			lw		t1, 0(t0)		# nota
			lw		t2, 4(t0)		# duracao

			beqz		t1, MUSIC.LAST.PLAYED	# nota == 0, só espera

			mv		t3, a0		# salva a0 temporariamente 

			mv		a0, t1		# a0 = nota
			mv		a1, t2		# a1 = duracao
			li		a7, 31		# define a chamada de syscall
			ecall				# toca a nota

			mv		a0, t3		# restaura a0

MUSIC.LAST.PLAYED:	beqz		t2, MUSIC.SETUP	# Caso as duas prox. notas forem 0, reseta.

			csrr		t3, 3073	# current time
			add		t3, t3, t2	# current time + note duration = next note time
			sw		t3, 0(a0)	# save next note time

			addi		t0, t0, 8	# incrementa endereço da proxima nota
			sw		t0, 4(a0)	# salva proxima nota

MUSIC.RET:		ret