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

PRINT:	
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




################### Troca_Frame #################################
#								#
#################################################################
SWITCH_FRAME:
li a5, 0xFF200604	#Carrega o endere?o responsÂ¨Â¢vel pela troca de frame
lw t1, 0(a5)		#Carrega-o em t1 para manipular
xori t1, t1, 0x001 	#Inverte o valor atual
sw t1, 0(a5)		#Armazena de volta em a5 o valor invertido
ret



################### Select background #################################
#	la a0 = setor size					#
#	la a1 = setor posicao					#
#	la a2 = background size					#
#	la a3 = background posicao				#
#	la a4 = Mapa do setor size				#
#################################################################







################### Background #################################
#	la a0 = setor size					#
#	la a1 = setor posicao					#
#	la a2 = background size					#
#	la a3 = background posicao				#
#	la a4 = Mapa do setor size				#
#################################################################
PREPARE_BACKGROUND:
#Verifica se tem background
			la t0, BACKGROUND
			lb t1, 0(t0)
			beq t1, zero, OFF_BACKGROUND
	
		
		#Calcular a6, a7 de acordo com pos do mapa
			#X

			lh t1, 0(a0)
			lh t2, 0(a2)  
			div t3, t1, t2   #valor x: de proporcao = (tamanho x do mapa / tamanho background x) + 1
			addi t3, t3, 1	 #corretor de proporcao	
			
			lh t1, 0(a1)
			sub t4, s3, t1	#posicao inicial do setor menos posicao atual no setor
			
			div a6, t4, t3	 #a6 = posicao x mapa / proporcao de x 
			lh t1, 0(a3)
			add a6, a6, t1	# soma da posicao inicial com a movimentacao dinamica
			
			#calcular se a camera na posicao dinamica n esta ultrapassando os limites do mapa
			lh t1, 0(a4)
			sub t2, t1, a6		#t2 = diferenca entre pos dinamica do background com o tamanho total		
			li t0, 320			
			bge t2, t0, J_BACKGROUND#se t2 < 320(linha abaixo)
			addi t1, t1, -320
			mv a6, t1
			J_BACKGROUND:

			
			

			#Y
			lh t1, 2(a0)
			lh t2, 2(a2)  
			div t3, t1, t2	#valor y: de proporcao = valor y: de proporcao = (tamanho x do mapa / tamanho background x) + 1
			addi t3, t3, 1
			
			lh t1, 2(a1)
			sub t4, s4, t1	#posicao inicial do setor menos posicao atual no setor
			
			
			div a7, t4, t3	#a7 = posicao x mapa / proporcao de y
			lh t1, 2(a3)
			add a7, a7, t1	# soma da posicao inicial com a movimentacao dinamica

			#calcular se a camera na posicao dinamica n esta ultrapassando os limites do map
			lh t1, 2(a4)
			sub t2, t1, a7		#t2 = diferenca entre pos dinamica do background com o tamanho total		
			li t0, 240			
			bge t2, t0, J_BACKGROUND2#se t2 < 240(linha abaixo)
			addi t1, t1, -240
			mv a7, t1
			J_BACKGROUND2:
			#mudar valores para o print
			mv a3, a4
			mv a4, a2
			
			ret