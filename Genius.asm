# Resolução bitmap dysplay: 512x512
# 8 bits
.data
green_x0:   .word 12
green_y0:   .word 1
green_x:    .word 52
green_y:    .word 11

red_x0:     .word 1 
red_y0:     .word 12
red_x:      .word 11
red_y:      .word 52

blue_x0:    .word 12
blue_y0:    .word 53
blue_x:	    .word 52
blue_y:     .word 62

yellow_x0:  		.word 53
yellow_y0:  		.word 12
yellow_x:   		.word 63
yellow_y:   		.word 52

sequencia_vetor:	.space 400	# vetor para 100 palavras

# Mensagem do menu
mensagem_inicial:	.asciiz "\tGenius\n"
n_repeticoes:		.asciiz "Insira o número de repetições: "
dificuldade:		.asciiz "\nDificuldade\n"
facil:			.asciiz "1. Fácil\n"
medio:			.asciiz "2. Médio\n"
dificil:		.asciiz "3. Difícil\n"
inicio:			.asciiz "1. Iniciar jogo\n"
fim:			.asciiz "2. Encerrar o programa\n "

.text
.globl main
## --------------- FUNÇÃO MAIN ------------------------------- ##
main:
  jal   init_display         # jump to init_display and save position to $ra
  jal	menu
  li	$v0, 10
  syscall
init_display:
  addiu	$sp, $sp, -16
  sw	$ra, 16($sp)
  li    $a0, 4    		#$a0 =0 - verde 
  jal   draw_rectangle        	# jump to draw_rectangle and save position to $ra
  li	$a0, 5			# vermelho
  jal   draw_rectangle
  li    $a0, 6			# azul
  jal   draw_rectangle
  li    $a0, 7			#  amarelo
  jal   draw_rectangle
  lw	$ra, 16($sp)
  jr	$ra                   # jump to $ra
## --------------- FIM FUNÇÃO MAIN ------------------------------- ##


## --------------- FUNÇÃO DO MENU ------------------------------- ##
menu:
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
  jal   game
end_game:
  jr     $ra
## --------------- FIM DA FUNÇÃO MENU ------------------------------- ##

## --------------- FUNÇÃO PRINCIPAL DO JOGO ----------------------------- ##
game:
  # a0 -> Numero de repetições
  # a1 -> Dificuldade
  addiu  $sp, $sp, -24
  sw     $a0, 0($sp)     
  sw     $a1, 4($sp)    
  sw     $ra, 16($s1)    
 # sorteira Numero
  jal    sequencia        	# jump to sequencia and save position to $ra
  move   $a0, $v0    		# $a0 = numero sorteado 
  # toca Numero
  # entrada do usuario
  # comparação
 game_loop_end:
  lw    $a0, 0($sp)     
  lw    $a1, 4($sp)     
  lw    $ra, 16($sp)    
  
  addiu $sp, $sp, 24
  jr    $ra          
  
## -- Função que gera um número aleatório
sequencia:
  # Soerteia Número  de 0-3
  li	$a1, 3		# Numero maximo
  li	$v0, 42		# Numero aleatorio
  syscall
  move	$v0, $a0	# Transfere numero aleatorio para return
  jr	$ra
## --------------- FIM FUNÇÃO PRINCIPAL DO JOGO ----------------------------- ##

draw_rectangle:
  move   $t6, $a0 
  move	 $t7, $ra
  beq    $a0, 0, green  # if $a0 =0 then green
  beq    $a0, 1, red
  beq    $a0, 2, blue
  beq    $a0, 3, yellow
  
  beq    $a0, 4, green_off  # if $a0 =0 then green
  beq    $a0, 5, red_off
  beq    $a0, 6, blue_off
  beq    $a0, 7, yellow_off
# Display "ligado"
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
  
green:
  lw     $s0, green_x0    
  lw     $s1, green_x     
  lw     $s2, green_y0    
  lw     $s3, green_y 
  move   $s4, $s0                       # $s4 = x0
  li     $a3, 0x11d604                # cor
  j      next                           # jump to next
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
    move   $a0, $t6
    move   $ra, $t7
    li	   $a1, 0
    li     $a2, 0
    li     $a3, 0
    jr     $ra  
  
set_pixel:
  la    $t0, 0x10010000         				# memo
  move  $t1, $a1				                # x
  move  $t2, $a2				                # y
  move  $t3, $a3				                # cor
  	
  mul   $t4, $t1, 4			                # Multiplica x por 4
  mul   $t5, $t2, 256			              # Multiplica y por 4 (128 para tamanho do pixel :16 -> 512/16 * 4)
  add   $t4, $t4, $t5			              # Endereço de memória xy
  	
  add   $t5, $t0, $t4			              # Soma o end. de memo principal com o xy
  sw    $t3, 0($t5)			                # Salva a cor em memo xy
  jr    $ra                             # jump to $ra
  

