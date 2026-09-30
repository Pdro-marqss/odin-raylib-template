# Versionamento do workspace

- **Tipo:** features
- **Status:** concluída
- **Criada em:** 2026-09-30
- **Atualizado em:** 2026-09-30

## Objetivo

Inicializar o repositório git e garantir que a estrutura de pastas do
workspace sobreviva a um clone.

## Contexto

O workspace tinha `.gitignore` mas não era um repositório git. As pastas
`src/`, `assets/`, `shaders/`, `third_party/`, `scripts/` e as pastas de
tipo de `work/` estavam vazias, e git não versiona pasta vazia — então
clonar o workspace entregaria os arquivos sem a estrutura que os organiza.

Isso era crítico para a meta de reutilizar o workspace como base de jogos
futuros.

## Estado atual

Concluída em 2026-09-30.

- Repositório inicializado, branch `main`.
- Nove `.gitkeep` criados: `src/`, `assets/`, `shaders/`, `scripts/`,
  `third_party/` e as quatro pastas de tipo vazias de `work/`.
- `.gitattributes` criado, normalizando o repositório em LF.
- `.gitignore` corrigido em quatro pontos.
- Commit inicial com 26 arquivos.

## Próximo passo

Nenhum. A demanda está concluída.

## Decisões

- `.vscode/` passou de pasta inteiramente ignorada para `.vscode/*` com
  negações para `tasks.json`, `launch.json` e `extensions.json`. Sem isso o
  pipeline planejado em `build-pipeline` seria ignorado em silêncio. A
  negação exige `.vscode/*` e não `.vscode/`, porque git não desfaz exceção
  dentro de pasta ignorada.
- Acrescentados `*.exe`, `*.o`, `*.obj`, `*.ilk`: `odin build src` sem
  `-out:` emite o binário ao lado do fonte, fora de `build/`. Em Linux e
  macOS o binário não tem extensão, então a proteção real é o build usar
  sempre `-out:build/`.
- Removido `*.wasm`: glob amplo demais, e a saída web já cai em `build/` ou
  `dist/`, ambos ignorados.
- `.gitattributes` criado **antes** do primeiro commit. Depois de commitar
  arquivos CRLF, adicionar normalização geraria um commit de renormalização
  tocando todos os arquivos de texto sem mudar conteúdo.
- `third_party/` mantido com `.gitkeep`. Seu destino depende da decisão de
  toolchain dentro ou fora do repositório, que é pergunta aberta da demanda
  `setup-toolchain`.

## Perguntas em aberto

Nenhuma.

## Documentos

Nenhum documento permanente. Política de fim de linha e de versionamento
não descreve como o jogo funciona, então não pertence a `docs/`.

## Evidências

- <nenhuma>
