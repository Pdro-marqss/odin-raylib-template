# Game Work

Este documento define o **vocabulário** e o **modelo de demandas** do
projeto.

O procedimento de cada operação fica nos arquivos da skill `game-work`.

## Como as peças se conversam

```text
conversa  →  /game-work new    →  rascunho
                                  o brief nasce com o que a conversa produziu

          →  /game-work start  →  execução
                                  o brief registra o estado e o próximo passo

          →  /game-work close  →  concluída
                                  o que continua valendo vai para docs/
```

- `work/` guarda **como o trabalho foi feito**, e é temporário.
- `docs/` guarda **como o jogo funciona**, e sobrevive ao fechamento.
- O **brief** é o que atravessa sessões, máquinas e contextos.
- Este documento define os conceitos; o `SKILL.md` e os arquivos de
  operação definem o procedimento.

## Vocabulário

**Demanda**
Uma unidade de trabalho do desenvolvimento, do início ao fechamento.
Vive em `work/` e é identificada pelo nome da sua pasta.

**Brief**
O `README.md` da demanda. É o registro principal e o primeiro arquivo
lido para retomar o trabalho.

**Sistema**
Uma parte funcional do jogo com comportamento próprio, como input,
player, câmera, áudio ou save.

**Evidência**
Material usado durante a demanda para apoiar uma decisão, como imagens,
referências, logs, medições ou capturas de tela. Fica em `evidences/`
dentro da demanda e não faz parte da documentação permanente por padrão.

**Documentação permanente**
Conhecimento que continua válido depois que a demanda é concluída.
Vive em `docs/`.

## Tipos de demanda

O tipo é definido pela **relação da demanda com o que já existe**:

| Antes → depois | Tipo | Pasta |
|---|---|---|
| não existe → existe | funcionalidade nova | `work/features/` |
| existe → melhor | melhoria do que já existe | `work/improvements/` |
| errado → correto | correção de comportamento | `work/bugs/` |
| não se sabe → se sabe | investigação ou protótipo | `work/experiments/` |
| igual por fora, diferente por dentro | mudança estrutural | `work/refactors/` |

Na criação de uma demanda, a pergunta que define o tipo é:
**isso já existe?**

### Fronteiras que confundem

**`improvements` e `refactors`**
`improvements` muda o comportamento para melhor. `refactors` não muda o
comportamento. Se o jogador percebe a diferença, é `improvements`.

**`improvements` e `features`**
Se o sistema ainda não existe, é `features`. Ajustar um sistema que já
existe nunca é `features`, mesmo quando o ajuste é grande.

**`experiments`**
O entregável é uma **resposta**, não código. Um experimento que termina
em "não vamos fazer isso" foi um sucesso. O código de um experimento é
descartável por natureza.

### Performance

Uma demanda de performance é uma `improvements`.

Quando a demanda for de performance, o brief precisa registrar:

- em `Objetivo`, a meta;
- em `Estado atual`, a medição inicial e, no fechamento, a final.

Sem medição não há como saber se a demanda cumpriu o objetivo.

### Conteúdo

Não existe um tipo para autoria de conteúdo (níveis, inimigos,
diálogos). Essa decisão deve ser revista quando houver sistemas do jogo
prontos para autorar.

## Ciclo de vida

Uma demanda passa por três status:

1. **rascunho**
   - A ideia está sendo formada.
   - O brief registra o objetivo, o contexto e o que ainda falta decidir.
   - Ainda não existe execução.

2. **execução**
   - O trabalho está acontecendo.
   - O brief registra o estado atual e o próximo passo.

3. **concluída**
   - A demanda foi concluída ou encerrada.
   - O conhecimento que continua válido foi promovido para `docs/`.

Uma demanda interrompida continua em `execução`. O que permite retomá-la
é o `Próximo passo` do brief, não um status separado.

A demanda concluída permanece em `work/` como histórico e não é
reaberta: ela pode ter originado documentação permanente, e continuar
mexendo nela tornaria inconsistente a origem desse documento. Trabalho
novo sobre o mesmo assunto é uma demanda nova, que referencia a anterior.

## Rascunho

Um rascunho não é uma anotação de intenção: é o registro da conversa que
está formando a demanda.

Enquanto a demanda estiver em `rascunho`, registre no brief:

- em `Objetivo`, o que se pretende, mesmo que provisório;
- em `Decisões`, as alternativas descartadas e o motivo;
- em `Perguntas em aberto`, o que precisa de resposta antes de começar;
- em `Próximo passo`, o que falta para a demanda entrar em execução.

Uma conversa sobre um rascunho que não chega ao brief não sobrevive à
troca de sessão, de máquina ou de contexto. O brief é o que atravessa.

## Brief

A estrutura do brief é definida pelo template usado na criação da
demanda: `templates/brief.md`.

O brief deve ser curto e não deve acumular documentação técnica
desnecessária.

Quando uma informação precisar ser detalhada, crie um documento
específico dentro da demanda e referencie-o no brief.

## Documentação da demanda

Uma demanda pode conter documentos adicionais conforme necessário.

Exemplo:

```text
work/features/player-movement/
├── README.md
├── architecture.md
├── implementation.md
└── evidences/
```

Não crie documentos vazios apenas para preencher uma estrutura.

Crie documentação somente quando houver conteúdo que justifique um
arquivo separado.

## Documentação permanente

`work/` registra **como o trabalho foi feito**.

`docs/` registra **como o jogo funciona** depois que o trabalho terminou.

Ao fechar uma demanda, avalie se ela produziu conhecimento permanente:

- um novo sistema do jogo;
- uma decisão arquitetural;
- uma regra de gameplay;
- um valor afinado e o motivo dele;
- uma solução técnica importante;
- uma mudança na ideia central do jogo (mecânica central, escopo ou
  nome) — atualize `docs/concept.md` e seu `Atualizado em`.

Quando houver conhecimento permanente:

1. crie ou atualize o documento apropriado em `docs/`;
2. adicione ou atualize sua entrada em `docs/README.md`;
3. mantenha o brief focado no histórico e no estado da demanda.

Se não houver conhecimento a preservar, não crie documentação permanente.
