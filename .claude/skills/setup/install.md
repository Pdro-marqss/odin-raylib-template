# Instalar toolchain

Instala e configura o que `/setup check` encontrar como ausente ou fora
do PATH.

## Entrada

`/setup install`

## Procedimento

1. Rode a verificação de `check.md` primeiro (mesma lógica de
   detecção) — não assuma o estado do sistema, confirme antes de agir.

2. Para cada item que não estiver ok, nesta ordem (o linker e o OLS
   dependem do Odin já instalado):

   1. Odin
   2. Linker da plataforma
   3. Emscripten
   4. OLS (extensão do VS Code)

   Para cada item, leia o procedimento dele em `dependencies.md` e:
   - se instalado mas fora do PATH: mostre o comando que corrige o
     PATH, peça permissão, execute;
   - se ausente: mostre o comando ou processo de instalação, peça
     permissão, execute;
   - confirme que o item ficou pronto antes de passar para o próximo;
   - não prossiga para o próximo item sem confirmar o anterior.

3. Linker no Windows (MSVC): use só os componentes mínimos listados em
   `dependencies.md` — nunca a workload completa "Desktop development
   with C++" nem instale extras não pedidos. Avise antes que é um passo
   grande e demorado, para o dev não achar que travou.

4. OLS: oriente só instalar a extensão do VS Code
   (`DanielGavin.ols`) — ela baixa o binário sozinha. Oriente clonar e
   compilar o OLS manualmente (ver `dependencies.md`) somente se o
   bootstrap da extensão falhar.

5. Depois de qualquer edição de PATH, a confirmação final é manual:
   peça ao dev para abrir uma janela de terminal nova do sistema
   operacional (não uma conversa nova no mesmo terminal) e rodar o
   comando de versão da ferramenta, reportando o que apareceu.

## Resultado

Informe:

- o que foi instalado ou corrigido, item por item;
- o que ficou pendente de confirmação manual do dev (reabrir
  terminal);
- se tudo foi concluído, sugira rodar `/setup check` de novo para
  confirmar.
