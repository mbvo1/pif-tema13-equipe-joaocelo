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
