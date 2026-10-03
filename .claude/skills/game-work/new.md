# Nova demanda

Crie uma nova demanda em `work/`, com status `rascunho`.

## Entrada

`/game-work new <tipo> <nome>`

- `<tipo>` é um dos tipos definidos em `reference.md`.
- `<nome>` identifica a demanda.

## Procedimento

1. Valide o tipo contra a tabela de tipos do `reference.md`.
   Se o tipo não foi informado ou não existir, use a pergunta que define
   o tipo — **isso já existe?** — para propor um e peça confirmação.

2. Converta o nome para um slug:
   - letras minúsculas;
   - espaços viram `-`;
   - remova acentos e caracteres desnecessários.

3. Se `work/<tipo>/<slug>/` já existir, não sobrescreva: informe o
   usuário e peça confirmação.

4. Crie `work/<tipo>/<slug>/README.md` a partir de `templates/brief.md`.

5. Preencha o cabeçalho do brief: título, tipo, status `rascunho` e as
   duas datas com a data de hoje.

6. Preencha `Objetivo`, `Contexto`, `Decisões` e `Perguntas em aberto`
   com o que a
   conversa já produziu. Deixe vazio o que ainda não foi discutido — não
   invente conteúdo.

7. Não crie documentos adicionais.

## Resultado

Informe:

- caminho da demanda;
- título;
- tipo;
- status: rascunho.

## Início da execução

A demanda entra em execução de duas formas:

- o usuário roda `/game-work start <nome>`;
- o Claude pergunta se pode iniciar e o usuário confirma.

Não inicie a implementação por iniciativa própria.
