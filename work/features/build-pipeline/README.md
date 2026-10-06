# Pipeline de build

- **Tipo:** features
- **Status:** concluída
- **Criada em:** 2026-09-30
- **Atualizado em:** 2026-10-05

## Objetivo

Criar os scripts de build do jogo e expô-los como tarefas do VS Code, para
que debug, release e web sejam um comando cada.

## Contexto

Descopado na revisão do workflow de 2026-09-30, junto do `CLAUDE.md` que
hoje registra: "build e toolchain ainda não têm regra definida".

Depende da demanda `setup-toolchain`: o build web precisa de Emscripten.

## Estado atual

**Concluída em 2026-10-05.** O objetivo foi cumprido: debug, release e web
são um comando cada, expostos como tasks do VS Code.

Entregue e testado pelo desenvolvedor:

- `tools/build.odin` com quatro alvos: `debug`, `release`, `web`, `run`.
- `.vscode/tasks.json` com as quatro tasks e `problemMatcher` que torna o
  erro do Odin clicável; `.vscode/launch.json` com `F5` em duas
  configurações (Windows e Linux/macOS).
- `web/index_template.html`, o molde do bundle web.
- `src/` no formato que o alvo web exige:
  `init`/`update`/`should_run`/`shutdown` em `game.odin`, entry points
  separados por build tag, e o subpacote `src/emscripten/`.
- O alvo web foi verificado **rodando no navegador**, não só linkando.

Fora de escopo, mencionados e não implementados: hot reload (exige
reestruturar `src/` em pacote próprio) e `.vscode/extensions.json`.

## Próximo passo

Nenhum. A demanda está concluída e não será reaberta.

## Decisões

- `scripts/` é configuração do workspace, não código do jogo: o Claude pode
  escrever. Decisão tomada em 2026-10-01, mas **ainda não registrada** na
  tabela do `CLAUDE.md` — verificado em 2026-10-05.
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
- O `tasks.json` ficou fino porque toda a lógica está no `build.odin`:
  cada task é só `odin run tools/build.odin -file -- <alvo>`. Nenhuma
  precisou de variante por plataforma — o mesmo comando vale em
  PowerShell, `cmd` e bash. Era o ganho esperado da rota Odin.
- Cada task carrega um `problemMatcher` inline que casa o formato de erro
  do Odin (`<caminho>(linha:coluna) Error: <mensagem>`, com a variante
  `Syntax Error:`), tornando o erro clicável no painel Problems. Está
  repetido nas quatro porque `tasks.json` não compartilha matcher entre
  tasks — matchers nomeados só vêm de extensões.
- **O `debug` continua sendo a build padrão (`Ctrl+Shift+B`) e o `run`
  não mudou.** O desenvolvedor apontou que uma build padrão que não abre
  o jogo é estranha; a causa era não existir tecla de executar. Resolvido
  configurando o `F5` (`launch.json`) em vez de mover o `isDefault`:
  compilar e executar voltam a ser teclas distintas, e o `.pdb` gerado
  pelo alvo `debug` passa a servir para algo.
- `launch.json` tem **duas** configurações: `cppvsdbg` (motor da
  Microsoft, lê o `.pdb`, só Windows) e `cppdbg` (gdb/lldb, Linux e
  macOS, binário sem `.exe`). Ambas com `preLaunchTask: "debug"`, então o
  F5 nunca depura binário velho. Requer a extensão `ms-vscode.cpptools`,
  já instalada na máquina do desenvolvedor.
- Alvo web confirmado na instalação local do Odin (`dev-2026-03`,
  2026-10-01): `odin build -target:js_wasm32` gera um objeto `.wasm.o`;
  `vendor:raylib` já detecta `ODIN_ARCH == .wasm32` e linka contra
  `vendor/raylib/wasm/libraylib.a`/`libraygui.a`. `emcc` linka esse
  objeto com esses `.a` e com o runtime `core/sys/wasm/js/odin.js` da
  própria distribuição do Odin, produzindo o bundle final
  (`.html`/`.wasm`/`.js`). Não há caminho mais direto na versão atual.
