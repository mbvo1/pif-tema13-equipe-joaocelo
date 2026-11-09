-- Exemplo conceitual: funcoes tratadas como qualquer outro valor.

-- 1. Funcao que RECEBE funcao: aplica a regra nos dois lados do par.
nosDoisLados :: (Int -> Int) -> (Int, Int) -> (Int, Int)
nosDoisLados regra (a, b) = (regra a, regra b)

-- 2. Funcao que DEVOLVE funcao: fabrica uma saudacao para cada idioma.
criarSaudacao :: String -> (String -> String)
criarSaudacao cumprimento = \nome -> cumprimento ++ ", " ++ nome

-- 4. Lista de funcoes: todas tem o mesmo tipo, Int -> Int.
transformacoes :: [Int -> Int]
transformacoes = [negate, abs, (* 2)]

main :: IO ()
main = do
  putStrLn "Funcao recebida como argumento (triplo em cada lado):"
  print (nosDoisLados (* 3) (2, 7))

  putStrLn "Funcao devolvida por outra funcao:"
  print (criarSaudacao "Bom dia" "Ada")

  -- 3. Lambda usada direto como argumento, sem precisar de nome.
  putStrLn "Lambda como argumento (resto da divisao por 2):"
  print (nosDoisLados (\n -> n `mod` 2) (2, 7))

  putStrLn "Lista de funcoes aplicada ao numero -4:"
  print (map (\f -> f (-4)) transformacoes)
