# Dependências

Define o que cada dependência é, para quê serve, como detectar, como
instalar e como descobrir sua versão. Usado por `check.md`,
`install.md` e `update.md` — não duplique esta informação neles.

Linhas marcadas como **testado empiricamente** foram verificadas numa
máquina real, na data indicada. Linhas marcadas como **não testado**
são o caminho documentado pelo projeto upstream, ainda sem verificação
nossa — trate-as como hipótese a confirmar na primeira execução.

## Odin

- **Para quê:** compilador da linguagem. A Raylib já vem embutida
  (`vendor:raylib`) — não é dependência separada.
- **Detectar:** `odin version` no PATH.
- **No alvo web:** confirme que `vendor/raylib/wasm/` tem os binários
  da Raylib (`libraylib.a` ou `libraylib.web.a`, e `libraygui.a`) com
  tamanho de binário real — não um ponteiro de Git LFS nem pasta vazia.
  O nome exato varia por versão do Odin — verifique pela existência e
  tamanho, não por um nome fixo. Dois pontos de dado, ambos testados
  empiricamente: em `dev-2026-03` (2026-10-01) eram `libraylib.a` e
  `libraygui.a`, ~1.3 MB e ~188 KB; em `dev-2026-09` (2026-10-03) são
  `libraylib.web.a` (1.360.242 bytes) e `libraygui.a` (188.456 bytes) —
  o nome do primeiro mudou entre as duas versões. Pacotes de terceiros (Homebrew,
  algumas distros Linux) já distribuíram isso quebrado; a distribuição
  oficial não tem esse problema.
- **Instalar:** baixar a distribuição oficial em
  https://odin-lang.org/docs/install/ (não um pacote de terceiros) e
  adicionar ao PATH.
- **Onde a instalação vive:** resolva o diretório pelo `odin` do PATH,
  não por um caminho fixo. `ODIN_ROOT` pode não estar definido no
  ambiente (testado empiricamente em 2026-10-03: não estava, e o Odin
  funcionava normalmente pelo PATH).
- **Forma da instalação:** a pasta tem `.git/` → é um clone da fonte,
  compilado localmente; não tem → é uma release extraída. A forma
  suportada é a release; o clone é uma divergência a migrar. Distinga
  antes de qualquer atualização — as duas leem a versão instalada de
  formas diferentes (testado empiricamente em 2026-10-03).
- **Versão instalada:** numa release, `odin version` reporta a tag da
  release e basta. Num clone compilado da fonte, `odin version` reporta
  a última tag alcançada e **esconde os commits depois dela** — ali a
  leitura confiável é `git describe --tags` no diretório da instalação
  (testado empiricamente em 2026-10-03: `odin version` dizia
  `dev-2026-03:44b50eab9` enquanto `git describe --tags` dizia
  `dev-2026-03-228-g44b50eab9`, 228 commits de diferença).
- **Comparar instalada com disponível: normalize antes.** O binário de
  uma release reporta um sufixo que a tag não tem — a tag `dev-2026-09`
  instalada reporta `dev-2026-09-nightly:a2fb372` (testado
  empiricamente em 2026-10-03). Comparar as strings inteiras daria
  "desatualizado" para sempre. Compare só o prefixo `dev-AAAA-MM`.
- **Versão disponível:** peça o redirect de
  https://github.com/odin-lang/Odin/releases/latest — o cabeçalho
  `Location` da resposta 302 termina na tag da última release. Não use
  `api.github.com`: nesta máquina ele estava inalcançável na porta 443
  enquanto `github.com`, `raw.githubusercontent.com` e
  `objects.githubusercontent.com` respondiam normalmente (testado
  empiricamente em 2026-10-03). O caminho do redirect não depende da
  API e é mais barato.
- **Qual arquivo baixar:** o padrão dos assets é
  `odin-<os>-<arch>-<tag>`, com `.zip` no Windows e `.tar.gz` no Linux e
  macOS — ex.: `odin-windows-amd64-dev-2026-09.zip` (testado
  empiricamente em 2026-10-03; a lista completa da release trazia
  `windows-amd64`, `linux-amd64`, `linux-arm64`, `macos-amd64` e
  `macos-arm64`). A lista de uma release está em
  `https://github.com/odin-lang/Odin/releases/expanded_assets/<tag>`.
  - **Armadilha:** a release também traz `<tag>.zip` e `<tag>.tar.gz`,
    que são os arquivos de código-fonte gerados pelo GitHub, não o
    compilador compilado. Selecione pelo prefixo
    `odin-<os>-<arch>-`, nunca só pela extensão.
- **Layout interno do zip:** tudo vem dentro de uma pasta de topo
  `dist/` — não na raiz do arquivo (testado empiricamente em 2026-10-03
  no `odin-windows-amd64-dev-2026-09.zip`, 148 MB, 2270 entradas, todas
  sob `dist/`). O que vira o diretório de instalação é o **conteúdo** de
  `dist/`, não a pasta `dist/` em si.
- **Atualizar:** renomeie a instalação atual (ex.:
  `<dir>.bak-<versão antiga>`), extraia a release nova no caminho
  original e preserve o backup até o dev confirmar que o jogo compila.
  Manter o caminho original é o que dispensa mexer no PATH.
  - O `ols.exe` pode viver dentro da pasta do Odin e ser o OLS que o
    PATH resolve (testado empiricamente em 2026-10-03). Nesse caso a
    troca o remove do PATH: deixe a extensão `DanielGavin.ols` baixar o
    binário dela de novo e confirme o autocomplete, em vez de copiar o
    binário antigo de volta — ele foi compilado contra a versão antiga.

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
- **Versão instalada:** `emcc --version`, ou
  `upstream/emscripten/emscripten-version.txt` dentro do diretório do
  `emsdk` quando o `emcc` não estiver no PATH desta sessão (testado
  empiricamente em 2026-10-03: o arquivo continha `"6.0.10"`).
- **Atualizar: não coberto por `/setup update`.** Quem atualiza é o
  próprio `emsdk` — `emsdk install latest` seguido de `emsdk activate
  latest --permanent` (o `emsdk` é um clone git, então um `git pull`
  nele antes atualiza a lista de versões disponíveis). Isso fica como
  referência, **não testado por nós**: o `activate --permanent`
  reescreve o `PATH` no registro do usuário, e não houve máquina onde
  validar isso sem arriscar um `PATH` de trabalho. Os hosts que o
  `emsdk` usa (`storage.googleapis.com`, `raw.githubusercontent.com`,
  `registry.npmjs.org`) estavam alcançáveis em 2026-10-03.
- Depois de um update, a nota abaixo sobre propagação do `PATH` no
  Windows vale igual à da instalação inicial.
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
