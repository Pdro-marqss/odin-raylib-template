# Dependências

Define o que cada dependência é, para quê serve, como detectar e como
instalar. Usado por `check.md` e `install.md` — não duplique esta
informação neles.

## Odin

- **Para quê:** compilador da linguagem. A Raylib já vem embutida
  (`vendor:raylib`) — não é dependência separada.
- **Detectar:** `odin version` no PATH.
- **No alvo web:** confirme que `vendor/raylib/wasm/` tem os binários
  da Raylib (`libraylib.a` ou `libraylib.web.a`, e `libraygui.a`) com
  tamanho de binário real — não um ponteiro de Git LFS nem pasta vazia.
  O nome exato varia por versão do Odin (testado empiricamente em
  2026-10-01 numa instalação `dev-2026-03`: são `libraylib.a` e
  `libraygui.a`, ~1.3 MB e ~188 KB) — verifique pela existência e
  tamanho, não por um nome fixo. Pacotes de terceiros (Homebrew,
  algumas distros Linux) já distribuíram isso quebrado; a distribuição
  oficial não tem esse problema.
- **Instalar:** baixar a distribuição oficial em
  https://odin-lang.org/docs/install/ (não um pacote de terceiros) e
  adicionar ao PATH.

## Linker

Depende do Odin já estar instalado. Não é gcc em nenhuma plataforma —
cada uma usa um linker diferente.

- **Para quê:** o Odin compila para código-objeto, mas não linka
  sozinho — chama o linker do sistema para montar o executável final.

**Windows: MSVC (`link.exe`) + Windows SDK**
- Detectar: **não** procure `cl`/`link` no PATH — isso é normal estar
  ausente mesmo com tudo certo, porque o MSVC não se registra no PATH
  global (só em prompts próprios como "Developer Command Prompt"). O
  Odin localiza a instalação do Visual Studio sozinho. Em vez disso:
  use o `vswhere.exe` (`%ProgramFiles(x86)%\Microsoft Visual
  Studio\Installer\vswhere.exe`) pra confirmar que existe alguma
  instalação do Visual Studio/Build Tools. Confirmado empiricamente em
  2026-10-01: um `odin build` real linkou com sucesso numa máquina sem
  `cl`/`link` no PATH, só com o Visual Studio Community instalado.
- Instalar: Visual Studio Build Tools, só com os componentes
  necessários — não a workload completa "Desktop development with
  C++", que traz MFC, ATL e ferramentas de teste desnecessárias aqui:
  ```
  vs_buildtools.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.26100 --quiet --wait --norestart
  ```
  Mesmo mínimo, é um instalador grande e demorado da Microsoft — avise
  o dev antes de rodar, para não parecer que travou.

**Linux: Clang**
- Detectar: `clang --version` no PATH.
- Instalar: `apt install clang` (Debian/Ubuntu) ou `dnf install clang`
  (Fedora).

**macOS: Xcode Command Line Tools**
- Detectar: `xcode-select -p`.
- Instalar: `xcode-select --install`.

Fontes: [FAQ oficial do Odin](https://odin-lang.org/docs/faq/),
[Getting Started](https://odin-lang.org/docs/install/),
[IDs de componente do VS Build Tools](https://learn.microsoft.com/en-us/visualstudio/install/workload-component-id-vs-build-tools?view=visualstudio),
[componentes mínimos do cl.exe](https://gist.github.com/aont/f5191dc4699a708bd72e65273921b6a8).

## Emscripten

- **Para quê:** build do alvo web. Não é opcional — a meta do template
  é ter build web na maioria dos jogos, para divulgação no itch.io.
- **Detectar:** `emcc --version` no PATH. Se não responder, antes de
  concluir que está ausente, procure o local conhecido de instalação:
  `C:\emsdk\emsdk_env.bat` existe (Windows) ou o equivalente
  `emsdk_env.sh`/clone do `emsdk` (Linux/macOS)? Se existir, está
  **instalado mas fora do PATH** desta sessão — não ausente (ver nota
  abaixo sobre propagação no Windows).
- **Instalar:** clonar `emsdk`, rodar `emsdk install latest` e
  `emsdk activate latest --permanent` (grava `PATH`/`EMSDK` no registro
  do usuário, no Windows).
- Passa de 1 GB — avise o dev antes de rodar.
- **Windows — `PATH` permanente só aparece em terminais abertos *depois*
  da instalação** (confirmado empiricamente em 2026-10-01): o `emsdk
  activate --permanent` grava corretamente no registro
  (`[Environment]::GetEnvironmentVariable` confirma na hora), mas
  qualquer shell que já estava aberto antes da instalação continua com
  o retrato antigo do ambiente — reiniciá-lo não ajuda, só abrir um de
  verdade depois. Isso vale tanto para janelas "normais" quanto
  "administrador"; a diferença observada entre as duas não era sobre
  elevação, era sobre qual das duas por acaso tinha sido aberta mais
  recentemente. Shells de vida longa que ficam fáceis de confundir com
  "terminal novo" porque continuam rodando em segundo plano: uma janela
  de Git Bash que já estava aberta, ou o shell interno de uma sessão do
  Claude Code/outra IDE — nenhum dos dois é um "terminal novo" de
  verdade mesmo que o comando pareça recente. Se `check` reportar
  Emscripten ausente mas o dev confirmar que instalou: peça pra abrir
  uma janela de `cmd`/PowerShell literalmente nova (Win+R ou menu
  Iniciar) e testar `emcc --version` ali antes de concluir que a
  instalação falhou.
  - **Workaround pontual, se não quiser abrir um terminal novo:** rodar
    `C:\emsdk\emsdk_env.bat` no início da sessão (define `PATH`/`EMSDK`
    só para aquele processo, dura só enquanto ele ficar aberto). É a
    alternativa oficial do próprio emsdk ao `--permanent`, mas não
    substitui o `PATH` permanente — é só pra não precisar fechar o
    terminal atual.

## OLS (Odin Language Server) + extensão do VS Code

- **Para quê:** autocomplete e IntelliSense do Odin no editor.
- **Detectar:** extensão `DanielGavin.ols` instalada (`code
  --list-extensions`, se o comando `code` estiver no PATH).
- **Instalar:** `code --install-extension DanielGavin.ols`. A extensão
  baixa o binário do OLS sozinha (bootstrap próprio, testado
  empiricamente) — não precisa clonar nem compilar nada.
  - Fallback manual, só se o bootstrap da extensão falhar (ex.: sem
    internet no primeiro uso): clonar
    https://github.com/DanielGavin/ols e rodar `build.bat`/`build.sh`.
- **Se o comando `code` não estiver no PATH:** verifique se o VS Code
  está instalado em local conhecido da plataforma antes de concluir que
  falta instalar o editor — pode só faltar a opção "Shell Command:
  Install 'code' command in PATH" na paleta de comandos do VS Code.
