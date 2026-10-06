# Odin + Raylib Template

Template de workspace para desenvolvimento de jogos em **Odin + Raylib**,
com o Claude Code como copiloto e mentor.

Plataformas alvo: Windows, Linux, macOS e Web/WebAssembly.

## Ideia do jogo

Nome, pitch, estilo e mecânicas centrais vivem em `docs/concept.md`,
semeado e mantido pela skill `game-init` (`/game-init`).

## Ambiente de desenvolvimento

`/setup check` mostra o que falta da toolchain (Odin, linker,
Emscripten, OLS); `/setup install` instala o que faltar; `/setup update
odin` atualiza o Odin para a release mais recente.

## Estrutura

```text
src/          código do jogo
assets/       imagens, áudio, fontes, shaders
tools/        ferramentas de build do workspace
docs/         como o jogo funciona (permanente)
work/         demandas em andamento (temporário)
.claude/      configuração e skills do Claude Code
```

## Fluxo de trabalho

O desenvolvimento é organizado em **demandas**: unidades de trabalho do
rascunho ao fechamento, geridas pela skill `game-work`.

| Comando | O que faz |
|---|---|
| `/game-work new <tipo> <nome>` | cria uma demanda em rascunho |
| `/game-work start <nome>` | coloca em execução |
| `/game-work resume <nome>` | retoma de onde parou |
| `/game-work close <nome>` | conclui e promove o que é permanente |
| `/game-work list` | mostra as demandas e seus status |

O modelo completo está em `.claude/skills/game-work/reference.md`, e as
regras de comportamento do Claude no `CLAUDE.md`.

## Build

Quatro alvos, um comando cada, rodados da raiz do projeto:

```text
odin run tools/build.odin -file -- debug      build/debug/
odin run tools/build.odin -file -- release    build/release/
odin run tools/build.odin -file -- web        build/web/
odin run tools/build.odin -file -- run        compila e executa
```

As mesmas quatro estão como tasks do VS Code (`Ctrl+Shift+B` roda o
`debug`), e o `F5` compila e anexa o depurador.

O alvo web impõe um formato ao código de `src/`: sem loop bloqueante, e
algumas chamadas da raylib indisponíveis. Veja
[`docs/platforms.md`](docs/platforms.md).

## Começar um jogo a partir deste template

Use o botão **Use this template** no GitHub para gerar um repositório novo.

No repositório gerado, rode `/game-init`: ele entrevista você sobre a
ideia do jogo, preenche `docs/concept.md`, atualiza o título e a
descrição deste README com a identidade do jogo, e limpa `work/` e
`docs/` dos exemplos do template.

A seção Build não é tocada pelo `/game-init` — ela é definida por uma
demanda própria de toolchain.

Não mexa em `.claude/` nem no `CLAUDE.md`: são o fluxo, não o jogo.
