O objetivo deste trabalho é implementar a função Ackermann em Assembly. A função é definida como:

A(m, n) =
    n + 1,                se m = 0
    A(m - 1, 1),          se m > 0 e n = 0
    A(m - 1, A(m, n - 1)), se m > 0 e n > 0
    
A função Ackermann cresce rapidamente e serve como um ótimo desafio para a manipulação de recursão em Assembly.

Arquivos

Como Usar
Clone este repositório.
Abra os arquivos no simulador MARS (MIPS Assembler and Runtime Simulator).
Execute o arquivo ackermann.asm no MARS para ver os resultados da função Ackermann.
Ferramentas Utilizadas
Assembly (MIPS)
Simulador MARS: Utilizado para rodar e testar o código Assembly.
