# Resolução bitmap dysplay: 512x512
# 16 bits
.data

red_x0:   		 .word 2 
red_y0:    		 .word 7
red_x:     		 .word 7
red_y:     		 .word 23

blue_x0:   		 .word 8
blue_y0:   		 .word 25
blue_x:	   		 .word 24
blue_y:    		 .word 30

yellow_x0:  		 .word 25
yellow_y0:  		 .word 7
yellow_x:   		 .word 30
yellow_y:   		 .word 23

green_x0:   		 .word 8
green_y0:  		 .word 1
green_x:   		 .word 23
green_y:   		 .word 5

sequencia_vetor:	 .space 256

# Mensagem do menu
mensagem_inicial:	.asciiz "\tGenius\n"
n_repeticoes:		.asciiz "\nInsira o numero de repeticoes: "
dificuldade:		.asciiz "\nDificuldade\n"
facil:			.asciiz "1. Facil\n"
medio:			.asciiz "2. Madio\n"
dificil:		.asciiz "3. Dificil\n"
inicio:			.asciiz "1. Iniciar jogo\n"
fim:			.asciiz "2. Encerrar o programa\n "



.text
main:
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

  	move  $a0, $t0
  	move  $a1, $t1
  	# a0 -> n_repeticoes
  	# a1 -> dificuldade
  	jal   jogo
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
jogo:
	addiu	$sp, $sp, -32
	sw	$a0, 0($sp)
	sw	$ra, 16($sp)
	sw	$s0, 20($sp)
	sw	$s1, 24($sp)
	sw	$s2, 28($sp)
	
	move	$s0, $a0		# $a0 = numero de repetições
	li	$s1, 0
	la	$s2, sequencia_vetor
	jogo_loop:
		bgt	$s1, $s0, jogo_loop_fim
		jal	num
		
		sll	$t0, $s1, 2
		add	$t0, $t0, $s2
		sw	$v0, 0($t0)
		#tom		
		move	$a0, $s1
		jal	toca_seq
		
		li	$v0, 32
		addi	$a0, $zero, 2000
		syscall
		
		addi	$s1, $s1, 1
		#addi	$s2, $s2, 4
	j	jogo_loop
jogo_loop_fim:
	lw	$a0, 0($sp)
	lw	$ra, 16($sp)
	lw	$s0, 20($sp)
	lw	$s1, 24($sp)
	lw	$s2, 28($sp)
	addiu	$sp, $sp, 32
	jr	$ra
	
num:
	addiu	$sp,$sp,-16
	sw	$a0, 0($sp)
	sw	$a1, 4($sp)
	sw	$ra, 16($sp)
	# Soerteia Número  de 0-3
  	li	$a1, 3		# Numero maximo
  	li	$v0, 42		# Numero aleatorio
  	syscall
  	move	$v0, $a0	# Transfere numero aleatorio para return
  	
  	lw	$a0, 0($sp)
	lw	$a1, 4($sp)
	lw	$ra, 16($sp)
  	addiu	$sp,$sp, 16
	jr	$ra
toca_seq:
# $a0 -> tamanho vetor
	addiu	$sp,$sp, -32
	sw	$a0, 0($sp)
	sw	$ra, 16($sp)
	sw	$s0, 20($sp)
	sw	$s1, 24($sp)
	sw	$s2, 28($sp)
	sw	$s3, 32($sp)
	move	$s0, $a0			# $s0 = numero de elementos inseridos no vetor
	li	$s1, 0
	la	$s2, sequencia_vetor
	toca_seq_loop:
		bge	$s1, $s0, toca_seq_loop_fim
		#$s3 = sequencia_vetor[i]
		sll	$s3, $s1, 2
		add	$s3, $s3, $s2
		lw	$s3, 0($s3)	
		
		move	$a0, $s3	# $a0 = $s3
		jal	draw_rectangle
		#jal	tom
		addi	$s3, $s3, 4
		move	$a0, $s3
		jal	draw_rectangle
		addi	$s1, $s1, 1	# i++
		#addi	$s2, $s2, 4	# ++sequencia_vetor
	j	toca_seq_loop