- Reverificação do alvo web em 2026-10-05, agora em
  `dev-2026-09-nightly:a2fb372`: o caminho segue válido, mas o nome da
  biblioteca na decisão acima estava errado. `vendor/raylib/raylib.odin`
  declara `RAYLIB_WASM_LIB :: #config(RAYLIB_WASM_LIB,
  "wasm/libraylib.web.a")` — é **`libraylib.web.a`**, não `libraylib.a`.
  `libraygui.a` e `core/sys/wasm/js/odin.js` continuam onde a decisão diz.
- Verificado em 2026-10-05 que `core:os` desta versão expõe
  `process_start`/`process_wait`/`process_exec` e `Process_Desc`, e que
  `ODIN_ROOT` e `ODIN_OS` são constantes de compile-time utilizáveis.
- **Rota escolhida (2026-10-05): um único programa Odin**, rodado com
  `odin run tools/build.odin -file -- <alvo>`, em vez de um par
  `.ps1`/`.sh`. Motivo: `ODIN_ROOT` e `ODIN_OS` resolvem em compile-time
  as duas coisas que obrigariam a rota shell a existir em dois arquivos
  espelhados — achar o `libraylib.web.a` para o link do `emcc`, e o
  sufixo `.exe`.
- Os helpers do Emscripten vivem em **`src/emscripten/`** como pacote
  próprio (`package emscripten`), importado por `main_web.odin` com
  `import em "./emscripten"`. Em Odin pasta é pacote, então a subpasta
  só entra na compilação quando alguém a importa — e como só o
  `main_web.odin` (que é `#+build js`) a importa, ela nunca entra no build
  desktop. Ambos os arquivos levam `#+build js`, que a referência não
  precisava por viverem num pacote exclusivo do web.
- Nome `emscripten` e não `web` para não colidir com a pasta `web/` da
  raiz, que guarda o `index_template.html`.
- Local: **`tools/build.odin`**, não a raiz. Testado em 2026-10-05 que o
  diretório de trabalho do script é o de onde se chama, não o do arquivo
  — então os caminhos relativos (`src`, `build/...`, `assets`) são idênticos
  nas duas opções e a escolha é puramente organizacional. `build/` está
  fora por colidir com a pasta de saída, que é ignorada pelo git.
  `tools/` também acomoda ferramentas futuras (empacotador de asset,
  upload pro itch).
- Manter o `-file` na chamada. `odin run tools -- <alvo>` funciona hoje e
  é mais curto, mas compila a pasta como um pacote — um segundo programa
  em `tools/` daria dois `main` no mesmo pacote. O `-file` evita essa
  amarra.
- A pasta `scripts/`, vazia com um `.gitkeep`, foi removida: não tem mais
  propósito depois desta decisão.
- Removidas também `shaders/` e `third_party/` (2026-10-05, decisão do
  desenvolvedor). `third_party/` porque a dependência externa do projeto é
  a Raylib, e ela vem do `vendor:` do próprio Odin, não de uma cópia no
  repositório. `shaders/` porque shader é asset, e o lugar dele será
  dentro de `assets/`, não uma pasta isolada na raiz.
- Essas três remoções desfazem parte da demanda `workspace-git`, que criou
  os `.gitkeep` para a estrutura sobreviver a um clone. O brief daquela
  demanda **não foi editado**: demanda concluída não é reaberta, e o
  registro histórico dela continua verdadeiro para a data em que foi
  escrito. A estrutura atual vale no `README.md`.
- Atualizados em 2026-10-05: o bloco de estrutura do `README.md` (sem
  `shaders/`, `scripts/` e `third_party/`, com `tools/`, e com shaders
  listados dentro de `assets/`) e a tabela de permissões do `CLAUDE.md`
  (a linha do desenvolvedor passou de `src/`, `shaders/`, `assets/` para
  `src/`, `assets/`).
- Custo aceito da rota: `odin run` recompila o script a cada chamada —
  medido entre 395 ms e 639 ms nesta máquina. Se incomodar, compilar o
  `build.odin` uma vez para um binário resolve.
- `scripts/` **não será usada**, o que torna sem efeito a decisão de
  2026-10-01 sobre permissão de escrita naquela pasta. O desenvolvedor
  escreve o `build.odin` e os arquivos de `.vscode/`; o Claude ensina
  passo a passo e revisa. A tabela do `CLAUDE.md` fica como está — só a
  linha "build e toolchain ainda não têm regra definida" precisa cair no
  `close`.
