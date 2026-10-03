# Comando de atualização da toolchain

- **Tipo:** features
- **Status:** concluída
- **Criada em:** 2026-10-01
- **Atualizado em:** 2026-10-03

## Objetivo

Criar a operação `update` na skill `setup`, irmã de `check`/`install`, que
atualiza uma dependência específica da toolchain: `/setup update
<dependência>`.

Usar a atualização do Odin — que traz a Raylib embutida — como primeiro
caso real, testando o comando de ponta a ponta enquanto resolve a
desatualização encontrada na máquina atual.

## Contexto

O Odin instalado está em `dev-2026-03`, bem atrás da versão mais recente
(`dev-2026-09`, lançada 2026-09-01). Entre as versões lançadas desde
então, destaca-se que a Raylib embutida subiu de 5.5 para 6.0 (lançada em
`dev-2026-07`), além de outras mudanças (stack canaries, `-collection`
customizada em `foreign import`, correções de ABI, etc.).

Isso veio à tona durante a retomada da demanda `build-pipeline`, e motivou
a ideia de ter um comando de atualização dentro da skill `setup` — em vez
de atualizar manualmente cada vez que isso for necessário — já que o
template será clonado para todo jogo futuro e a toolchain vai precisar de
manutenção continuada em cada um desses clones.

Segue o padrão estabelecido pela demanda `setup-toolchain` (concluída),
que criou as operações `check` e `install`.

### Como a toolchain estava nesta máquina

O Odin em `C:\odin` era um clone git compilado da fonte, 228 commits
depois da tag `dev-2026-03` — não a distribuição oficial. O
`odin version` escondia esses commits, e o `ols.exe` em uso morava
dentro da pasta do Odin. O Emscripten estava na 6.0.10, instalado pelo
caminho oficial do `emsdk`.

O levantamento completo, os números e tudo o que foi verificado está em
`findings.md`.

A divergência entre a instalação em clone e o `dependencies.md` — que
manda instalar a distribuição oficial — é um achado desta demanda, não
um problema a resolver aqui.

## Estado atual

Concluída em 2026-10-03.

A operação `/setup update odin` existe, está registrada na skill `setup`
e foi validada de ponta a ponta nesta máquina. O Odin saiu de
`dev-2026-03` (clone compilado da fonte, 228 commits depois da tag) para
a release `dev-2026-09`, e a Raylib embutida subiu de 5.5 para **6.0**,
verificada por um programa real que compilou, linkou e imprimiu
`raylib 6.0`. O `PATH` não foi tocado em nenhum momento. O backup
`C:\odin.bak-dev-2026-03` foi apagado em 2026-10-03, depois de o dev
confirmar que o autocomplete do Odin voltou a funcionar.

O escopo caiu de duas dependências para uma durante a execução (ver a
revisão em `Decisões`). Nada ficou pela metade: o que não foi provado
foi deliberadamente deixado de fora e está dito abaixo.

Feito:

1. descoberta de versão em `.claude/skills/setup/dependencies.md`:
   forma da instalação, versão instalada, versão disponível e efeitos
   colaterais do Odin, mais o mecanismo do Emscripten registrado como
   referência não coberta pelo comando;
2. `.claude/skills/setup/update.md` com o procedimento;
3. `update` registrado na tabela de operações, no `argument-hint` e na
   relação entre operações do `SKILL.md` da skill `setup`, e na seção de
   ambiente do `README.md` da raiz.

Rede: **`api.github.com` está inalcançável nesta máquina** (porta 443),
enquanto `github.com`, `objects.githubusercontent.com`,
`raw.githubusercontent.com` e `storage.googleapis.com` respondem. Isso
primeiro pareceu ausência total de rede; na verdade é só esse host. O
desenho contorna: a última tag sai do redirect de
`github.com/.../releases/latest`, sem API.

Com isso, todas as hipóteses da descoberta de versão foram verificadas
e estão registradas como testadas no `dependencies.md`: a última release
é `dev-2026-09`; o asset do Windows é
`odin-windows-amd64-dev-2026-09.zip` (148 MB); o conteúdo do zip vem
todo dentro de uma pasta de topo `dist/`; e a release também traz
`<tag>.zip` de código-fonte, que é a armadilha de selecionar asset só
pela extensão.

### A atualização do Odin (2026-10-03)

Executada e validada: release `dev-2026-09` baixada e instalada em
`C:\odin` mantendo o caminho original, PATH intocado, backup preservado
e depois apagado com a confirmação do dev. Confirmado por
`odin version`, pelos binários da Raylib e por um programa real que
compilou, linkou e imprimiu `raylib 6.0`.

Os passos exatos, os números e os achados que saíram daí estão em
`findings.md`.

### Fica sem prova, por decisão

- O caminho **release → release**, que é o uso normal do comando. Esta
  máquina exercitou a migração clone → release, de uso único, e depois
  dela não sobrou release nova para testar o caminho normal. Espera a
  próxima release do Odin.
- O **Emscripten**, fora do escopo pela revisão acima.

## Próximo passo

Nenhum. A demanda está concluída.

Trabalho novo sobre o mesmo assunto é uma demanda nova, que referencia
esta. Dois assuntos já identificados:

- cobrir o Emscripten no `/setup update`, quando houver uma máquina onde
  validar o `emsdk activate --permanent` sem arriscar um `PATH` de
  trabalho;
- o `install.md` instala o Odin pela distribuição oficial, mas não avisa
  que instalações em clone da fonte existem por aí — o `update` sabe
  reconhecer e migrar, o `install` não comenta.

## Decisões

- O comando se chama `/setup update <dependência>`, terceira operação
  irmã de `check`/`install` — não uma operação que as chama ou é chamada
  por elas.
