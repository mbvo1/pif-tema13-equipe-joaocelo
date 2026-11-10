# Tema 13 – Funções de ordem superior em um motor de promoções

**Disciplina:** Programação Imperativa e Funcional – CESAR School – 2026.2
**Equipe:** Joaocelo
**Integrantes:**
- Marcelo Bresani Victor de Oliveira
- João Cláudio Beltrão

## Arquivos
- `Exemplo1.hs` – exemplo conceitual de funções de ordem superior
- `Aplicacao.hs` – motor de promoções (funções obrigatórias, extensão e main)
- `comparacao.c` – versão imperativa em C com ponteiros para função
- `desafio.md` – experimentos do desafio investigativo
- `SINTESE.md` – síntese das descobertas

## Como executar
Requisito: GHC instalado (https://www.haskell.org/ghcup/)

Rodar sem compilar:

    runghc Exemplo1.hs
    runghc Aplicacao.hs

Compilar e executar (Windows PowerShell):

    ghc -Wall Aplicacao.hs -o aplicacao.exe
    .\aplicacao.exe
    ghc -Wall Exemplo1.hs -o exemplo1.exe
    .\exemplo1.exe

Compilar e executar (Linux/macOS):

    ghc -Wall Aplicacao.hs -o aplicacao
    ./aplicacao
    ghc -Wall Exemplo1.hs -o exemplo1
    ./exemplo1

Testar no GHCi:

    ghci Aplicacao.hs

Se o programa já foi compilado nesta pasta, o GHCi só enxerga o `main`. Nesse caso, carregue o código-fonte dentro do GHCi:

    :l *Aplicacao.hs

Versão em C (com gcc):

    gcc -Wall comparacao.c -o comparacao
    ./comparacao

Versão em C no Windows sem gcc (usa o compilador C que vem com o GHC):

    ghc -no-hs-main comparacao.c -o comparacao.exe
    .\comparacao.exe
