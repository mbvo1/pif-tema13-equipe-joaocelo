-- Tema 13 - Funcoes de ordem superior em um motor de promocoes
-- PIF - CESAR School - 2026.2
--
-- Uma promocao e so uma funcao Double -> Double: recebe um preco e devolve
-- o preco novo. Por isso regras novas entram no motor sem mudar o calculo.

-- ==== aplicarDuasVezes ====

-- Os parenteses em (a -> a) dizem que o primeiro argumento e uma funcao.
-- Como 'a' e uma variavel de tipo, serve para Int, String, Bool etc.
aplicarDuasVezes :: (a -> a) -> a -> a
aplicarDuasVezes f x = f (f x)

-- ==== aplicarNVezes ====

-- Decisao para n negativo: tratamos como 0 vezes e devolvemos o valor intacto.
-- Com o caso base (n == 0) a recursao nunca terminaria para n < 0, entao
-- usamos n <= 0. Nao existe "aplicar -1 vezes", e o programa nao deve travar.
aplicarNVezes :: Int -> (a -> a) -> a -> a
aplicarNVezes n f x
  | n <= 0    = x
  | otherwise = aplicarNVezes (n - 1) f (f x)

-- ==== criarDesconto ====

-- Devolve uma funcao: o percentual fica guardado dentro da lambda.
-- criarDesconto 10 100 funciona porque (criarDesconto 10) devolve uma funcao,
-- e essa funcao e aplicada a 100.
-- Nao validamos o percentual: negativo vira acrescimo e acima de 100 gera
-- preco negativo. Discutimos essa limitacao na analise critica.
criarDesconto :: Double -> (Double -> Double)
criarDesconto p = \preco -> preco * (1 - p / 100)

-- ==== aplicarTodas ====

-- Encadeia as funcoes: o resultado de f vira a entrada das proximas.
-- Aplicar f ANTES da chamada recursiva garante a ordem esquerda -> direita.
aplicarTodas :: [a -> a] -> a -> a
aplicarTodas [] x = x
aplicarTodas (f:fs) x = aplicarTodas fs (f x)

-- ==== melhorOpcao ====

-- Diferente de aplicarTodas: cada promocao recebe o preco ORIGINAL.
-- Usamos map e minimum porque o tema so proibe esses recursos nas funcoes
-- recursivas, e aqui eles deixam a ideia mais direta.
-- minimum da erro em lista vazia, entao sem promocoes devolvemos o preco cheio.
melhorOpcao :: [Double -> Double] -> Double -> Double
melhorOpcao [] preco = preco
melhorOpcao promocoes preco = minimum (map (\promocao -> promocao preco) promocoes)

-- ==== cupomMinimo (extensao) ====

-- Extensao: cupom que so vale para compras ACIMA de um valor minimo.
-- Tambem devolve uma funcao, entao entra em aplicarTodas e melhorOpcao
-- como qualquer outra promocao.
-- Preco exatamente igual ao limite nao ganha desconto ("maior que").
cupomMinimo :: Double -> Double -> (Double -> Double)
cupomMinimo limite percentual = \preco ->
  if preco > limite
    then criarDesconto percentual preco
    else preco

-- ==== main ====

precoProduto :: Double
precoProduto = 200.0

blackFriday :: Double -> Double
blackFriday = criarDesconto 30

cupom10 :: Double -> Double
cupom10 = subtract 10

cupomAcimaDe150 :: Double -> Double
cupomAcimaDe150 = cupomMinimo 150 20

main :: IO ()
main = do
  putStrLn "=== Motor de promocoes ==="
  putStrLn "Preco do produto:"
  print precoProduto

  putStrLn "\n--- Cada promocao sozinha ---"
  putStrLn "Black Friday (30%):"
  print (blackFriday precoProduto)
  putStrLn "Cupom de 10 reais:"
  print (cupom10 precoProduto)
  putStrLn "Cupom de 20% para compras acima de 150:"
  print (cupomAcimaDe150 precoProduto)

  putStrLn "\n--- Aplicando em sequencia: a ordem importa ---"
  putStrLn "Primeiro Black Friday, depois cupom de 10:"
  print (aplicarTodas [blackFriday, cupom10] precoProduto)
  putStrLn "Primeiro cupom de 10, depois Black Friday:"
  print (aplicarTodas [cupom10, blackFriday] precoProduto)

  putStrLn "\n--- Escolhendo a melhor promocao para o cliente ---"
  putStrLn "Melhor entre as tres, em 200.0:"
  print (melhorOpcao [blackFriday, cupom10, cupomAcimaDe150] precoProduto)
  putStrLn "Sem nenhuma promocao, o preco continua cheio:"
  print (melhorOpcao [] precoProduto)

  putStrLn "\n--- Extensao: cupom com valor minimo ---"
  putStrLn "Compra de 100.0 (abaixo do minimo, nao muda):"
  print (cupomAcimaDe150 100.0)
  putStrLn "Compra de 150.0 (igual ao minimo, nao muda):"
  print (cupomAcimaDe150 150.0)
  putStrLn "Compra de 300.0 (acima do minimo, 20% de desconto):"
  print (cupomAcimaDe150 300.0)

  putStrLn "\n--- Reaplicando uma promocao ---"
  putStrLn "Cupom de 10 aplicado duas vezes:"
  print (aplicarDuasVezes cupom10 precoProduto)
  putStrLn "Cupom de 10 aplicado cinco vezes:"
  print (aplicarNVezes 5 cupom10 precoProduto)
