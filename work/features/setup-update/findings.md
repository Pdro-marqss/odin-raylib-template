# Levantamento e achados empíricos

Tudo aqui foi verificado numa máquina real (Windows 11) em 2026-10-03,
durante a demanda `setup-update`. O brief referencia este documento em
vez de carregar o detalhe.

## Como o Odin estava instalado, antes da atualização

- `C:\odin` era um **clone git completo** de
  `https://github.com/odin-lang/Odin.git`, no branch `master`, compilado
  da fonte (`build.bat`, `LLVM-C.dll` presente) — não a distribuição
  binária em zip.
- `git describe --tags` reportava `dev-2026-03-228-g44b50eab9`: a
  instalação estava **228 commits depois** da tag `dev-2026-03`, num
  ponto intermediário de `master`, não numa release.
- `odin version` imprimia só `dev-2026-03:44b50eab9` e escondia esses
  228 commits.
- `ODIN_ROOT` não estava definido; o Odin era achado pelo PATH
  (`C:\odin\odin.exe`).
- A pasta tinha 1015 MB, dos quais 570 MB eram o `.git`. A árvore de
  trabalho estava limpa.
- **`ols.exe` morava dentro de `C:\odin`** e era o OLS que o PATH
  resolvia (`C:\odin\ols`). É um binário ignorado pelo `.gitignore` do
  Odin — por isso o `git status` vinha limpo.

A divergência entre isso e o `dependencies.md` — que manda instalar a
distribuição oficial — é um achado desta demanda, não um problema
resolvido aqui.

## Como o Emscripten está instalado

- `C:\emsdk` existe, com `emsdk_env.bat`, e o `emcc` está no PATH
  (`C:\emsdk\upstream\emscripten\emcc`) — instalado pelo caminho
  oficial do `emsdk`.
- Versão instalada: **6.0.10**, legível em
  `upstream/emscripten/emscripten-version.txt` (além de
  `emcc --version`).

Não foi atualizado: o Emscripten saiu do escopo da demanda.

## A atualização do Odin, como foi executada

1. Última release descoberta pelo redirect de
   `https://github.com/odin-lang/Odin/releases/latest` → `dev-2026-09`.
2. Baixado `odin-windows-amd64-dev-2026-09.zip`: 148.548.059 bytes,
   2270 entradas, CRC de todas conferido.
3. `C:\odin` renomeado para `C:\odin.bak-dev-2026-03`.
4. Conteúdo de `dist/` extraído em `C:\odin`. PATH não tocado.
5. Backup apagado depois da confirmação do dev (0,99 GB liberados).

Resultado verificado:

- `odin version` → `dev-2026-09-nightly:a2fb372`;
- `vendor/raylib/wasm/`: `libraylib.web.a` (1.360.242 bytes) e
  `libraygui.a` (188.456 bytes);
- `vendor/raylib/windows/`: `raylib.dll`, `raylib.lib` e os do raygui;
- um programa mínimo importando `vendor:raylib` compilou, linkou com
  MSVC e rodou, imprimindo **`raylib 6.0`** — o salto de 5.5 para 6.0;
- o autocomplete do OLS voltou a funcionar (confirmado pelo dev em
  outro projeto Odin que aponta para `C:\odin`).

`src/` estava vazio (só `.gitkeep`), então não havia jogo para compilar.
O programa mínimo foi compilado fora do repositório, no diretório
temporário da sessão.

## Achados que viraram regra no `dependencies.md`

Cada um apareceu por ter rodado de verdade:

- o `odin version` de um clone esconde os commits depois da tag —
  `git describe --tags` é a leitura confiável ali;
- o `odin version` de uma release traz sufixo `-nightly`
  (`dev-2026-09-nightly:a2fb372` para a tag `dev-2026-09`), então a
  comparação com a tag precisa ser só do prefixo `dev-AAAA-MM`;
- o nome do binário wasm da Raylib mudou entre as versões:
  `libraylib.a` (dev-2026-03) → `libraylib.web.a` (dev-2026-09);
- a release traz também um `<tag>.zip` de código-fonte, então
  selecionar asset pela extensão pega o arquivo errado — selecione pelo
  prefixo `odin-<os>-<arch>-`;
- o zip da release empacota tudo sob uma pasta de topo `dist/`; o que
  vira o diretório de instalação é o **conteúdo** de `dist/`;
- `api.github.com` pode estar inalcançável numa máquina onde
  `github.com`, `objects.githubusercontent.com`,
  `raw.githubusercontent.com` e `storage.googleapis.com` respondem — o
  redirect de `/releases/latest` dispensa a API.
