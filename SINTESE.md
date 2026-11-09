# SÍNTESE DAS DESCOBERTAS

**Tema:** 13 – Funções de ordem superior em um motor de promoções
**Equipe:** Joaocelo
**Integrantes:** Marcelo Bresani Victor de Oliveira, João Cláudio Beltrão

## 1. O conceito em poucas palavras

Em Haskell, uma função é um valor como um número ou um texto: pode ser passada como argumento, devolvida como resultado e guardada em uma lista. Uma função de ordem superior é aquela que recebe ou devolve outra função. O parêntese na assinatura mostra isso: em `(a -> a) -> a -> a`, o primeiro argumento é uma função.

No motor de promoções, cada desconto é uma função `Double -> Double`. O cálculo não precisa saber quais regras existem: basta receber uma lista delas. Assim, uma promoção nova é só uma função nova, e o código que aplica as promoções não muda.

## 2. Resposta ao desafio investigativo

Os comandos e as saídas completas estão em `desafio.md`.

### 2.1 Por que o GHCi não exibe uma função?

```
ghci> criarDesconto 10
error: [GHC-39999] • No instance for ‘Show (Double -> Double)’
ghci> :t criarDesconto 10
criarDesconto 10 :: Double -> Double
ghci> (criarDesconto 10) 100
90.0
```

**Conclusão:** a expressão é válida e o `:t` mostra seu tipo. O erro ocorre só ao imprimir, porque o GHCi usa `print`, que exige a classe `Show`, e funções não têm instância dessa classe. Uma função é uma regra de cálculo e não tem um texto único que a represente.

### 2.2 A ordem dos descontos altera o preço final?

```
ghci> aplicarTodas [criarDesconto 10, subtract 20] 100
70.0
ghci> aplicarTodas [subtract 20, criarDesconto 10] 100
72.0
ghci> aplicarTodas [criarDesconto 10, criarDesconto 20] 100
72.0
ghci> aplicarTodas [criarDesconto 20, criarDesconto 10] 100
72.0
```

**Conclusão:** com dois percentuais a ordem não importa, porque `a · (b · x) = b · (a · x)`. Com percentual e valor fixo ela importa: percentual primeiro dá `a · x - c`, e valor fixo primeiro dá `a · x - a · c`. A diferença é `c · p/100`, que vale 2 no exemplo para qualquer preço (70 e 72, 25 e 27, 880 e 882).

### 2.3 Recurso equivalente em outra linguagem

```
> .\comparacao.exe
Black Friday, cupom 10, desconto 10%: 117.00
Cupom 10, Black Friday, desconto 10%: 119.70
```

**Conclusão:** o recurso equivalente em C é o ponteiro para função, usado em um vetor `double (*promocoes[])(double)`. Ele só aponta para funções escritas antes da compilação, enquanto `criarDesconto 30` cria uma função nova durante a execução.

## 3. Principais descobertas

1. **Uma função pode fabricar outras.** `:t criarDesconto 10` responde `Double -> Double`, ou seja, o resultado de aplicar um argumento é outra função.
2. **O polimorfismo vale para a função recebida.** `aplicarDuasVezes (*2) 5` dá `20` e `aplicarDuasVezes (++ "!") "oi"` dá `"oi!!"`, com a mesma definição.
3. **Encadear e comparar são coisas diferentes.** `aplicarTodas [criarDesconto 10, subtract 5] 100` passa o resultado adiante e dá `85.0`. Já `melhorOpcao [criarDesconto 15, subtract 10] 80` aplica cada promoção ao preço original e dá `68.0`.
4. **Casos limite exigem decisão.** `aplicarNVezes (-1) (*2) 7` dá `7`, porque tratamos `n` negativo como 0 vezes para a recursão sempre terminar. `melhorOpcao [] 100` dá `100.0`, porque `minimum` falharia em lista vazia.
5. **`Double` não é exato.** `criarDesconto (-10) 100` dá `110.00000000000001`, porque `1.1` não tem representação exata em binário.

