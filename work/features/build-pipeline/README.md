# Pipeline de build

- **Tipo:** features
- **Status:** rascunho
- **Criada em:** 2026-09-30
- **Atualizado em:** 2026-09-30

## Objetivo

Criar os scripts de build do jogo e expô-los como tarefas do VS Code, para
que debug, release e web sejam um comando cada.

## Contexto

Descopado na revisão do workflow de 2026-09-30, junto do `CLAUDE.md` que
hoje registra: "build e toolchain ainda não têm regra definida".

Depende da demanda `setup-toolchain`: o build web precisa de Emscripten.

## Estado atual

- Não iniciada. Scripts de build foram escritos e revertidos durante a
  revisão do workflow, por estarem fora do escopo daquele trabalho.

## Próximo passo

Aguardar a demanda `setup-toolchain`, ou escrever primeiro só o build
desktop, que não depende dela.

## Decisões

- `scripts/` é configuração do workspace, não código do jogo: o Claude pode
  escrever. Registrado na tabela do `CLAUDE.md`.
- A saída vai para `build/` via `-out:`, em vez de acrescentar padrões ao
  `.gitignore`. O `odin build` emite o executável ao lado do fonte por
  padrão.
- `docs/platforms.md` — as restrições de plataforma, principalmente a do
  alvo web — deve nascer do fechamento desta demanda, não ser criado antes.
  É conhecimento permanente e o fluxo já prevê que ele venha do `close`.

## Perguntas em aberto

- `.vscode/` está no `.gitignore`. Para versionar o `tasks.json` é preciso
  ignorar apenas o que é pessoal, como `.vscode/settings.json`.
- Quantas tarefas: debug, release e web, ou também uma de run?
- O alvo web usa Emscripten com `emcc` linkando o objeto do Odin, ou existe
  caminho mais direto na versão atual? Verificar.
- O jogo precisa nascer com o frame loop separado em `step()` para portar
  para web sem reescrita. Confirmar como isso afeta o desenho de `src/`.

## Documentos

- <nenhum ainda>

## Evidências

- <nenhuma ainda>
