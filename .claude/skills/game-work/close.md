# Fechar demanda

Conclua uma demanda de `work/` e preserve o conhecimento que continua
válido.

## Entrada

`/game-work close <nome>`

## Procedimento

1. Localize a demanda e leia o brief.

2. Leia os documentos referenciados pelo brief que forem necessários para
   entender o resultado.

3. Avalie o que a demanda produziu de conhecimento permanente, usando os
   critérios de `reference.md`.

4. Se houver conhecimento permanente:
   - crie ou atualize o documento apropriado em `docs/`;
   - mantenha o documento objetivo;
   - atualize `docs/README.md`;
   - não copie o histórico da demanda para `docs/`.

   Se não houver, não crie documentação permanente.

5. Se a demanda for de performance, registre a medição final no brief.

6. Atualize o brief:
   - `Status` para `concluída`;
   - `Estado atual` com o resultado final;
   - `Próximo passo` indicando que não há trabalho pendente;
   - registre as decisões finais;
   - remova as perguntas que foram respondidas;
   - referencie os documentos permanentes criados.

## Resultado

Informe:

- qual demanda foi fechada e o resultado final;
- quais documentos permanentes foram criados ou atualizados, ou que
  nenhum foi necessário.

O fechamento registra o resultado e preserva conhecimento. Não implemente
mudanças durante o fechamento.

A demanda permanece em `work/` como histórico.
