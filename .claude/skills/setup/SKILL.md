---
name: setup
description: Verifica e instala a toolchain de desenvolvimento (Odin, linker, Emscripten, OLS) no sistema.
disable-model-invocation: true
argument-hint: "check | install"
---

# Setup

Verifica e prepara a toolchain necessária para desenvolver e buildar o
jogo: Odin, o linker da plataforma, Emscripten (build web) e o OLS
(autocomplete no editor).

## Operações

| Comando | Função | Procedimento |
|---|---|---|
| `check` | Verifica o que está instalado e o que falta | `check.md` |
| `install` | Instala e configura o que falta | `install.md` |

Leia somente o arquivo da operação solicitada. Ambas leem
`dependencies.md` — a lista de dependências, para quê servem, e como
detectar e instalar cada uma por plataforma.

## Relação entre as operações

`check` e `install` são operações irmãs, não uma aninhada na outra —
`check` é a de uso frequente e não deve ficar escondida atrás do
`install`.

`check` vem primeiro: é determinística, barata, e resolve sozinha o
caso mais comum (saber o que falta num PC novo). `install` reaproveita
a mesma lógica de detecção do `check` antes de agir — nunca assume o
estado do sistema.

A toolchain fica instalada no sistema, nunca dentro do repositório:
mantém o workspace leve, e o `PATH` é resolvido uma vez por máquina,
compartilhado entre todos os jogos feitos a partir deste template — não
uma cópia por projeto.

## Princípios gerais

- Para cada dependência, distinga "não instalado" de "instalado mas
  fora do PATH" — são problemas diferentes, com soluções diferentes
  (instalar vs. corrigir o PATH). Nunca reinstale algo só por estar
  fora do PATH.
- `install` age um item por vez: mostra o que vai fazer, pede
  permissão, executa, confirma, passa para o próximo. Nunca uma
  aprovação única para tudo de uma vez.
- A confirmação final de que o `PATH` pegou é manual: peça ao dev para
  abrir uma janela de terminal nova do sistema operacional (não só uma
  conversa nova no mesmo terminal) e rodar o comando de versão da
  ferramenta à mão, reportando o que apareceu.
