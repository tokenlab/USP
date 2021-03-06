#Quick Sort
#Nome: Eduardo Sigrist Ciciliato nUSP: 7986542
#Nome: Hiero Martinelli nUSP: 7986646
#Nome: Daniele Hidalgo Boscolo  nUSP: 7986625

#
# Release Notes
#
# Version 0.2
#
# Changes:
# 	- Função de Particionar vetores finalizada (precisa testar com o codigo completo, mas nenhum erro de sintaxe)
# 	- $t1, $t4 e $t5 foram trocados por $s0, $s1, $s2 para liberar o numero de Registradores que podem ser usados
# 	- Adicionado a string para pular linha
#
# Atençao:
#	- Futuramente remover os comentários que dizem "equivalente a" por uma explicaçao melhor do que acontece
#


			.data
			.align 0
str_quant:	.asciiz "Digite a quantidade de numeros: "
str_num:	.asciiz "Digite os numeros: "
str_comma:	.asciiz ", "
str_ord:	.asciiz "Vetor ordenado: "
str_ori:	.asciiz "Vetor original: "
str_exit:	.asciiz "Programa finalizado com sucesso!"
str_error:	.asciiz "Erro: Quantidade de numeros excedeu o limite maximo de 15!"
str_nline:	.asciiz "\n"

#$t0 = temporario para operacoes aritmeticas e condicionais
#$t2 = N bytes para alocar / Posicao na memoria que sera pulada para carregamento dos valores no vetor
#$t3 = i
#$s0 = N | Mudou de $t1
#$s1 = Posicao inicial do vetor original | Mudou de $t4
#$s2 = Posicao inicial do vetor ordenado | Mudou de $t5

			.text
			.align 2
			.globl main
		
main:

			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_quant 
			syscall
			
			li $v0, 5 #atribui 5 para $v0. Codigo para ler inteiro
			syscall

			move $s0, $v0 
			li $t0, 15
			ble $s0, $zero, exit #Se digitar 0 ou menos numeros sai do programa
			bgt $s0, $t0, error #Se digitar mais do que 15 numeros sai do programa
			
			li $t0, 4 #atribui 4 a $t2. Pois como um inteiro possui 4 bytes nós precisamos alocar 4 bytes para cada numero inteiro
			mul $t2, $s0, $t0
			
			li $v0, 9 #atribui 9 para $v0. Codigo para alocação dinamica
			move $a0, $t2 #aloca N * 4 bytes para o vetor original
			syscall
			
			move $s1, $v0 #move posicao inicial do novo vetor para $s1 (vetor original)
			
			li $v0, 9 #atribui 9 para $v0. Codigo para alocação dinamica
			move $a0, $t2 #aloca N * 4 bytes para o vetor ordenado
			syscall
			
			move $s2, $v0 #move posicao inicial do novo vetor para $s2 (vetor ordenado)
			
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_num 
			syscall
			
			#Comeca o for para pegar todos os numeros
			li $t3, 0 #inicializa i com 0
			move $t0, $s1 #carrega o endereco do inicial do vetor original para $t0
			
loop_scan:	li $v0, 5 #atribui 5 para $v0. Codigo para ler inteiro
			syscall
			sw $v0, 0($t0)
			addi $t3, $t3, 1
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao
			bne $s0, $t3, loop_scan
			
			
			#Comeca o for para mostrar os valores do vetor original
			li $t3, 0 #inicializa i com 0
			move $t0, $s1 #carrega o endereco do inicial do vetor original para $t0
			
loop_print: lw $a0, 0($t0)
			li $v0, 1
			syscall
			addi $t3, $t3, 1
			addi $t0, $t0, 4 #soma 4 em $t0 para poder acessar 4 bytes para frente na memoria na proxima iteracao

			#imprime virgula entre os valores (", ")
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_comma
			syscall

			bne $t3, $s0, loop_print

exit:

			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_exit
			syscall

			li $v0, 10
			syscall


error:
			
			li $v0, 4 #atribui 4 para $v0. Codigo para imprimir string
			la $a0, str_error
			syscall
			j exit		
		

# Funçao de Ordenaçao recursiva decrescente utilizando o algoritmo quicksort
#
# Parametros:
#	- $a0 = Vetor a ser ordenado
#	- $a1 = posicao a esquerda (geralmente 0)
#	- $a2 = posicao a direita (geralmente o tamanho do vetor - 1)
#
# Retorno:
#	vetor $a0 ordenado
#
quicksort:

# Funçao para particionar vetor
#
# Parametros:
#	- $a0 = Vetor a ser particionado (v[])
#	- $a1 = posicao esquerda (esq/baixo) (multiplicado pelo numero de bytes que eh 4)
#	- $a2 = posicao direita (dir/cima) (multiplicado pelo numero de bytes que eh 4)
#
# Retorno:
#	- $v0 = posicao particionada
#
# Registradores Utilizados:
#	- $t4 = utilizado no loop para andar no vetor em que os valores estão sendo verificados
#	- $t5 = utilizado no loop para verificar os valores dentro do vetor
#	- $t6 = a
#	- $t7 = baixo
#	- $t8 = cima
#	- $t9 = usado para manipular a posicao no vetor sem perder o inicio
#
vect_part:
			move $t9, $a0 #coloca a posicao inicial do vetor v[] em $t9
			add $t9, $t9, $a1 #adiciona a posicao esquerda ao inicio do vetor para acessar a posicao esquerda
			lw 	$t6, 0($t9) # carrega v[esq] em a
			move $t7, $a1 #equivalente a baixo = esq
			move $t8, $a2 #equivalente a cima = dir

loop_part:	blt $t7, $t8, exit_loop_part #while(baixo < cima)

loop_part_low: move $t4, $a0 #while( v[baixo] >= a && baixo < dir )
			add $t4, $t4, $t7
			lw $t5, 0($t4)
			bge $t5, $t6, loop_part_high #equivalente a v[baixo] >= a
			blt $t7, $a1, loop_part_high #equivalente a baixo < dir
			addi $t7, $t7, 4
			j loop_part_low

loop_part_high:move $t4, $a0 #while( v[cima] < a )
			add $t4, $t4, $t8
			lw $t5, 0($t4)
			blt $t5, $t6, swap_condition #equivalente a v[cima] < a
			addi $t8, $t8, -4
			j loop_part_high

swap_condition: blt $t8, $t7, no_swap #if( baixo < cima )
			addi $sp, $sp, -16 #Empilha as variaveis e o $ra
			sw $ra, 0($sp)
			sw $a0, 4($sp)
			sw $a1, 8($sp)
			sw $a2, 12($sp)

			move $a0, $t7
			move $a1, $t8
			jal swap #chama a funcao swap com a posicao na memoria da variavel cima e baixo
			
			lw $ra, 0($sp) #Desempilha as variaveis e o $ra
			lw $a0, 4($sp)
			lw $a1, 8($sp)
			lw $a2, 12($sp)

no_swap:	j loop_part

exit_loop_part:	move $t4, $a0
			add $t4, $t4, $t8
			lw $t5, 0($t4)
			sw $t5, 0($a1) #equivalente a v[esq] = v[cima]
			sw $t6, 0($t8) #equivalente a v[cima] = a
			move $v0, $t8 #return cima
			jr $ra

			


# Funçao para troca de valores na memoria
#
# Parametros:
#	- $a0 = posicao na memoria A
#	- $a1 = posicao na memoria B
#
# Retorno:
#	Os valores na memoria serão trocados entre A e B
swap:
			move $t0, $a0 #Aux = a0
			move $a0, $a1 #a0 = a1
			move $a1, $t0 #a1 = Aux