## 4. Comparação com a abordagem imperativa

| Aspecto | C (`comparacao.c`) | Haskell (`Aplicacao.hs`) |
|---|---|---|
| Tipo da função | `double (*f)(double)` | `Double -> Double` |
| Criar função nova durante a execução | não é possível no C padrão | `criarDesconto 30` |
| Repetição | `for` com variável que muda | recursão, sem variável mutável |
| Polimorfismo | um tipo fixo por função | `a -> a` serve para qualquer tipo |

O ponteiro para função já permite separar o cálculo das regras, mas cada regra precisa ser escrita à mão. Em Haskell, a mesma ideia fica mais curta e as regras podem ser criadas a partir de parâmetros. Em troca, o laço do C mostra de forma direta o passo a passo, o que pode ser mais fácil para quem vem do imperativo.

## 5. Dificuldades e limitações

**Dificuldades**

- Ler os parênteses: `(a -> a) -> a -> a` recebe uma função, enquanto `a -> a -> a -> a` recebe três valores.
- Garantir a ordem em `aplicarTodas`: aplicar `f` antes da chamada recursiva dá 30 no exemplo do professor. Na ordem invertida daria 21.
- Ambiente no Windows: o GHC 9.10.3 instalado pelo GHCup não trouxe o comando `gcc`. Resolvemos compilando o C com `ghc -no-hs-main comparacao.c -o comparacao.exe`.
- A compilação com `-Wall` não gerou avisos nos dois arquivos `.hs`.

**Limitações**

- Funções não podem ser impressas nem comparadas diretamente, o que dificulta depurar uma lista de promoções.
- `Double` pode gerar erros de arredondamento em valores monetários.
- `criarDesconto` não valida o percentual: valores negativos viram acréscimo e valores acima de 100 geram preço negativo.
- Assinaturas com muitas funções ficam difíceis de ler, e nesses casos uma função nomeada costuma ser melhor que uma lambda.

## 6. Quadro de contribuições

| Integrante | Funções implementadas | Pesquisa | Parte da apresentação |
|---|---|---|---|
| Marcelo Bresani Victor de Oliveira | aplicarDuasVezes, aplicarNVezes, criarDesconto, cupomMinimo (extensão), Exemplo1 | Pergunta 1 do desafio | Introdução, investigação técnica, Exemplo1 |
| João Cláudio Beltrão | aplicarTodas, melhorOpcao, main, comparacao.c | Perguntas 2 e 3 do desafio | Descoberta da ordem, aplicação, C × Haskell, interação |

**Uso de ferramenta de IA:** a primeira versão do código e dos textos deste repositório foi gerada com o Claude (Anthropic). Cada integrante é responsável por revisar, executar e explicar as partes indicadas no quadro.

## 7. Referências

ANTHROPIC. **Claude**: modelo Claude Opus 5.5, usado por meio do Claude Code. 2026. Ferramenta de IA usada para gerar a versão inicial do código e dos textos. Disponível em: https://claude.com/claude-code. Acesso em: 9 nov. 2026.

HASKELL.ORG. **Documentation**. Disponível em: https://www.haskell.org/documentation/. Acesso em: 9 nov. 2026.

HASKELL. **Documentação do módulo Prelude**. Disponível em: https://hackage.haskell.org/package/base/docs/Prelude.html. Acesso em: 9 nov. 2026.

LIPOVAČA, M. **Learn You a Haskell for Great Good!** San Francisco: No Starch Press, 2011. Capítulo “Higher order functions”. Disponível em: http://learnyouahaskell.com/. Acesso em: 9 nov. 2026.

MACIEL, R. **Seminário Técnico: Programação Funcional com Haskell**. Documento da disciplina Programação Imperativa e Funcional. Recife: CESAR School, 2026.
