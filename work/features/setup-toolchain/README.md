# Comando de setup da toolchain

- **Tipo:** features
- **Status:** concluída
- **Criada em:** 2026-09-30
- **Atualizado em:** 2026-10-01 (sessão 2)

## Objetivo

Criar uma skill `setup` com duas operações irmãs: `check`, que verifica se
a toolchain necessária para desenvolver e buildar o jogo está instalada e
funcionando, e `install`, que instala e configura o que falta.

A meta maior é poder distribuir o workspace leve e deixar um PC novo pronto
para desenvolver rodando um comando.

## Contexto

Nada no workspace verifica a toolchain hoje. Isso bloqueia o passo 5 da
regra principal do `CLAUDE.md` ("depois, analise o resultado"): sem
conseguir compilar, não há resultado para analisar.

Dependências levantadas na conversa: Odin, um linker, Emscripten para o
alvo web, e o OLS (Odin Language Server) + extensão do VS Code para
autocomplete/IntelliSense.

## Estado atual

Concluída em 2026-10-01. A skill `setup` (`check`/`install`) está pronta
e validada de ponta a ponta numa máquina real (Windows).

- A skill `setup` foi criada em
  `.claude/skills/setup/`, seguindo o padrão da `game-work`: `SKILL.md`
  como arquivo mãe (dispatcher + relação entre `check`/`install`),
  `check.md` e `install.md` com o procedimento de cada operação, e
  `dependencies.md` com o conhecimento compartilhado entre as duas.
- `/setup check` testado numa máquina real (Windows): Odin ✅, linker
  (MSVC/Visual Studio) ✅ — confirmado com um build de teste real, não
  só detecção —, OLS + extensão do VS Code ✅, Emscripten ❌ (único
  faltando).
- `/setup install` rodado para o Emscripten: `git clone` do `emsdk` em
  `C:\emsdk`, `emsdk install latest` (SDK 6.0.10, ~700 MB) e `emsdk
  activate latest --permanent` — os três passos terminaram sem erro, e
  o `PATH`/`EMSDK` foram confirmados gravados corretamente no registro
  do usuário (`[Environment]::GetEnvironmentVariable("PATH","User")`).
