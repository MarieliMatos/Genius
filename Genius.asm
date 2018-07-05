.data

mensagem_inicial:	.asciiz "\tGenius\n"
n_repeticoes:		.asciiz "\nInsira o numero de repeticoes: "
dificuldade:		.asciiz "\nDificuldade\n"
facil:			.asciiz "1. Facil\n"
medio:			.asciiz "2. Madio\n"
dificil:		.asciiz "3. Dificil\n"
inicio:			.asciiz "1. Iniciar jogo\n"
fim:			.asciiz "2. Encerrar o programa\n "
gameover:		.asciiz "\t\tGAME OVER!\n"
gamewin:		.asciiz "\t\tGAME WIN!\n"

.align 2
ringbuffer: 		 .space 32
sequencia_vetor:	 .word 0:256

.text
main:
	#inicializa ring buffer
	la $a0, ringbuffer 
	jal ring_buffer
	
	jal	init
	
	# -- Menu Principal -- 	
  	li 	$v0, 4          
  	la 	$a0, mensagem_inicial 
  	syscall
  
  	li 	$v0, 4          
  	la 	$a0, inicio 
  	syscall
  	li 	$v0, 4          
  	la 	$a0, fim
 	syscall
  	li 	$v0, 5
  	syscall
  	move	$t2, $v0

 	beq	$t2, 2, end_game
  
  	# Numero de repetições
  	li 	$v0, 4          
  	la 	$a0, n_repeticoes 
  	syscall
  	li 	$v0, 5
  	syscall
  	move	$t0, $v0
  
  	# Dificuldade	
  	li 	$v0, 4          
  	la 	$a0, dificuldade 
  	syscall
  	li 	$v0, 4          
  	la 	$a0, facil 
  	syscall
  	li 	$v0, 4          
  	la 	$a0, medio 
  	syscall
  	li 	$v0, 4          
  	la 	$a0, dificil 
  	syscall
  	li 	$v0, 5
  	syscall
  	move 	$t1, $v0

  	move  	$a0, $t0
  	move  	$a1, $t1
  	la	$a2, sequencia_vetor
  	# a0 -> n_repeticoes
  	# a1 -> dificuldade
  	# a2 -> sequencia_vetor
	jal	num
	jal	jogo
	
	end_game:
	li	$v0, 10
	syscall

init:
	addiu	$sp,$sp, -16
	sw	$ra, 16($sp)
	
	li	$a0, 4
	jal	draw_rectangle
	li	$a0, 5
	jal	draw_rectangle
	li	$a0, 6
	jal	draw_rectangle
	li	$a0, 7
	jal	draw_rectangle
	
	lw	$ra, 16($sp)
	jr	$ra	

num:
	move	$t0, $a0	# n repetições
	move	$t1, $a2	# end vetor
	# Soerteia Número  de 0-3
	num_loop:
	beqz	$t0, num_fim
	  	li	$a1, 4		# Numero maximo
  		li	$v0, 42		# Numero aleatorio
	  	syscall
  		
  		sw 	$a0, 0($t1)      		
	   	addi 	$t1, $t1, 4    		
	   	addi 	$t0, $t0, -1    	
 	j num_loop
  	
num_fim:
	jr	$ra

jogo:
# a0 -> n_repeticoes
# a1 -> dificuldade
# a2 -> sequencia_vetor
	addiu	$sp, $sp, -40
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$ra, 16($sp)
	
	move	$s0, $a0		# n repetições
	move	$s1, $a1		# dificuldade
	move	$s2, $a2		#sequencia_vetor
	li	$s3, 0
	li	$s5, 0
	loop_repeticao:
	bge	$s3, $s0, loop_repeticao_end
		la	$s4, sequencia_vetor
		acende_sequencia:
		bgt	$s5, $s3, acende_sequencia_end
			sw	$s0, 20($sp)
			sw	$s1, 24($sp)
			sw	$s2, 28($sp)
			sw	$s3, 32($sp)
			sw	$s4, 36($sp)
			sw	$s5, 40($sp)
			lw	$a0, 0($s4)	#elemento a ser tocado
			jal 	toca_seq
			
			lw	$s0, 20($sp)
			lw	$s1, 24($sp)
			lw	$s2, 28($sp)
			lw	$s3, 32($sp)
			
			addi	$s5, $s5, 1	
			addi 	$s4,$s4, 4	# ++vetor_sequencia
		j	acende_sequencia
		acende_sequencia_end:
		
		jogador:
		li	$s5, 0
		la	$s2, sequencia_vetor
		jogador_loop:
		bgt	$s5, $s3, jogador_loop_end 
			sw	$s0, 20($sp)
			sw	$s1, 24($sp)
			sw	$s2, 28($sp)
			sw	$s3, 32($sp)
			sw	$s4, 36($sp)
			sw	$s5, 40($sp)
			lw	$a0, 0($s4)	#elemento a ser tocado
			#jal	entrada
			
			sw	$v0, 12($sp)	# guasrda resultado
			beqz	$v0, loop_repeticao_end
			
			addi $s4, $s4, 4
			addi $s5, $s5, 1
		j	jogador_loop
		
		jogador_loop_end:
		li	$s5, 0			# reinicia for
		addi	$s3, $s3, 1
	j	loop_repeticao
	loop_repeticao_end:
	lw	$v0, 12($sp)
	beqz	$v0, jogo_fim
	
