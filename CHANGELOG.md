# Changelog

O que muda nas regras e nos modelos a cada versão. O formato segue o
[Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/), e as versões seguem
[SemVer](https://semver.org/lang/pt-BR/).

## [Não lançado]

### Acrescentado

- Política de versões e lançamentos (`versoes-e-lancamentos.md`): o número decidido pelo
  changelog, lançar pequeno, tag anotada que não se move, produção que só puxa imagem versionada,
  linha de correção a partir da tag, volta de versão e CI em todo PR.
- Modelos: `CHANGELOG.md`, a seção para o `CLAUDE.md`, o alvo `make lancar` e um esqueleto de CI.
- Política de revisão e aprovação (`revisao-e-aprovacao.md`): o autor responde por cada linha, PR
  pequeno com revisão por IA antes da humana, uma aprovação em rodízio, teste que morde, rótulos
  nos comentários, bloqueio leve resolvido pelo revisor, comentário final com o que foi conferido,
  merge pelo autor, e a configuração da `main` no GitHub e no GitLab, com o que cada plano do
  GitLab deixa impor.
- Política de trabalho com agentes de IA (`agentes-de-ia.md`): um arquivo de regras para os
  agentes do time, escopo e plano antes do código, portões antes de "pronto", o que o agente nunca
  faz sem pedido, um worktree por agente, isolamento para o modo sem confirmação, texto de fora
  como dado.
- Modelos: descrição de PR (para GitHub e GitLab), as seções de revisão e de agentes para o
  `CLAUDE.md`, um sub-agente revisor para o Claude Code, e o esqueleto de CI também no GitLab CI
  (`modelos/ci-gitlab.yml`). O de GitHub Actions passou a se chamar `modelos/ci-github.yml` e
  agora roda também nas linhas `correcao/`, de onde sai a tag de uma correção urgente.