- Layout da saída: `build/debug/`, `build/release/`, `build/web/`, e
  `dist/` reservada para os zips do itch.io. `build/`, `bin/` e `dist/` já
  estão no `.gitignore`; nada a ajustar.
- O `odin build` **não cria** o diretório do `-out:`. Verificado em
  2026-10-05: com `build/debug/` ausente o link falha com
  `LNK1104: não é possível abrir o arquivo ...game.exe`. O script precisa
  criar a pasta antes. Usar `os.make_directory_all`, que é recursivo e
  idempotente (retorna `nil` criando e também se já existe), e não
  `os.make_directory`, que falha com `Not_Exist` se faltar o pai e com
  `Exist` na segunda chamada.
- Alvo web, investigado a fundo em 2026-10-05 com Emscripten 6.0.10.
  **Não concluído.** O comando de duas etapas que linka sem erro é:
  `odin build src -target:js_wasm32 -build-mode:obj
  -define:RAYLIB_WASM_LIB=env.o -out:build/web/game.wasm.o`, depois
  `emcc -o build/web/index.html build/web/game.wasm.o
  <ODIN_ROOT>/vendor/raylib/wasm/libraylib.web.a <...>/libraygui.a
  -sUSE_GLFW=3 -sASYNCIFY -sERROR_ON_UNDEFINED_SYMBOLS=0
  --pre-js <shim>.js`.
- O `-define:RAYLIB_WASM_LIB=env.o` é **obrigatório** e foi isolado por
  teste: sem ele o `emcc` falha com `undefined symbol: InitWindow` e
  companhia; com ele, só `write` e `rand_bytes` ficam pendentes.
- O Odin importa de um módulo WASM próprio chamado **`odin_env`**
  (`core/sys/wasm/js/general.odin`), que o Emscripten não conhece.
  Inspecionando os imports do `.wasm` gerado: `odin_env` precisa de
  **apenas 2** funções (`write`, `rand_bytes`); as outras 275 do `env`
  (GL/GLFW) e as 5 do `wasi_snapshot_preview1` o Emscripten já fornece.
- Um `--js-library` **não resolve**: ele popula o `env`, não o `odin_env`.
  O que resolve é o hook oficial `Module.instantiateWasm` via `--pre-js`,
  acrescentando `imports.odin_env` antes da instanciação. Verificado no
  navegador: com o shim, o erro
  `Import #0 "odin_env": module is not an object or function` desaparece e
  o wasm instancia.
- **Onde parou:** com o shim, o wasm instancia mas o jogo não aparece — o
  canvas fica em 300x150 (o padrão do HTML, ou seja o `InitWindow(960,540)`
  não tomou efeito) e `Module.calledRun` nunca vira `true`. Suspeita a
  investigar: interação do `-sASYNCIFY` com o loop bloqueante, que é
  exatamente o que a decisão do `init()`/`step()` previu.
- Lição registrada: "o bundle é gerado" e "o link passa" não são o mesmo
  que "o jogo roda". As três etapas precisam ser verificadas separadamente.
- **Referência externa encontrada em 2026-10-05**, depois que a
  investigação solo empacou: `karl-zylinski/odin-raylib-web`, que resolve
  o alvo web por completo. Decisão do desenvolvedor: o alvo web **fica
  nesta demanda**, e adaptar `src/` ao formato exigido está autorizado.
- A arquitetura que funciona, lida do repositório de referência:
  1. O `odin.js` da distribuição (`core/sys/wasm/js/odin.js`) é **copiado
     para o bundle** e carregado pelo HTML. Ele expõe
     `odin.setupDefaultImports()`, que fornece o módulo `odin_env`
     **completo**. O shim de 2 funções escrito à mão nesta sessão era uma
     reconstrução pobre disso e deve ser descartado.
  2. Um `--shell-file index_template.html` próprio contém o
     `Module.instantiateWasm`, que faz `{...odinImports, ...imports}` e
     registra a memória do wasm na interface do Odin.
  3. **Sem `-sASYNCIFY`.** O loop é do JavaScript: `onRuntimeInitialized`
     chama `_start()` (procs `@init`) e `main_start()`, e um
     `requestAnimationFrame` recursivo chama `main_update()` a cada frame
     até ela retornar falso, quando chama `main_end()` e `_end()`.
  4. O código do jogo expõe `@export main_start`/`main_update`/`main_end`
     — ou seja, exatamente a separação `init()`/`step()` já decidida no
     rascunho, agora obrigatória e não mais opcional.
  5. Flags do `emcc` da referência: `-sUSE_GLFW=3`,
     `-sWARN_ON_UNDEFINED_SYMBOLS=0` (aviso, não erro),
     `-sEXPORTED_RUNTIME_METHODS=['HEAPF32']`, `-sASSERTIONS`,
     `--shell-file`, `--preload-file assets`. E
     `-define:RAYGUI_WASM_LIB=env.o` junto do `RAYLIB_WASM_LIB`.