- **A descoberta da versão disponível mora em `dependencies.md`, por
  dependência; `update.md` guarda só o procedimento.** Motivo: espelha a
  divisão que já existe — `dependencies.md` é onde "como detectar" e
  "como instalar" vivem, e `check.md`/`install.md` não duplicam isso.
  Cada dependência tem um mecanismo próprio de descobrir a versão
  disponível, então isso é conhecimento por dependência, não procedimento.
- **`update` segue o padrão de confirmação do `install`:** mostrar o que
  vai fazer, pedir permissão, executar, confirmar — um item por vez.
  Motivo: já é regra geral da skill, nos "Princípios gerais" do
  `SKILL.md` do `setup`; não é uma escolha nova desta operação.
- **O Odin é padronizado na distribuição binária oficial (zip), não no
  clone da fonte.** `update` baixa a release e troca a pasta. Motivo: é o
  que o `install.md` já manda instalar, não exige rebuild nem as
  dependências de build do compilador em cada máquina nova, e a
  descoberta de versões sai do próprio GitHub — pelo redirect de
  `/releases/latest`, não pela API, que estava inalcançável nesta
  máquina. O clone existente em `C:\odin` é uma divergência a migrar,
  não uma segunda forma suportada.
  - Consequência: a atualização do Odin nesta máquina é também a
    migração de clone para release — e serve como o teste de ponta a
    ponta da operação.
  - Esta decisão é sobre o Odin. O Emscripten tem forma própria e
    oficial (clone do `emsdk` + `emsdk install latest`); "padronizar no
    zip" não se aplica a ele.
- **`update` identifica a forma da instalação e mostra o que encontrou
  antes de mexer, pedindo permissão** — nunca sobrescreve sem
  confirmação explícita, e nunca adivinha o que a pasta é. Motivo:
  apagar às cegas uma pasta que é um clone git destruiria trabalho local
  que o comando não sabe que existe. E num build de `master` o `odin
  version` mente (a instalação atual está 228 commits depois da tag que
  ela reporta); na forma zip não há esse problema, porque um binário de
  release reporta a tag da própria release.
  - A regra é mostrar e pedir, **não parar**. Uma versão anterior desta
    decisão dizia que o comando pararia ao achar uma forma divergente —
    o que o faria recusar exatamente o caso real desta máquina. A
    migração do clone para a release é o fluxo normal do comando com o
    aviso certo, não um caminho separado.
- **A troca mantém o nome `C:\odin`:** a instalação antiga é renomeada
  (ex.: `C:\odin.bak-dev-2026-03`) e a release nova ocupa o caminho
  original. Motivo: o PATH aponta para `C:\odin`, então nada de PATH
  precisa ser mexido — a atualização parece uma substituição no lugar.
- **Rollback: a instalação antiga é preservada renomeada até o dev
  confirmar que a nova funciona** (compilar o jogo), e só então
  descartada. Motivo: é barato na forma zip — é só não apagar a pasta — e
  cobre o risco real de uma versão nova trazer mudança incompatível
  (ex.: a reescrita de `core:os` em `dev-2026-03`).
- **Escopo da primeira versão: Odin e Emscripten.** O OLS fica fora
  porque a extensão `DanielGavin.ols` do VS Code se atualiza sozinha —
  um `update` para ela não resolveria um problema real.
  - **Revisado em 2026-10-03: o escopo caiu para só o Odin.** A decisão
    original foi tomada antes de se saber que a metade do Emscripten não
    poderia ser validada, e o dev recusou validá-la nesta máquina: o
    `emsdk activate latest --permanent` reescreve o `PATH` no registro
    do usuário, e o `PATH` desta máquina deu trabalho para configurar.
    Entregar o caminho não validado seria pior que não entregar — ele
    rodaria depois com a autoridade de um doc que parece verificado.
    O mecanismo do `emsdk` fica registrado no `dependencies.md` como
    referência não coberta pelo comando; cobri-lo é uma demanda futura,
    quando houver uma máquina onde o risco seja aceitável.
  - Ressalva: o OLS não é atualizado pelo comando, mas o update do Odin
    tem efeito colateral nele, porque o `ols.exe` em uso vive dentro da
    pasta do Odin. O procedimento precisa tratar isso. Copiar o binário
    antigo de volta é suspeito — ele foi compilado contra `dev-2026-03`
    e pode não ler o `core` de uma versão nova; a recuperação provável é
    deixar a extensão do VS Code baixar o binário dela de novo,
    confirmando o autocomplete depois da atualização.

## Perguntas em aberto

- <nenhuma>

## Documentos

- `findings.md` — levantamento da máquina, a execução da atualização e
  os achados empíricos que viraram regra na skill `setup`.

Nenhuma documentação permanente foi criada em `docs/`: `docs/` guarda
como **o jogo** funciona, e o que esta demanda produziu é conhecimento
de toolchain, cujo lugar permanente é a própria skill `setup` — que não
é temporária e já está atualizada.

O que a demanda entregou, fora da pasta dela:

- `.claude/skills/setup/update.md` — novo, o procedimento da operação;
- `.claude/skills/setup/dependencies.md` — por dependência: forma da
  instalação, versão instalada, versão disponível, como atualizar e os
  efeitos colaterais;
- `.claude/skills/setup/SKILL.md` — `update` na tabela de operações, no
  `argument-hint` e na relação entre as operações;
- `README.md` da raiz — `/setup update odin` na seção de ambiente.

Os achados empíricos que viraram regra no `dependencies.md` estão
listados em `findings.md`.

## Evidências

- <nenhuma>
