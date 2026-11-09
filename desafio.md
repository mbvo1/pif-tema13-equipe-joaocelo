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
