# Plataformas

Como o jogo é construído para cada plataforma, e as restrições que cada
uma impõe ao código do jogo.

Plataformas alvo: Windows, Linux, macOS e Web/WebAssembly.
Distribuição pelo itch.io.

## Build

Toda a lógica de build vive em `tools/build.odin`, um programa Odin.
Quatro alvos, um comando cada, rodados da raiz do projeto:

```
odin run tools/build.odin -file -- debug      build/debug/   com simbolos
odin run tools/build.odin -file -- release    build/release/ otimizado
odin run tools/build.odin -file -- web        build/web/     bundle wasm
odin run tools/build.odin -file -- run        compila debug/release e executa
```

As mesmas quatro estão em `.vscode/tasks.json`. O `F5`
(`.vscode/launch.json`) compila o alvo `debug` e anexa o depurador.

O build script é um programa Odin, e não um par `.ps1`/`.sh`, porque
`ODIN_ROOT` e `ODIN_OS` são constantes de tempo de compilação: o caminho
das bibliotecas e o sufixo `.exe` se resolvem sozinhos, sem duplicar
lógica por plataforma.

`odin build` não cria o diretório do `-out:`. O script cria com
`os.make_directory_all`, que é recursivo e idempotente.

## Formato obrigatório de `src/`

O alvo web impõe a forma do código do jogo. **Não existe loop bloqueante
no `main`.** O jogo expõe quatro procedimentos, e quem os chama é o
entry point de cada plataforma:

| Procedimento | Quando roda |
|---|---|
| `init()` | uma vez, na partida |
| `update()` | uma vez por frame |
| `should_run()` | a cada frame; `false` encerra |
| `shutdown()` | uma vez, no fim |

Os entry points ficam em arquivos separados por **build tag**, não por
`when` — o compilador recusa `import` dentro de `when` e exige tags:

```
src/game.odin           sem tag; vale para todas as plataformas
src/main_desktop.odin   #+build !js  — tem `main`, roda o loop num `for`
src/main_web.odin       #+build js   — sem `main`; exporta para o JavaScript
src/emscripten/         #+build js   — alocador e logger do Emscripten
```

`src/emscripten/` é um pacote próprio (em Odin, pasta é pacote),
importado só pelo `main_web.odin`. Por isso nunca entra no build desktop.

## Restrições do alvo web

### O loop é do navegador

`main_web.odin` exporta `main_start`, `main_update`, `main_end` e
`web_window_size_changed` com `@export` e convenção `proc "c"`. O
JavaScript de `web/index_template.html` chama `main_update()` a cada
frame via `requestAnimationFrame`.

Como `proc "c"` não carrega o `context` implícito do Odin, cada um desses
procedimentos precisa reinstalá-lo na primeira linha.

### Chamadas da raylib proibidas no web

Estas são implementadas com `emscripten_sleep`, que aborta a execução sem
`-sASYNCIFY`. Mantenha-as sob `when ODIN_ARCH != .wasm32`:

| Chamada | Por que não, e o que faz o papel dela |
|---|---|
| `rl.SetTargetFPS` | quem dita o ritmo é o `requestAnimationFrame` |
| `rl.WindowShouldClose` | quem fecha é a aba do navegador |

Ao adicionar qualquer chamada nova da raylib, se o build web abortar com
*"Please compile your program with async support"*, a causa é esta.

### `-sASYNCIFY` não é a saída

Ele evita o abort, mas quebra o loop: `main_update()` passa a devolver uma
Promise, o `if (!e.main_update())` do template nunca é falso, e a tela
fica preta. A solução é não chamar o que dorme.

### Montagem do bundle

Duas etapas encadeadas. O Odin produz um objeto (`-build-mode:obj`), e o
`emcc` o linka com as bibliotecas da raylib e o HTML:

- `-define:RAYLIB_WASM_LIB=env.o` (e o equivalente de raygui) é
  **obrigatório**. Sem ele o link falha com `undefined symbol: InitWindow`.
- `core/sys/wasm/js/odin.js` da distribuição do Odin é copiado para o
  bundle. É ele que fornece o módulo de imports `odin_env`, que o
  Emscripten desconhece; `web/index_template.html` funde os dois conjuntos
  de imports no gancho `Module.instantiateWasm`.
- Assets entram pelo `--preload-file assets`.

`web/index_template.html` é adaptado do template de
`karl-zylinski/odin-raylib-web` (licença zlib, Copyright (c) 2025-2026
Karl Zylinski), e está marcado como versão alterada no próprio arquivo.

### Verificar no navegador, não só no terminal

O build web pode linkar sem nenhum erro e mesmo assim não rodar. Os dois
problemas acima se manifestam só em tempo de execução, no console do
navegador. Sirva `build/web/` por HTTP (abrir o `index.html` como arquivo
local não funciona) e confirme que a cena aparece e que os frames avançam.

## Saída

```
build/debug/     executavel + simbolos (.pdb no Windows)
build/release/   executavel otimizado
build/web/       index.html, index.js, index.wasm, index.data, odin.js
dist/            reservada para os pacotes do itch.io
```

Tudo ignorado pelo git.
