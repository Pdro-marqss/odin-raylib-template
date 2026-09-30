# Listar demandas

Mostre as demandas que existem em `work/` e o estado de cada uma.

## Entrada

`/game-work list [estado | tipo]`

O filtro é opcional.

## Procedimento

1. Leia apenas o cabeçalho dos briefs em `work/<tipo>/<slug>/README.md`,
   das linhas `**Tipo:**` a `**Atualizado em:**`. Não leia o corpo.

2. Se um filtro foi informado, considere somente as demandas que
   correspondem ao estado ou ao tipo pedido.

## Resultado

Agrupe por estado, na ordem `rascunho`, `execução`, `concluída`. Para cada
demanda, mostre o tipo, o nome e a data de `Atualizado em`.

Se não houver demandas, informe.
