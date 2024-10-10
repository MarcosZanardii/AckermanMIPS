.data
    prompt_m:  .asciiz "Digite o parâmetro m para calcular A(m, n) ou -1 para abortar a execução: "
    prompt_n:  .asciiz "Digite o parâmetro n para calcular A(m, n) ou -1 para abortar a execução: "
    result_prompt:  .asciiz "A(m, n) = "
    newline:        .asciiz "\n"
    intro_msg:      .asciiz "Programa Ackermann - Data: 04/10/2024\n"
    authors:        .asciiz "Autores: Luige Lima e Marcos Zanardi\n"

.text
    .globl main

main:
    # Exibe a mensagem inicial com a data e autores
    li $v0, 4
    la $a0, intro_msg
    syscall

    li $v0, 4
    la $a0, authors
    syscall

loop:
    # Exibe a mensagem para entrada dos parâmetros
    li $v0, 4
    la $a0, prompt_m
    syscall

    # Lê o valor de m
    li $v0, 5       # Lê o valor do usuário
    syscall
    bltz $v0, exit_program  # Se m < 0, sai do programa
    move $t0, $v0   # Salva m em $t0

    # Exibe a mensagem para entrada dos parâmetros
    li $v0, 4
    la $a0, prompt_n
    syscall

    # Lê o valor de n
    li $v0, 5       # Lê o valor do usuário
    syscall
    bltz $v0, exit_program  # Se n < 0, sai do programa
    move $t1, $v0   # Salva n em $t1

    # Chama a função Ackermann com os parâmetros m e n
    jal ackermann   # Chama a função ackermann

    # Exibe o resultado
    li $v0, 4
    la $a0, result_prompt
    syscall

    li $v0, 1        # Imprimir número
    move $a0, $t3    # Move o resultado de volta para $a0
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    j loop  # Volta ao início do loop

# Função Ackermann recursiva
ackermann:
    addi $sp, $sp, -12   # Aloca espaço na pilha para $ra, $t0 e $t1
    sw $ra, 8($sp)       # Salva $ra
    sw $t0, 4($sp)       # Salva $t0
    sw $t1, 0($sp)       # Salva $t1 (n original)

    # Base da recursão: se m == 0
    beq $t0, $zero, base_case
    # Se m > 0 e n == 0
    beq $t1, $zero, recursive_case1
    # Se m > 0 e n > 0
    j recursive_case2

base_case:
    addi $t3, $t1, 1      # A(m, n) = n + 1
    lw $ra, 8($sp)        # Recupera $ra
    lw $t0, 4($sp)        # Recupera $t0
    lw $t1, 0($sp)        # Recupera $t1 (n original)
    addi $sp, $sp, 12     # Desaloca a pilha
    jr $ra

recursive_case1:
    addi $t0, $t0, -1     # m = m - 1
    li $t1, 1             # n = 1
    jal ackermann         # Chama recursivamente
    move $t3, $t3         # Armazena o resultado em $t3 (mantém o valor)
    lw $ra, 8($sp)        # Recupera $ra
    lw $t0, 4($sp)        # Recupera $t0
    lw $t1, 0($sp)        # Recupera $t1 (n original)
    addi $sp, $sp, 12     # Desaloca a pilha
    jr $ra

recursive_case2:
    addi $t1, $t1, -1     # n = n - 1 (valor temporário)
    jal ackermann         # Chama recursivamente A(m, n-1)
    move $t2, $t3         # Salva o resultado temporário em $t2

    lw $t1, 0($sp)        # Restaura n original antes da próxima chamada
    addi $t0, $t0, -1     # m = m - 1
    move $t1, $t2         # Usa o valor de A(m, n-1)
    jal ackermann         # Chama recursivamente A(m-1, A(m, n-1))

    move $t3, $t3         # Armazena o resultado final em $t3
    lw $ra, 8($sp)        # Recupera $ra
    lw $t0, 4($sp)        # Recupera $t0
    lw $t1, 0($sp)        # Recupera $t1 (n original)
    addi $sp, $sp, 12     # Desaloca a pilha
    jr $ra

exit_program:
    li $v0, 10  # Encerra o programa
    syscall
