/* Versao imperativa de aplicarTodas, com vetor de ponteiros para funcao. */
#include <stdio.h>

/* Em C nao ha lambda: cada desconto precisa ser uma funcao nomeada, escrita
   antes de compilar. Nao da para ter um criarDesconto(30) que fabrique uma
   funcao nova durante a execucao. */
double black_friday(double preco) { return preco * 0.70; }
double cupom_10(double preco) { return preco - 10.0; }
double desconto_10(double preco) { return preco * 0.90; }

/* Equivalente a aplicarTodas em Haskell. Aqui 'resultado' MUDA a cada volta;
   la a recursao passa um valor novo, sem nenhuma variavel mutavel. */
double aplicar_todas(double (*promocoes[])(double), int quantidade, double preco) {
    double resultado = preco;
    for (int i = 0; i < quantidade; i++) {
        resultado = promocoes[i](resultado);
    }
    return resultado;
}

int main(void) {
    double (*ordem_a[])(double) = { black_friday, cupom_10, desconto_10 };
    double (*ordem_b[])(double) = { cupom_10, black_friday, desconto_10 };

    printf("Preco original: %.2f\n", 200.0);
    printf("Black Friday, cupom 10, desconto 10%%: %.2f\n", aplicar_todas(ordem_a, 3, 200.0));
    printf("Cupom 10, Black Friday, desconto 10%%: %.2f\n", aplicar_todas(ordem_b, 3, 200.0));
    printf("Lista vazia: %.2f\n", aplicar_todas(ordem_a, 0, 200.0));
    return 0;
}
