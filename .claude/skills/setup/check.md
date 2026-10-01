# Verificar toolchain

Mostra o que já está instalado, o que falta, e o que está instalado mas
fora do PATH.

## Entrada

`/setup check`

## Procedimento

1. Leia `dependencies.md` para saber o que verificar e como.

2. Para cada dependência da lista, verifique nesta ordem:
   - está no PATH? (o comando de versão responde?)
   - se não, está instalado em algum local conhecido da plataforma,
     mas fora do PATH?
   - se não achar de nenhum jeito, está ausente.

3. Monte uma tabela:

   | Dependência | Para quê | Status |
   |---|---|---|
   | Odin | compilar o jogo | ✅ / ⚠️ fora do PATH / ❌ ausente |
   | Linker | linkar o executável | ... |
   | Emscripten | build para o alvo web | ... |
   | OLS + extensão do VS Code | autocomplete no editor | ... |

   Raylib não entra como linha — vem embutida no Odin (`vendor:raylib`).
   Diga isso numa nota abaixo da tabela, não como item a instalar.

4. Abaixo da tabela, resuma em uma frase o que fazer a seguir: nada
   (tudo ok), ou rodar `/setup install` (há o que instalar ou
   configurar).

## Resultado

Informe:

- a tabela de status;
- o que falta ou está mal configurado, em uma frase;
- se aplicável, que `/setup install` resolve o resto.
