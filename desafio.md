# Desafio investigativo – Tema 13

Saídas copiadas da execução real no GHC 9.10.3 (Windows), com `Aplicacao.hs` carregado no GHCi.

## Pergunta 1 – Por que o GHCi não exibe uma função?

**Comandos e saídas**

```
ghci> criarDesconto 10

<interactive>:1:1: error: [GHC-39999]
    • No instance for ‘Show (Double -> Double)’
        arising from a use of ‘print’
        (maybe you haven't applied a function to enough arguments?)
    • In a stmt of an interactive GHCi command: print it

ghci> :t criarDesconto 10
criarDesconto 10 :: Double -> Double

ghci> (criarDesconto 10) 100
90.0

ghci> :i Show
type Show :: * -> Constraint
class Show a where
  showsPrec :: Int -> a -> ShowS
  show :: a -> String
  showList :: [a] -> ShowS
  {-# MINIMAL showsPrec | show #-}
instance Show Double -- Defined in ‘GHC.Internal.Float’
instance Show Bool -- Defined in ‘GHC.Internal.Show’
instance Show Char -- Defined in ‘GHC.Internal.Show’
instance Show Int -- Defined in ‘GHC.Internal.Show’
instance Show a => Show [a] -- Defined in ‘GHC.Internal.Show’
[... lista cortada aqui; nenhuma das instâncias listadas é para funções ...]
```

**Explicação**

Depois de calcular uma expressão, o GHCi tenta imprimir o resultado com `print`, e `print` só aceita tipos da classe `Show`, que são os que sabem virar texto. O resultado de `criarDesconto 10` é válido, e o `:t` confirma que é uma função `Double -> Double`. O erro acontece só na hora de mostrar, porque não existe instância `Show (Double -> Double)`.

Faz sentido não existir: uma função é uma regra de cálculo, não um dado com representação em texto. Duas funções podem ter códigos diferentes e dar sempre o mesmo resultado, então não há um texto único que represente cada uma. Quando entregamos o preço que faltava, `(criarDesconto 10) 100`, o resultado é um `Double` e aparece normalmente.

## Pergunta 2 – A ordem dos descontos altera o preço final?

**Percentual e valor fixo: a ordem importa**

```
ghci> aplicarTodas [criarDesconto 10, subtract 20] 100
70.0
ghci> aplicarTodas [subtract 20, criarDesconto 10] 100
72.0
ghci> aplicarTodas [criarDesconto 10, subtract 20] 50
25.0
ghci> aplicarTodas [subtract 20, criarDesconto 10] 50
27.0
ghci> aplicarTodas [criarDesconto 10, subtract 20] 1000
880.0
ghci> aplicarTodas [subtract 20, criarDesconto 10] 1000
882.0
```

**Dois percentuais: a ordem não importa**

```
ghci> aplicarTodas [criarDesconto 10, criarDesconto 20] 100
72.0
ghci> aplicarTodas [criarDesconto 20, criarDesconto 10] 100
72.0
ghci> aplicarTodas [criarDesconto 10, criarDesconto 20] 50
36.0
ghci> aplicarTodas [criarDesconto 20, criarDesconto 10] 50
36.0
ghci> aplicarTodas [criarDesconto 10, criarDesconto 20] 1000
720.0
ghci> aplicarTodas [criarDesconto 20, criarDesconto 10] 1000
720.0
```

**Explicação matemática**

Um desconto percentual é uma multiplicação: `D(x) = a · x`, com `a = 1 - p/100`. Um desconto fixo é uma subtração: `F(x) = x - c`.

Dois percentuais podem trocar de ordem porque a multiplicação é comutativa: `a · (b · x) = b · (a · x) = a · b · x`.

Com percentual e valor fixo, as duas ordens dão contas diferentes:

- Percentual primeiro: `F(D(x)) = a · x - c`
- Valor fixo primeiro: `D(F(x)) = a · (x - c) = a · x - a · c`

A diferença entre elas é `c - a · c = c · (1 - a) = c · p/100`. Com `p = 10` e `c = 20`, a diferença é `2`, qualquer que seja o preço. É exatamente o que aparece nas saídas: 70 e 72, 25 e 27, 880 e 882. O percentual primeiro sai mais barato porque, na outra ordem, o desconto fixo também é reduzido pelo percentual.

