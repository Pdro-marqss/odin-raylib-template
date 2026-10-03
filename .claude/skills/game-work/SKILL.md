---
name: game-work
description: Gerencia o ciclo de vida das demandas de desenvolvimento do jogo.
disable-model-invocation: true
argument-hint: "new <tipo> <nome> | start|resume|close <nome> | list"
---

# Game Work

Gerencia o ciclo de vida de uma demanda em `work/`.

## Operações

| Comando | Função | Procedimento | Lê `reference.md` |
|---|---|---|---|
| `new` | Cria uma demanda em rascunho | `new.md` | sim |
| `start` | Inicia uma demanda | `start.md` | não |
| `resume` | Retoma uma demanda | `resume.md` | só se for rascunho |
| `close` | Conclui uma demanda | `close.md` | sim |
| `list` | Lista as demandas e seus status | `list.md` | não |

Leia somente o arquivo da operação solicitada.

`reference.md` define o vocabulário, os tipos e o ciclo de vida. Ele é
lido quando a operação exige julgamento: escolher o tipo de uma demanda
nova, continuar formando um rascunho, ou decidir o que promover para
`docs/`.

## Tipos e status

Tipos: `features`, `improvements`, `bugs`, `experiments`, `refactors`.

Status: `rascunho`, `execução`, `concluída`.

As definições estão em `reference.md`.

## Localização

Uma demanda vive em `work/<tipo>/<slug>/` e é identificada pelo nome da
sua pasta.

Para `start`, `resume` e `close`, procure a demanda nas pastas de tipo
dentro de `work/`, ignorando arquivos e pastas fora delas.

Se o nome informado não identificar exatamente uma demanda:

- mostre as demandas com nomes semelhantes;
- peça confirmação;
- não altere nenhuma demanda.

## Contexto

O brief — o `README.md` da demanda — é o ponto de entrada de qualquer
demanda existente.

1. leia o brief;
2. leia apenas os documentos referenciados por ele que a tarefa exigir;
3. consulte `docs/` somente quando houver documentação relevante;
4. leia apenas o contexto necessário para o próximo passo.

Não carregue todo o conteúdo de `work/` ou `docs/`.

## Manter o brief atualizado

O brief é o que atravessa sessões, máquinas e contextos. Enquanto a
demanda não estiver concluída, mantenha-o vivo.

`Estado atual` deve responder: onde estamos, o que já foi concluído e
qual é o próximo passo.

Atualize `Estado atual` sempre que:

- uma etapa importante for concluída;
- uma decisão relevante for tomada;
- surgir uma mudança de direção;
- o trabalho for interrompido.

Na mesma edição, atualize `Atualizado em` com a data de hoje. Uma data
que não acompanha o estado mente com confiança.

Registre em `Decisões` as decisões relevantes e o motivo de cada uma.

Registre em `Perguntas em aberto` as dúvidas que ainda faltam resolver.
Quando uma pergunta for respondida, remova-a e registre a decisão
correspondente quando ela for relevante.

Registre em `Documentos` os documentos criados dentro da demanda, e em
`Evidências` o material de apoio guardado em `evidences/`.
