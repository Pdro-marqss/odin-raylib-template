# Comando de setup da toolchain

- **Tipo:** features
- **Status:** rascunho
- **Criada em:** 2026-09-30
- **Atualizado em:** 2026-09-30

## Objetivo

Criar uma skill `setup` com duas operações irmãs: `check`, que verifica se
a toolchain necessária para desenvolver e buildar o jogo está instalada e
funcionando, e `install`, que instala e configura o que falta.

A meta maior é poder distribuir o workspace leve e deixar um PC novo pronto
para desenvolver rodando um comando.

## Contexto

Nada no workspace verifica a toolchain hoje. Isso bloqueia o passo 5 da
regra principal do `CLAUDE.md` ("depois, analise o resultado"): sem
conseguir compilar, não há resultado para analisar.

Dependências levantadas na conversa: Odin, um linker, e Emscripten para o
alvo web.

## Estado atual

- Não iniciada. A discussão de 2026-09-30 está registrada abaixo.

## Próximo passo

Decidir se a toolchain fica dentro do repositório ou instalada no sistema.
Essa decisão muda todo o resto do desenho.

## Decisões

- Raylib não é dependência a instalar: vem dentro da distribuição do Odin
  como `vendor:raylib`. Verificado em `C:\odin\vendor\raylib\`, que tem
  subpastas `windows`, `linux`, `macos`, `macos-arm64` e `wasm` — esta
  última com `libraylib.a` pronto para o alvo web.
- `check` e `install` são operações irmãs (`/setup check`, `/setup
  install`), não uma chamando a outra. Aninhar esconderia o `check`, que é
  a operação de uso frequente.
- `check` vem primeiro: é determinística, barata, e já resolve o caso do PC
  novo, que é saber o que falta.

## Perguntas em aberto

- A toolchain fica dentro do repositório (`third_party/odin`,
  `third_party/emsdk`) ou instalada no sistema? Dentro dispensa mexer no
  PATH e faz um PC novo funcionar, mas custa gigabytes por projeto e
  conflita com distribuir a pasta leve. Fora mantém o repositório leve, mas
  exige configurar PATH.
- Qual é a dependência real de linker do Odin `dev-2026-03` em cada
  plataforma? A conversa assumiu gcc, mas o Odin tem backend próprio e
  provavelmente usa o linker do MSVC no Windows e o clang no Linux.
  Verificar empiricamente, não supor.
- O `install` deve editar PATH persistente? É a parte mais frágil e exige
  reabrir o terminal, o que quebra a experiência de "rodou e funciona".
- Vale automatizar o `install`, ou um `check` que diz o que falta e qual
  comando rodar entrega a maior parte do valor com uma fração do trabalho?
- Emscripten passa de 1 GB e instala via `emsdk` (clone + script Python).
  Vale tratá-lo como passo opcional, só para quem vai buildar para web?

## Documentos

- <nenhum ainda>

## Evidências

- <nenhuma ainda>