jogo_fim:
	li $v0, 4			
	la $a0, gamewin
	syscall
	
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$ra, 16($sp)
	addiu	$sp,$sp, 40
	jr	$ra

toca_seq:
	addiu	$sp,$sp, -16
	sw	$a0,  0($sp)
	sw	$ra, 16($sp)
	
	move	$a0, $s3	# $a0 = $s3
	jal	draw_rectangle
	jal	tom
	addi	$a0, $s3, 4
	jal	draw_rectangle
	
	lw	$a0, 0($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 16
	jr	$ra
	
tom:	
	beq	$a0, 0, tom_verde
	beq	$a0, 1, tom_vermelho
	beq	$a0, 2, tom_azul
	beq	$a0, 3, tom_amarelo
	
	tom_verde:
	li  	$v0, 31          # 
   	addi 	$a0, $zero, 61	# = pitch (0-127) 
	addi	$a1, $zero, 1000	# = duration in milliseconds 
	addi	$a2, $zero, 24	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
    	syscall
	j	tom_next
	tom_vermelho:
	li  	$v0, 31           
   	addi 	$a0, $zero, 62	# = pitch (0-127) 
	addi	$a1, $zero, 1000	# = duration in milliseconds 
	addi	$a2, $zero, 24	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
	syscall
	j	tom_next
	tom_azul:
	li  	$v0, 31           
   	addi 	$a0, $zero, 64	# = pitch (0-127) 
	addi	$a1, $zero, 1000	# = duration in milliseconds 
	addi	$a2, $zero, 24	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
	syscall
	j	tom_next
	tom_amarelo:
	li  	$v0, 31           
   	addi 	$a0, $zero, 65	# = pitch (0-127) 
	addi	$a1, $zero, 1000	# = duration in milliseconds 
	addi	$a2, $zero, 24	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
	syscall
	j	tom_next
	
	tom_next:
	
	beq	$a1, 1, _facil 
	beq	$a1, 2, _medio
	beq	$a1, 3, _dificil
	_facil:
	li	$v0, 32
	addi	$a0, $zero, 500
	syscall
	j	fim_tom
	_medio:
	li	$v0, 32
	addi	$a0, $zero, 300
	syscall
	j	fim_tom
	_dificil:
	li	$v0, 32
	addi	$a0, $zero, 100
	syscall
	j	fim_tom
	fim_tom:
	
	jr	$ra
	
entrada:
	addiu	$sp, $sp, -16
	sw	$a0, 0($sp)
	sw	$ra, 16($sp)
	
	# habilita a interrupção
	li	$t2, 2
	sw	$t0, 0xffff0000
	
	ring_vazio:
	la 	$a0, ringbuffer
	jal 	rbuf_empty			# confere se ring buffer está vazio
	bnez 	$v0, ring_vazio
	sw 	$zero, 0xffff0000
	jal 	read
	
	lw 	$t1, 0($sp)				
	
	_verde:
	bne	$t1, 0, _vermelho
	li	$a0, 0
	jal	draw_rectangle
	addi	$a0, $a0, 4
	jal	draw_rectangle
	bne	$v0, 119, errado
	j	entrada_fim
	_vermelho:
	bne	$t1, 1, _azul
	li	$a0, 1
	jal	draw_rectangle
	addi	$a0, $a0, 4
	jal	draw_rectangle
	bne	$v0, 'a', errado
	j	entrada_fim
	_azul:
	bne	$t1, 2, _amarelo
	li	$a0, 2
	jal	draw_rectangle
	addi	$a0, $a0, 4
	jal	draw_rectangle
	bne	$v0, 's', errado
	j	entrada_fim
	_amarelo:
	bne	$t1, 3, errado
	li	$a0, 3
	jal	draw_rectangle
	addi	$a0, $a0, 4
	jal	draw_rectangle
	bne	$v0, 'd', errado
	j	entrada_fim
	errado:
	li	$t3, 1
	
	entrada_fim:
	bne	$t3, 0, saida 
	li 	$v0, 4          
  	la 	$a0, gameover
  	syscall
  	li	$v0,	10
  	syscall
	
	saida:
	move	$v0, $t3
	lw	$a0, 0($sp)
	lw	$ra, 16($sp)
	addiu	$sp, $sp, 16
	jr	$ra
	
draw_rectangle:
	addiu	$sp,$sp, -48
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$a2, 8($sp)
	sw	$a3, 12($sp)	
	sw	$ra, 16($sp)
	sw	$s0, 20($sp)
	sw	$s1, 24($sp)
	sw	$s2, 28($sp)
	sw	$s3, 32($sp)
	sw	$s4, 36($sp)
  
  	beq    $a0, 0, green  # if $a0 =0 then green
  	beq    $a0, 1, red
	beq    $a0, 2, blue
  	beq    $a0, 3, yellow
  	beq    $a0, 4, green_off  
  	beq    $a0, 5, red_off
  	beq    $a0, 6, blue_off
  	beq    $a0, 7, yellow_off
  
# Display "desligado"
	blue_off:
  	li    $s0, 8    
  	li     $s1, 24     
  	li     $s2, 25    
  	li     $s3, 30 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x5164ff                # cor
  	j	 next
	yellow_off:
  	li     $s0, 25    
  	li     $s1, 30     
  	li     $s2, 7   
  	li     $s3, 23 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xffff69 
  	j	 next
	red_off:
  	li     $s0, 2    
  	li     $s1, 7     
  	li     $s2, 7    
  	li     $s3, 23 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xff5c51                # cor
  	j      next        # jump to next
  
	green_off:
	li     $s0, 8    
  	li     $s1, 23     
  	li     $s2, 1    
  	li     $s3, 5 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x5cff51                # cor
  	j      next                           # jump to next
	
	green:
  	li     $s0, 8    
  	li     $s1, 23     
  	li     $s2, 1    
  	li     $s3, 5 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x11d604                # cor
  	j      next
  	
	blue:
  	li     $s0, 8    
  	li     $s1, 24     
  	li     $s2, 25    
  	li     $s3, 23 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x041bd6                # cor
  	j	 next
	yellow:
  	li     $s0, 25    
  	li     $s1, 30     
  	li     $s2, 7    
  	li     $s3, 23 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xd6d618 
  	j	 next
	red:
  	li     $s0, 2    
  	li     $s1, 7     
  	li     $s2, 70    
  	li     $s3, 23
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xd61104                # cor
  	j      next        # jump to next

	next:
 	 bge    $s2, $s3, draw_rectangle_end  # se y0==y ->  fim da func draw_rectangle
	draw_rectangle_loop:
  	bge    $s0, $s1, draw_rectangle_next_line

  	move   $a1, $s0
  	move   $a2, $s2
  	jal    set_pixel        # jump to set and save position to $ra
  
  	addi   $s0, $s0, 1
  	j      draw_rectangle_loop

	draw_rectangle_next_line:
    	addi   $s2, $s2, 1                   # y0++
    	move   $s0, $s4                      # s0 = x0
    	j      next
	draw_rectangle_end:
	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$a2, 8($sp)
	lw	$a3, 12($sp)	
	lw	$ra, 16($sp)
	lw	$s0, 20($sp)
	lw	$s1, 24($sp)
	lw	$s2, 28($sp)
	lw	$s3, 32($sp)
	lw	$s4, 36($sp)
	addiu	$sp,$sp, 48
    	jr     $ra  

# Imprime pixels na tela
	set_pixel:
  	la    $t0, 0x10010000         				# memo
  	move  $t1, $a1				                # x
  	move  $t2, $a2				                # y
  	move  $t3, $a3				                # cor
  	
  	mul   $t4, $t1, 4			                # Multiplica x por 4
  	mul   $t5, $t2, 128			              # Multiplica y por 4 (128 para tamanho do pixel :16 -> 512/16 * 4)
  	add   $t4, $t4, $t5			              # Endereço de memória xy
  	
  	add   $t5, $t0, $t4			              # Soma o end. de memo principal com o xy
  	sw    $t3, 0($t5)			                # Salva a cor em memo xy
  	jr    $ra  
  	
ring_buffer:
	sw $zero, 0($a0)			#rbuf[size]
	sw $zero, 4($a0)			#rbuf[wr]
	sw $zero, 8($a0)			#rbuf[rd]
	jr $ra

read:
	addi $sp, $sp, -8
	sw $ra, 0($sp)

 	li $t0, 0      					#tmp = 0
 	jal rbuf_empty     				#rbuf_empty(rbuf)
  	move $t1, $v0      				#t1 = v0
 	bnez  $t1, rbuf_empty_c   		#continua - verdadeiro(1) se tiver vazio
 		move $v0, $t0    
    		lw   $t2, 0($a0)      	#t2 = size
    		subi $t2, $t2, 1    	#t2 = size--
    		sw   $t2, 0($a0)
    		
    		#tmp = rbuf->buf[rbuf->rd]
    		lw   $t1, 8($a0)      	#acesso - rbuf->rd
    		addi $t3, $a0, 12    	#endereco do buf - &rbuf->buf[0]
    		add  $t4, $t3, $t1    	#&rbuf->buf[rbuf->rd]
    		lbu  $t5, 0($t4)    	#rbuf->buf[rbuf->rd] - CHAR
    		add  $t0, $zero, $t5    #tmp = rbuf->buf[rbuf->rd]
    		#rbuf->rd = (rbuf->rd + 1) % MAX_SIZE
    		addi $t1, $t1, 1    	#rbuf->rd + 1
    		li   $t6, 16      		#MAX_SIZE
    		remu $t4, $t3, $t6    	#(rbuf->rd + 1) % MAX_SIZE
    		sw   $t4, 8($a0)      	#rbuf->rd = (rbuf->rd + 1) % MAX_SIZE
    		move $v0, $t0      		#v0 = tmp
   	rbuf_empty_c:
   	lw $ra, 0($sp)
   	addi $sp, $sp, 8
    	jr $ra
    	
rbuf_empty:
	lw   $t0, 0($a0)			#t0 = size
	beqz $t0, if_empty			#rbuf->size == 0
		li  $v0, 0				#return 0
		jr  $ra
	if_empty:
	li $v0, 1					#return 1
	jr $ra

rbuf_full:
	lw $t0, 0($a0)
	beq $t0, 16, if_full		#rbuf->size == MAX_SIZE
	li, $v0, 0					#return 0
	jr $ra
	
	if_full:
	li $v0, 1					#return 1
	jr $ra
	
write_ring:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	
  	move $t0, $a0    			#t0 = *rbuf
	move $t1, $a1    			#t1 = byte
  
  	jal rbuf_full      			#rbuf_empty(rbuf)
  	move  $t2, $v0      		#v0 = t2
  	beqz  $t2, rbuf_full_c    	#continua
 	li    $v0, 0      			# return 0
 	
	lw $ra, 0($sp)
	addi $sp, $sp, 8
  	jr    $ra
  
  		rbuf_full_c:
    		lw $t2, 0($a0)      	#t2 = size
    		addi $t2, $t2, 1    	#t2 = size++
    		sw $t2, 0($a0)      	#t2 = size
  
  
   		 #rbuf->buf[rbuf->wr] = byte
    		lw  $t2, 4($a0)      	#rbuf->wr
   		add $t3, $a0, 12     	#&rbuf->buf[0]
		sll $t2, $t2, 2    	#rbuf->wr = t2 => t2*4 - CHAR
    		add $t4, $t3, $t2    	#&rbuf->buf[rbuf->wr]
    		sb  $a1, 0($t4)      	#rbuf->wr[rbuf->wr] = byte
  
   		 #rbuf->wr = (rbuf->wr + 1) % MAX_SIZE
    		addi $t2, $t2, 1   		#rbuf->wr + 1
    		li   $t6, 16      		#MAX_SIZE
   		remu $t4, $t3, $t6		#(rbuf->wr + 1) % MAX_SIZE
   		sw   $t4, 4($a0)		#rbuf->wr = (rbuf->wr + 1) % MAX_SIZE
    		li $v0, 1     			#return 1
    		lw $ra, 0($sp)
		addi $sp, $sp, 8
    		jr $ra

.ktext 0x80000180

	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	lb $a1, 0xffff0004
	la $a0, ringbuffer			# space 32
	la $s0, write_ring
	jalr $s0

	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp,8
	li $t0, 2
	sw $zero, 0xffff0004
	sw $t0, 0xffff0000
	li $t0, 0x0000ff11
eret	