- Lição de processo: pesquisar referências externas antes de iterar sozinho
  em terreno desconhecido. A investigação solo chegou perto mas custou
  caro; o repositório de referência responde tudo o que faltava.
- **Receita final do alvo web, validada de ponta a ponta.** `src/` é um
  único pacote e os entry points se separam por **build tags**
  (`#+build !js` no desktop, `#+build js` no web), não por `when`: o
  compilador recusa `import` dentro de `when` e manda usar tags. Isso
  dispensa os três pacotes da referência.
- `src/` contém ainda `emscripten_allocator.odin` e
  `emscripten_logger.odin`, adaptados da referência: o alocador WASM
  padrão conflita com o do Emscripten.
- `web/index_template.html` é o `--shell-file`: carrega o `odin.js`
  copiado da distribuição, monta `Module.instantiateWasm` fundindo
  `{...odinImports, ...imports}`, e roda o loop com
  `requestAnimationFrame` chamando `main_update()`. Adaptado do template
  de `karl-zylinski/odin-raylib-web` (licença zlib, Copyright (c)
  2025-2026 Karl Zylinski), marcado como alterado no próprio arquivo —
  a licença permite derivar, exigindo não se passar pela origem.
- **`-sASYNCIFY` não deve ser usado.** Testado: evita o abort mas quebra o
  loop, porque `main_update()` passa a devolver uma Promise e o
  `if (!e.main_update())` do template nunca é falso. Tela preta.
- As duas chamadas que abortam no web são `rl.SetTargetFPS` e
  `rl.WindowShouldClose`: a raylib web implementa as duas com
  `emscripten_sleep`, que exigiria ASYNCIFY. Ambas ficam sob
  `when ODIN_ARCH != .wasm32`. No web o ritmo é do `requestAnimationFrame`
  e quem fecha é a aba do navegador.
- A decisão original falava em passar `step()` como callback ao
  Emscripten. Na prática quem chama o loop é o **JavaScript** do
  `index_template.html`, via `requestAnimationFrame`, e o Odin expõe
  `@export main_start`/`main_update`/`main_end`. O espírito da decisão
  (loop não-bloqueante, controlado de fora) se confirmou; o mecanismo é
  outro.
- `os.process_start` **não herda** a saída do terminal: `stdout`/`stderr`
  não preenchidos ficam `nil`, o que *desliga* a saída do filho. É preciso
  passar `stdout = os.stdout, stderr = os.stderr` para ver o erro de
  compilação ao vivo. O código de saída do filho atravessa o `odin run`
  intacto — verificado —, o que é o que fará as tasks do VS Code
  marcarem falha.
- O jogo nasce com o frame loop separado em `step()`: `main()` chama
  `init()` uma vez e depois `step()` em loop no desktop; no alvo web,
  `step()` é passado como callback para o Emscripten, que controla o
  loop principal (não aceita um `for` bloqueante). Decidido agora porque
  `src/` ainda está vazio — custo zero hoje, evita reescrever a estrutura
  de todo jogo nascido do template quando o build web entrar em uso.
  Essa convenção deve orientar o primeiro esqueleto de `src/`.

## Perguntas em aberto

Nenhuma.

## Documentos

Conhecimento permanente promovido no fechamento:

- [`docs/platforms.md`](../../../docs/platforms.md) — como o jogo é
  construído em cada plataforma e o que o alvo web exige do código do
  jogo. Indexado em `docs/README.md`.

Nenhum documento adicional foi criado dentro da demanda.

## Evidências

- <nenhuma ainda>
