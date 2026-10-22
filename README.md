# dev-regras

Regras de trabalho para projetos de software, escritas para serem seguidas por pessoas e por
agentes de IA (Claude Code e similares). Começa por **versões e lançamentos**: como numerar,
registrar, marcar e levar uma versão para produção sem perder o controle do que está no ar.

As regras vêm da prática em projetos reais e de projetos abertos que fazem isso bem. A principal
referência é o [ai-memory](https://github.com/akitaonrails/ai-memory), do Fabio Akita.

## O que tem aqui

| Arquivo | Para quê |
|---|---|
| [`versoes-e-lancamentos.md`](versoes-e-lancamentos.md) | a política completa, com o porquê de cada regra |
| [`modelos/CHANGELOG.md`](modelos/CHANGELOG.md) | changelog inicial para copiar num projeto novo |
| [`modelos/CLAUDE-versoes.md`](modelos/CLAUDE-versoes.md) | a seção para colar no `CLAUDE.md` de um projeto |
| [`modelos/lancar.mk`](modelos/lancar.mk) | o alvo `make lancar`, que só cria a tag quando tudo está em ordem |
| [`modelos/ci.yml`](modelos/ci.yml) | esqueleto de CI no GitHub Actions: portões em todo PR e aviso de changelog |

## Como usar num projeto

1. Copie `modelos/CHANGELOG.md` para a raiz do projeto e preencha `[Não lançado]`.
2. Cole `modelos/CLAUDE-versoes.md` no `CLAUDE.md` do projeto, trocando os nomes entre `<…>`.
   O `CLAUDE.md` é lido automaticamente pelo Claude Code em toda sessão, então a regra passa a
   valer sempre, sem ninguém precisar lembrar.
3. Traga o alvo de `modelos/lancar.mk` para o `Makefile` e ajuste o prefixo da tag.
4. Adapte `modelos/ci.yml` aos comandos de teste do projeto.

## Resumo em uma tela

- **O número da versão sai do changelog**, não de palpite: só correção sobe o último número,
  qualquer novidade sobe o do meio, e quebrar o que funcionava sobe o primeiro.
- **Todo PR que muda comportamento acrescenta uma linha** em `[Não lançado]`, na língua de quem
  usa o sistema.
- **Lance pequeno e com frequência.** Correção não espera funcionalidade nova.
- **Versão é uma tag anotada**, e tag publicada nunca se move nem se apaga.
- **Produção nunca compila**: puxa uma imagem com a versão no nome. Nada de `latest`.
- **Correção urgente sai de uma linha criada a partir da tag que está no ar**, e depois volta para
  a `main`.
- **Voltar de versão é apontar para a tag anterior**, desde que a migração de banco permita. Por
  isso o changelog diz cada migração.

## Licença

[MIT](LICENSE): use, copie e adapte à vontade, mantendo o aviso de copyright.