- **Bloqueio da validação final resolvido de verdade** (confirmado
  empiricamente em 2026-10-01, sessão 2): `emcc --version` funciona
  normalmente num `cmd.exe` genuinamente novo (Win+R → `cmd`), sem
  precisar de administrador nem de `emsdk_env.bat`. A confusão anterior
  veio de testar em shells de vida longa que pareciam "novos" mas não
  eram — uma janela de Git Bash que já estava aberta antes da
  instalação, e o shell interno desta sessão do Claude Code. Nenhum dos
  dois atualiza o `PATH` depois de uma instalação; só um terminal
  realmente aberto depois disso atualiza. A hipótese anterior ("precisa
  ser admin") estava errada — foi coincidência de qual janela por acaso
  era mais recente. `/setup check` já foi ajustado para distinguir
  "ausente" de "instalado mas fora do PATH desta sessão" (ver
  `dependencies.md`).

## Próximo passo

Nenhum. Demanda concluída.

## Decisões

- Raylib não é dependência a instalar: vem dentro da distribuição do Odin
  como `vendor:raylib`. Verificado em `C:\odin\vendor\raylib\`, que tem
  subpastas `windows`, `linux`, `macos`, `macos-arm64` e `wasm` — esta
  última com `libraylib.web.a` e `libraygui.a` prontos para o alvo web.
- `check` e `install` são operações irmãs (`/setup check`, `/setup
  install`), não uma chamando a outra. Aninhar esconderia o `check`, que é
  a operação de uso frequente.
- `check` vem primeiro: é determinística, barata, e já resolve o caso do PC
  novo, que é saber o que falta.
- A toolchain fica **instalada no sistema**, não dentro do repositório.
  Mantém o workspace leve (meta do objetivo) e resolve `PATH` uma vez por
  máquina, compartilhado entre todos os jogos feitos a partir deste
  template — em vez de uma cópia de gigabytes por projeto.
- A distribuição oficial do Odin (site/GitHub oficial) já traz
  `vendor/raylib/` completo para `windows`, `linux`, `macos`,
  `macos-arm64` e `wasm`, incluindo `wasm/libraylib.web.a` e
  `wasm/libraygui.a` prontos — não precisa buildar a Raylib. **Mas**
  pacotes de terceiros (Homebrew, algumas distros Linux) já distribuíram
  esse `wasm/` vazio ou como ponteiro de Git LFS não resolvido. Por isso
  `check` precisa validar a presença real desses dois arquivos (tamanho de
  binário, não só o caminho existir), não só que o Odin está instalado.
  Fontes: [issue #4737](https://github.com/odin-lang/Odin/issues/4737),
  [issue CachyOS #522](https://github.com/CachyOS/distribution/issues/522).
- `check` e o plano do `install` mostram uma tabela — Dependência | Para
  quê | Status — em vez de texto corrido. Raylib não entra como linha
  (não é instalada à parte); vira uma nota abaixo da tabela, pra não
  sugerir ao dev que falta instalar algo que já está resolvido. `install`
  mostra a tabela com o que vai fazer e os comandos, e só executa depois
  de confirmação — instalar coisa no sistema merece esse passo.
- A confirmação final de que o `PATH` pegou é **manual**, não automatizada:
  depois de rodar os comandos, pedimos ao dev para abrir uma janela de
  terminal nova (do sistema operacional, não só uma conversa nova no
  mesmo terminal) e rodar o comando de versão de cada ferramenta (ex.:
  `odin --version`) à mão, reportando o que apareceu. Isso evita depender
  de como o Claude Code gerencia processos internamente — a validação não
  precisa confiar nisso, só no dev ver a versão aparecer num processo
  que com certeza nasceu depois da alteração de `PATH`.
- `install` edita `PATH` persistente, sim, e exige reabrir o terminal —
  isso deixou de ser visto como falha na experiência de "rodou e
  funciona": é o preço aceito pela escolha de instalar no sistema em vez
  de embutir no repositório, e a validação manual (acima) é o jeito de
  fechar esse ciclo com confiança, não uma gambiarra.
- `install` automatiza, sim, um item por vez: mostra o que vai fazer,
  pede permissão, instala, confirma que instalou, e só então passa pro
  próximo item. Não é uma aprovação única pra tudo.
- Linker por plataforma (pesquisa de 2026-09-30, a confirmar
  empiricamente durante a execução): não é gcc em nenhum caso.
  - Windows: MSVC (`link.exe`) + Windows SDK, via Visual Studio Build
    Tools ("Desktop development with C++") — instalador grande e
    demorado da Microsoft, não um pacote simples.
  - Linux: Clang (`apt install clang` / `dnf install clang`).
  - macOS: Xcode Command Line Tools (`xcode-select --install`).

  Fontes: [FAQ oficial do Odin](https://odin-lang.org/docs/faq/),
  [Getting Started](https://odin-lang.org/docs/install/),
  [issue #4922](https://github.com/odin-lang/Odin/issues/4922).
- No Windows, o `install` usa o **Visual Studio Build Tools oficial**
  (workload "Desktop development with C++"), não o script da comunidade
  `portable-msvc.py`. É mais pesado e mais lento, e pode exigir
  interação com o instalador gráfico, mas é o caminho suportado pela
  Microsoft — sem risco de quebrar por mudança externa, diferente do
  script de terceiros. A confirmação desse item no `install` precisa
  avisar explicitamente que é um passo grande e demorado, pra o dev não
  achar que travou (2026-10-01).
- Trocar o linker por `-linker:lld` (LLVM) não elimina a dependência do
  Windows SDK — o `.lib` de import da Raylib e o runtime C ainda vêm da
  Microsoft de um jeito ou de outro. Hoje essa flag no Odin é voltada
  para cross-compilar para Windows a partir de Linux/macOS, não para
  evitar o Visual Studio ao compilar nativamente no Windows; os próprios
  mantenedores chamam isso de incompleto. Não vale perseguir essa via
  agora (2026-10-01). Fontes:
  [PR #7654](https://github.com/odin-lang/Odin/pull/7654),
  [gist portable-msvc.py](https://gist.github.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977).
- A extensão C/C++ do VS Code não traz compilador nem linker — só
  IntelliSense e debug. Ela espera MSVC, Clang ou GCC já instalados.
  Não resolve a dependência de toolchain (2026-10-01).
- Emscripten não é opcional: entra no `install` por padrão. A meta é
  conseguir build web na maioria dos jogos, pra divulgação extra no
  itch.io (2026-10-01).
- OLS (Odin Language Server) entra no escopo do `setup`: dá
  autocomplete/IntelliSense no editor, relevante pro papel de mentor do
  `CLAUDE.md` com um dev iniciante em Odin. A extensão do VS Code
  (`DanielGavin.ols`) tem bootstrap próprio: detecta a plataforma e
  baixa o binário do OLS sozinha (testado empiricamente em 2026-10-01 —
  só instalar a extensão já funciona). `install` só instrui/instala a
  extensão; não precisa clonar nem compilar nada. Fontes:
  [DanielGavin/ols](https://github.com/DanielGavin/ols) (opção
  `ols.server.path` pra binário customizado).
- Clonar e compilar o OLS a partir do código-fonte (`build.bat`/
  `build.sh`) vira **fallback manual**, só orientado se o bootstrap da
  extensão falhar (ex.: sem acesso à internet no primeiro uso) — não é
  parte do fluxo automatizado do `install`.
- `check` distingue, para qualquer dependência da tabela, "não
  instalado" de "instalado mas fora do PATH" — não é específico de
  `code`/`git`. Primeiro tenta achar no PATH; se não achar, verifica
  locais de instalação conhecidos antes de concluir que está ausente.
  Se realmente ausente, `install` oferece instalar (com permissão). Se
  instalado mas fora do PATH, oferece corrigir o PATH (com permissão),
  sem reinstalar à toa.

- No Windows, `install` grava o `PATH`/`EMSDK` do Emscripten de forma
  permanente (`--permanent`) e isso funciona — a causa raiz do que
  parecia um problema de propagação era testar em shells de vida longa
  (Git Bash já aberto, shell interno de uma sessão de IDE/Claude Code),
  não um problema real do Windows. `dependencies.md` documenta essa
  ressalva para não gerar falso alarme de novo (2026-10-01).

## Perguntas em aberto

Nenhuma. Todas as perguntas foram respondidas na conversa de
2026-09-30/2026-10-01 (decisões acima).

## Documentos

- `.claude/skills/setup/SKILL.md`
- `.claude/skills/setup/check.md`
- `.claude/skills/setup/install.md`
- `.claude/skills/setup/dependencies.md`

## Evidências

- <nenhuma ainda>
