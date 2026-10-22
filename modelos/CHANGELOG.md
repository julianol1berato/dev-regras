# Changelog

O que muda a cada versão, na língua de quem usa. O formato segue o
[Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/), e as versões seguem
[SemVer](https://semver.org/lang/pt-BR/).

## Como registrar

- **Todo PR que muda comportamento acrescenta uma linha em `[Não lançado]`**, no grupo certo:
  Acrescentado, Modificado, Corrigido, Removido ou Segurança. Teste, refatoração e doc interna
  não entram.
- **Mudança de banco diz o número da migração** ("com a migração 0042"): depois que ela roda em
  produção, voltar de versão deixa de ser só trocar a imagem.
- **O número da próxima versão sai daqui**: só Corrigido ou Segurança → sobe o último número;
  qualquer Acrescentado ou Modificado → sobe o do meio; quebrou o que funcionava → ⚠️ em
  Modificado, e sobe o primeiro (na série 0.x, o do meio).
- **Ao lançar**, `[Não lançado]` vira `## [X.Y.Z] — AAAA-MM-DD`, e um `[Não lançado]` vazio abre
  acima dela.

## [Não lançado]

### Acrescentado

- <o que passou a existir, do ponto de vista de quem usa>

### Corrigido

- <o que funcionava errado e agora funciona>
