<!--
  Cole esta seção no CLAUDE.md do projeto e troque o que está entre <…>.
  A política completa, com o porquê de cada regra: versoes-e-lancamentos.md, no repositório dev-regras.
-->

## Versões e lançamentos — vale sempre; leia antes de qualquer tag, publicação ou produção

Versão é `<prefixo>X.Y.Z` (SemVer), e quem diz o número é o `CHANGELOG.md`.

1. **Mudou comportamento → uma linha em `[Não lançado]` no CHANGELOG, na mesma entrega**, na língua
   de quem usa e no grupo certo (Acrescentado, Modificado, Corrigido, Removido, Segurança). Mudança
   de banco diz o número da migração.
2. **O número sai do changelog, não de palpite.** Só Corrigido ou Segurança → sobe o último número;
   qualquer Acrescentado ou Modificado → sobe o do meio; quebrou o que funcionava → ⚠️ em
   Modificado e sobe o primeiro (na série 0.x, o do meio).
3. **Lançar pequeno e com frequência; correção não espera funcionalidade.** Com mais de uma semana
   ou um punhado de PRs desde a última tag, proponha ao dono fechar uma versão.
4. **Como lançar**, nesta ordem:
   1. `main` verde na CI;
   2. num PR, renomeie `[Não lançado]` para `## [X.Y.Z] — AAAA-MM-DD`, abra um `[Não lançado]`
      vazio acima dela, e faça o merge;
   3. `make lancar VERSAO=<prefixo>X.Y.Z RESUMO='…'` (confere a seção datada, a árvore limpa e o
      commit no GitHub, e cria a tag anotada com as notas);
   4. a imagem `<app>:<prefixo>X.Y.Z` é publicada (pela CI ou por `<alvo de publicação>`);
   5. a mesma imagem passa pela homologação e depois vai para a produção. A produção nunca compila.
5. **Correção urgente com a `main` à frente**: saia da tag que está no ar
   (`git switch -c correcao/<prefixo>X.Y.Z+1 <prefixo>X.Y.Z`), corrija com teste, date a seção
   dessa versão no CHANGELOG da linha, faça push e lance dela. Depois leve a linha de volta para a
   `main` (merge da linha na `main`, nunca o contrário).
6. **Voltar de versão** é apontar para a tag anterior. Com migração no meio, voltar exige restaurar
   o banco, e é por isso que o changelog diz a migração.
7. **Nunca**: tag sem seção datada no CHANGELOG, imagem de árvore suja, `latest` em produção, ou
   mover/apagar uma tag publicada. Se uma versão saiu errada, a correção é a próxima versão.
