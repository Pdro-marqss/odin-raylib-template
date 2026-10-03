# Atualizar dependência

Atualiza uma dependência da toolchain para a versão mais recente.

## Entrada

`/setup update <dependência>`

Dependências suportadas: `odin`.

As outras não têm `update`:

- o linker é atualizado pelo instalador da plataforma;
- a extensão `DanielGavin.ols` do VS Code atualiza o OLS sozinha;
- o Emscripten tem updater próprio (`emsdk`), mas **ainda não é
  coberto** por este comando. O `emsdk activate latest --permanent`
  reescreve o `PATH` no registro do usuário, e nenhuma máquina estava
  disponível para validar esse caminho sem arriscar um `PATH` de
  trabalho. Até lá, atualize o Emscripten pelos comandos do próprio
  `emsdk` — ver `dependencies.md`.

## Procedimento

1. Se nenhuma dependência foi informada, ou a informada não é
   suportada: diga quais são e pare. Nunca atualize tudo por padrão —
   atualizar a toolchain inteira num comando só juntaria riscos
   independentes numa única aprovação.

2. Leia a seção da dependência em `dependencies.md`.

3. Levante, antes de mexer em nada:
   - a forma da instalação (release, clone da fonte, ausente);
   - a versão instalada — pela forma, não pelo comando de versão sozinho;
   - a versão disponível.

   Se a dependência não estiver instalada, não é caso de `update`:
   informe e sugira `/setup install`.

4. Se a versão instalada já for a disponível: informe e pare. Esse é um
   resultado normal do comando, não uma falha.

5. Mostre o plano e peça permissão. O plano nomeia, com caminhos
   exatos: o que vai ser baixado, o que vai ser renomeado ou movido, o
   que vai ser preservado e onde. Se a forma da instalação divergir da
   suportada, diga o que encontrou e que o plano é migrar para a forma
   suportada — nunca adivinhe o que a pasta é, e nunca sobrescreva sem
   confirmação explícita.

6. Execute o plano aprovado, sem passos extras não mostrados.

7. Confirme que pegou:
   - o comando de versão da ferramenta reporta a versão nova;
   - depois disso, peça ao dev para compilar o jogo — é a confirmação
     que importa, porque é o que uma mudança incompatível quebraria.
   - se a atualização mexeu no `PATH`, a confirmação é manual: peça ao
     dev para abrir uma janela de terminal nova do sistema operacional
     (não uma conversa nova no mesmo terminal) e rodar o comando de
     versão ali.

8. Preserve a instalação antiga até o dev confirmar que a nova funciona.
   Diga onde ela ficou e quanto ocupa, e descarte somente quando ele
   confirmar. Se algo quebrar, o rollback é renomear de volta.

9. Trate os efeitos colaterais que a seção da dependência em
   `dependencies.md` listar — eles existem porque a pasta de uma
   dependência pode conter binários de outra ferramenta.

## Resultado

Informe:

- a dependência, a versão antes e a versão depois;
- onde ficou a instalação antiga, quanto ocupa, e que ela só deve ser
  descartada depois de o jogo compilar;
- o que ficou pendente de confirmação manual do dev;
- se tudo foi concluído, sugira rodar `/setup check` de novo.
