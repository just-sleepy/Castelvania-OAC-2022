###########################################
#                                         #
#             	Procedimentos             #
#                                         #
###########################################




###################### PROCEDIMENTO PRINT_MAP ###################
#	ARGUMENTOS:						#
#		a0 = file map					#
#		a1 = x na tela					#
#		a2 = y na tela					#
#		a3 = endereço do tamanho da imagem		#
#		a4 = endereco do tam. da area de desenho	#
#		a5 = frame (0 ou 1)				#
#		a6 = x na imagem				#
#		a7 = y na imagem				#
#################################################################

PRINT_MAP:	
		lhu		t1, 0(a3)

		# Calculo do offset na imagem
		mul		t0, a7, t1		# t0 = y na imagem * tamanho de cada linha
		add		t0, t0, a6		# offset imagem += x na imagem
		
		# Calculo frame
		li		t1, 0xFF0		# t1 = 0xFF0
		add		a5, a5, t1		# frame = 0xFF0 + frame
		slli		a5, a5, 16		# frame << 16
		slli		a5, a5, 4		# frame << 4
		
		# Calculo do offset na tela
		li		t1, SCREEN_WIDTH
		mul		t1, t1, a2		# t1 = 320 * y
		add		t1, t1, a1		# t1 = (320 * y) + x
		add		a5, t1, a5		# a5 = a5 + (320 * y) + x
		
		lhu		t2, 2(a4)
		# Calculo do endereço final na tela
		li		t1, SCREEN_WIDTH
		mul		t1, t1, t2		# t1 = 320 * h
		add		t1, t1, a5		# t1 = a5 + (320 * h) + w
		
		lhu		a3, 0(a3)
		lhu		a4, 0(a4)
		# t0 = offset na imagem
		# s5 = offset na tela
		# t1 = endereço final da tela
		
PRINT.LOOP:	# salva a0 antes de fazer as syscalls
		mv		t5, a0
		
		# seek no arquivo da imagem
		li		a7, 62
		mv		a1, t0			# t0 = offset na imagem
		li		a2, 0
		ecall
		
		# restaura a0 pra proxima syscall
		mv		a0, t5
		
		# read no arquivo da imagem
		li		a7, 63
		mv		a1, a5			# a5 = offset na tela
		mv		a2, a4
		ecall					# write line
		
		# restaura a0 pro proximo loop
		mv		a0, t5
		
		# incrementar offset da imagem
		add		t0, t0, a3		# offset da imagem += largura da imagem
		
		# incrementar offset da tela
		addi		a5, a5, SCREEN_WIDTH	# offset da tela += largura da tela
		
		# a5 = endereco atual da tela
		# t1 = endereco final da tela
		# while a5 < t1 continue loop	
		bltu		a5, t1, PRINT.LOOP

		ret



#--------------------------------------------------------------------------------------------------------------------------------------------------------#
################### PROCEDIMENTO PRINT_PLAYER ###################
#	ARGUMENTOS:						#
#		a0 = file map					#
#		a1 = x na tela					#
#		a2 = y na tela					#
#		a3 = frame (0 ou 1)				#
#								#
#################################################################

PRINT_PLAYER:
#la t0, %data
#li s0,%hexf0 

#li s1, %pula


    lw t1, 0(a0)         #x(linhas)
    lw t2, 4(a0)         #y(colunas)
    lw t6, 0(a0)       	 #armazena o n de linhas da imagem para incrementar em t1 sem ser alterado
    mul t3, t1, t2       #numero total de pixels
    addi a0, a0, 8       #Primeiro pixel
    li t4, 0        	 #contador
    
    # Calculo frame
		li		t1, 0xFF0		# t1 = 0xFF0
		add		a3, a3, t1		# frame = 0xFF0 + frame
		slli		a3, a3, 16		# frame << 16
		slli		a3, a3, 4		# frame << 4		
    
IMPRIME_F0:
    beq t4, t3, Impressaopequena_FIM       #quando finalizar, pula para a fun?o desejada
    lb t5, 0(a0)
    sb t5, 0(s0)
    addi a0, a0, 1
    addi s0, s0, 1    
    addi t4, t4, 1
    beq t4, t6, PULA_F0        #quando chegar ao final de uma linha, pula para a seguinte    
    j     IMPRIME_F0
    
    PULA_F0:
    add t6, t6, t1            #incrementa o numero de pixels impressos pelo n de linhas para o proximo beq ainda pular linha.
    add s0, s0, s1
    j IMPRIME_F0    
    
Impressaopequena_FIM:
	jr s5		#volta pra s5


