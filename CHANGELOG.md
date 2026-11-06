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
- O padrão dos sistemas internos:
  - **Login e acesso** (`login-e-acesso.md`): provedor da empresa por um pacote compartilhado; quem
    entra começa sem acesso e pede; três papéis; o primeiro admin vem da configuração; acesso por
    grupo; convidados de fora; o papel lido do banco; a sessão; as rotas `/auth/*`; o histórico; o
    desenvolvimento local sem login só quando dito.
  - **Cores** (`cores.md`): a paleta por versão; papéis em vez de hex; claro, escuro e do sistema; a
    faixa da marca; um trabalho por cor de dado; a cor nunca como a única pista.
  - **Interface** (`interface.md`): princípios, medidas, estrutura da tela, botões, chips e menus, a
    barra de pesquisa e filtros das listas, tabelas, formulários, modais, confirmação destrutiva,
    avisos e estados, badges, textos e formatos, teclado, desktop primeiro, e o checklist de PR com
    tela. A barra superior é a faixa da marca, com a pesquisa global (`Ctrl+K`), e há uma página
    "Página não encontrada" e um campo de moeda com máscara.
  - **Conformidade** (`conformidade.md`): o que a CI confere, os níveis bloqueia, avisa e revisa, a
    produção que só recebe commit de PR aprovado, as exceções com prazo, os sistemas que já existem
    (com alerta de inconformidade enquanto não há prazo) e a regra nova que entra avisando.
  - Modelo: a seção de login, cores e interface para o `CLAUDE.md` (`modelos/CLAUDE-interface.md`).
