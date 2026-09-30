# Odin + Raylib Template

Template de workspace para desenvolvimento de jogos em **Odin + Raylib**,
com o Claude Code como copiloto e mentor.

Plataformas alvo: Windows, Linux, macOS e Web/WebAssembly.

## Estrutura

```text
src/          código do jogo
shaders/      shaders
assets/       imagens, áudio, fontes
scripts/      build e toolchain
third_party/  dependências externas
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
| `/game-work list` | mostra as demandas e seus estados |

O modelo completo está em `.claude/skills/game-work/reference.md`, e as
regras de comportamento do Claude no `CLAUDE.md`.

## Build

A definir.

## Começar um jogo a partir deste template

Use o botão **Use this template** no GitHub para gerar um repositório novo.

No repositório gerado:

1. `README.md` — substitua título, descrição e a seção Build pelos do jogo;
2. `work/*/` — apague as demandas, mantendo as pastas de tipo;
3. `docs/` — apague os documentos e limpe a tabela do `docs/README.md`.

Não mexa em `.claude/` nem no `CLAUDE.md`: são o fluxo, não o jogo.
