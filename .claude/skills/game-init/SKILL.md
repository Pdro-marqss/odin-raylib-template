---
name: game-init
description: Preenche a ideia central do jogo (docs/concept.md) e prepara o template para um projeto novo.
disable-model-invocation: true
---

# Game Init

Preenche `docs/concept.md` — a ideia central do jogo: nome, pitch, estilo,
mecânicas e escopo — e prepara o repositório clonado do template para esse
jogo específico.

Diferente de uma demanda em `work/`, o conceito não tem ciclo de vida: ele
nasce aqui e continua editável pela vida inteira do projeto.

## Modo

Verifique se `docs/concept.md` já existe.

- **Não existe** → modo criação (completo, abaixo).
- **Já existe** → modo refinamento (abaixo).

## Modo criação

1. **Conversa aberta.** Peça ao desenvolvedor para discorrer livremente
   sobre a ideia do jogo: do que se trata, o nome (se já tiver), o que
   inspirou. Não interrompa com perguntas fechadas nessa fase — deixe a
   ideia ser contada antes de categorizá-la.

2. **Afunilamento.** Depois que o desenvolvedor discorrer, faça perguntas
   específicas só no que ainda não ficou claro e for pertinente para o
   `concept.md`: pitch, estilo/referências, mecânicas centrais,
   escopo/ideias. Não pergunte por pergunta — só o que falta para
   preencher o documento.

3. **Preencha `docs/concept.md`** a partir de
   `.claude/skills/game-init/templates/concept.md`. Preencha o título com
   o nome do jogo e `Atualizado em` com a data de hoje. Preencha cada
   seção só com o que a conversa produziu — não invente conteúdo. Deixe
   vazio o que ainda não foi discutido.

   Em `docs/README.md`: adicione a linha de `concept.md` na tabela e
   remova o parágrafo "Ainda não há documentação permanente..." — deixou
   de ser verdade.

4. **Verifique poluição de template.** Veja se há:
   - demandas em `work/<tipo>/` (pastas além dos `.gitkeep`);
   - linhas na tabela de `docs/README.md` além da que você acabou de
     criar para `concept.md`.

   Se houver, liste exatamente o que seria removido e peça confirmação
   antes de apagar qualquer coisa. Não apague nada sem confirmação.

   Ao confirmar: apague as demandas (mantendo as pastas de tipo) e
   quaisquer documentos de `docs/` que não sejam `concept.md`, limpando
   suas linhas da tabela.

5. **Atualize o `README.md` da raiz:**
   - troque o título e a descrição do topo pela identidade do jogo
     (nome + pitch curto, vindos do `concept.md`);
   - remova a seção "Começar um jogo a partir deste template" — ela é
     instrução de bootstrap e não se aplica mais depois de rodar;
   - não toque em `Estrutura`, `Fluxo de trabalho` nem `Build`: descrevem
     o workspace, não o jogo, e `Build` é escopo de uma demanda própria
     de toolchain.

6. Informe o resultado: o que foi criado, atualizado e removido.

## Modo refinamento

1. Leia o `docs/concept.md` atual.
2. Pergunte o que mudou ou o que o desenvolvedor quer revisar.
3. Atualize só as seções relevantes e o `Atualizado em`. Não invente
   conteúdo além do que a conversa produziu.
4. Não repita a limpeza de `work/`/`docs/` nem a edição do `README.md` —
   isso já foi feito na criação. Se o desenvolvedor pedir explicitamente,
   ofereça rodar a verificação de poluição de novo.