**Ponto flutuante**

Nestes testes os valores saíram exatos, mas o problema aparece em outra conta:

```
ghci> criarDesconto (-10) 100
110.00000000000001
```

`1.1` não tem representação exata em binário no tipo `Double`, então a conta guarda um valor muito próximo. Sistemas financeiros costumam evitar isso guardando valores em centavos inteiros.

## Pergunta 3 – Recurso equivalente em outra linguagem

O C tem ponteiro para função. Em `comparacao.c`, o vetor `double (*promocoes[])(double)` guarda funções, e `aplicar_todas` chama cada uma dentro de um laço `for`.

**Comando e saída**

```
> ghc -no-hs-main comparacao.c -o comparacao.exe
> .\comparacao.exe
Preco original: 200.00
Black Friday, cupom 10, desconto 10%: 117.00
Cupom 10, Black Friday, desconto 10%: 119.70
Lista vazia: 200.00
```

**O que o C não consegue fazer igual**

No C, um ponteiro aponta para uma função que já existia quando o programa foi compilado. Por isso cada desconto (`black_friday`, `cupom_10`, `desconto_10`) foi escrito à mão, com o percentual fixo no código.

Em Haskell, `criarDesconto 30` cria durante a execução uma função nova que guarda o valor `30`. O C padrão não tem lambda nem esse tipo de função que carrega um valor consigo. O mais próximo seria passar o percentual como um parâmetro extra em toda chamada.

## Testes: aplicarDuasVezes, aplicarNVezes, criarDesconto e cupomMinimo

Todos conferidos no GHCi. A decisão para `n` negativo foi tratar como 0 vezes.

| Chamada | Saída |
|---|---|
| `aplicarDuasVezes (*2) 5` | `20` |
| `aplicarDuasVezes (+3) 0` | `6` |
| `aplicarDuasVezes (++ "!") "oi"` | `"oi!!"` |
| `aplicarDuasVezes not True` | `True` |
| `aplicarNVezes 3 (++ "!") "oi"` | `"oi!!!"` |
| `aplicarNVezes 0 (*2) 7` | `7` |
| `aplicarNVezes 1 (*2) 7` | `14` |
| `aplicarNVezes 10 (*2) 1` | `1024` |
| `aplicarNVezes (-1) (*2) 7` | `7` |
| `criarDesconto 10 100` | `90.0` |
| `criarDesconto 0 50` | `50.0` |
| `criarDesconto 100 50` | `0.0` |
| `criarDesconto 25 80` | `60.0` |
| `:t criarDesconto 10` | `criarDesconto 10 :: Double -> Double` |
| `criarDesconto (-10) 100` | `110.00000000000001` (percentual negativo vira acréscimo) |
| `criarDesconto 150 100` | `-50.0` (acima de 100%, o preço fica negativo) |
| `cupomMinimo 100 20 150` | `120.0` |
| `cupomMinimo 100 20 50` | `50.0` |
| `cupomMinimo 100 20 100` | `100.0` (igual ao limite, sem desconto) |

## Testes: aplicarTodas e melhorOpcao

| Chamada | Saída |
|---|---|
| `aplicarTodas [(+1), (*10)] 2` | `30` |
| `aplicarTodas [(*10), (+1)] 2` | `21` |
| `aplicarTodas [] 5` | `5` |
| `aplicarTodas [(++ "a"), (++ "b")] ""` | `"ab"` |
| `aplicarTodas [criarDesconto 10, subtract 5] 100` | `85.0` |
| `melhorOpcao [criarDesconto 15, subtract 10] 80` | `68.0` |
| `melhorOpcao [criarDesconto 15, subtract 10] 50` | `40.0` |
| `melhorOpcao [criarDesconto 10] 100` | `90.0` |
| `melhorOpcao [] 100` | `100.0` (lista vazia devolve o preço cheio) |
| `melhorOpcao [criarDesconto 50, subtract 50] 100` | `50.0` (empate) |
| `melhorOpcao [cupomMinimo 100 20, subtract 10] 150` | `120.0` |