toca_seq_loop_fim:
	lw	$a0, 0($sp)
	lw	$ra, 16($sp)
	lw	$s0, 20($sp)
	lw	$s1, 24($sp)
	lw	$s2, 28($sp)
	lw	$s3, 32($sp)
	addiu	$sp, $sp,32
	jr	$ra
tom:	
	beq	$a0, 0, tom_verde
	beq	$a0, 1, tom_vermelho
	beq	$a0, 2, tom_azul
	beq	$a0, 3, tom_amarelo
	
	tom_verde:
	li  	$v0, 31           # 
   	addi 	$a0, $zero, 72	# = pitch (0-127) 
	addi	$a1, $zero, 500	# = duration in milliseconds 
	addi	$a2, $zero, 5	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
    	syscall
	j	tom_next
	tom_vermelho:
	li  	$v0, 31           
   	addi 	$a0, $zero, 62	# = pitch (0-127) 
	addi	$a1, $zero, 500	# = duration in milliseconds 
	addi	$a2, $zero, 5	# = instrument (0-127) 
	addi	$a3, $zero, 90	# = volume (0-127)
    	syscall
	j	tom_next
	tom_azul:
	li  	$v0, 31           # service 1 is print integer
   	addi 	$a0, $zero, 64	# = pitch (0-127) 
	addi	$a1, $zero, 500	# = duration in milliseconds 
	addi	$a2, $zero, 7	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
    	syscall
	j	tom_next
	tom_amarelo:
	li  	$v0, 31           # service 1 is print integer
   	addi 	$a0, $zero, 65	# = pitch (0-127) 
	addi	$a1, $zero, 500	# = duration in milliseconds 
	addi	$a2, $zero, 7	# = instrument (0-127) 
	addi	$a3, $zero, 100	# = volume (0-127)
    	syscall
	j	tom_next
	
	tom_next:
	li	$v0, 32
	addi	$a0, $zero, 500
	syscall
	
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
  	lw     $s0, blue_x0    
  	lw     $s1, blue_x     
  	lw     $s2, blue_y0    
  	lw     $s3, blue_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x5164ff                # cor
  	j	 next
	yellow_off:
  	lw     $s0, yellow_x0    
  	lw     $s1, yellow_x     
  	lw     $s2, yellow_y0    
  	lw     $s3, yellow_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xffff69 
  	j	 next
	red_off:
  	lw     $s0, red_x0    
  	lw     $s1, red_x     
  	lw     $s2, red_y0    
  	lw     $s3, red_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xff5c51                # cor
  	j      next        # jump to next
  
	green_off:
	lw     $s0, green_x0    
  	lw     $s1, green_x     
  	lw     $s2, green_y0    
  	lw     $s3, green_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x5cff51                # cor
  	j      next                           # jump to next
	
	green:
  	lw     $s0, green_x0    
  	lw     $s1, green_x     
  	lw     $s2, green_y0    
  	lw     $s3, green_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x11d604                # cor
  	j      next
  	
	blue:
  	lw     $s0, blue_x0    
  	lw     $s1, blue_x     
  	lw     $s2, blue_y0    
  	lw     $s3, blue_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0x041bd6                # cor
  	j	 next
	yellow:
  	lw     $s0, yellow_x0    
  	lw     $s1, yellow_x     
  	lw     $s2, yellow_y0    
  	lw     $s3, yellow_y 
  	move   $s4, $s0                       # $s4 = x0
  	li     $a3, 0xd6d618 
  	j	 next
	red:
  	lw     $s0, red_x0    
  	lw     $s1, red_x     
  	lw     $s2, red_y0    
  	lw     $s3, red_y 
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


