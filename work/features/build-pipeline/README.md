# Pipeline de build

- **Tipo:** features
- **Status:** rascunho
- **Criada em:** 2026-09-30
- **Atualizado em:** 2026-10-01

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
- `setup-toolchain` concluída, então a dependência que bloqueava esta
  demanda caiu.
- Rascunho fechado em 2026-10-01: as quatro perguntas em aberto foram
  respondidas (ver `Decisões`). Pronta para `/game-work start`.

## Próximo passo

Rodar `/game-work start build-pipeline` e atacar primeiro o build
desktop (debug/release), que não depende do alvo web. O alvo web entra
depois, já com o caminho `-target:js_wasm32` + `emcc` confirmado.

## Decisões

- `scripts/` é configuração do workspace, não código do jogo: o Claude pode
  escrever. Registrado na tabela do `CLAUDE.md`.
- A saída vai para `build/` via `-out:`, em vez de acrescentar padrões ao
  `.gitignore`. O `odin build` emite o executável ao lado do fonte por
  padrão.
- `docs/platforms.md` — as restrições de plataforma, principalmente a do
  alvo web — deve nascer do fechamento desta demanda, não ser criado antes.
  É conhecimento permanente e o fluxo já prevê que ele venha do `close`.
- `.vscode/*` já permite versionar `tasks.json`, `launch.json` e
  `extensions.json` — decisão herdada da demanda `workspace-git`.
  `settings.json` continua ignorado, por ser pessoal. Nada novo a fazer
  aqui.
- Tasks do VS Code: quatro — `debug`, `release`, `web` e `run`. `run`
  builda release e executa o binário direto, sem anexar o debugger, para
  iteração rápida.
- Alvo web confirmado na instalação local do Odin (`dev-2026-03`,
  2026-10-01): `odin build -target:js_wasm32` gera um objeto `.wasm.o`;
  `vendor:raylib` já detecta `ODIN_ARCH == .wasm32` e linka contra
  `vendor/raylib/wasm/libraylib.a`/`libraygui.a`. `emcc` linka esse
  objeto com esses `.a` e com o runtime `core/sys/wasm/js/odin.js` da
  própria distribuição do Odin, produzindo o bundle final
  (`.html`/`.wasm`/`.js`). Não há caminho mais direto na versão atual.
- O jogo nasce com o frame loop separado em `step()`: `main()` chama
  `init()` uma vez e depois `step()` em loop no desktop; no alvo web,
  `step()` é passado como callback para o Emscripten, que controla o
  loop principal (não aceita um `for` bloqueante). Decidido agora porque
  `src/` ainda está vazio — custo zero hoje, evita reescrever a estrutura
  de todo jogo nascido do template quando o build web entrar em uso.
  Essa convenção deve orientar o primeiro esqueleto de `src/`.

## Perguntas em aberto

Nenhuma. Todas foram respondidas em 2026-10-01 (decisões acima).

## Documentos

- <nenhum ainda>

## Evidências

- <nenhuma ainda>
