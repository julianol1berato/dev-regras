# Conformidade: o que a CI confere

As regras de [login e acesso](login-e-acesso.md), [cores](cores.md) e [interface](interface.md)
são conferidas por máquina sempre que dá, e o que não dá para medir vai para a revisão. As
checagens são as mesmas em todo sistema e rodam na CI compartilhada: **o projeto não escreve esses
testes**, ele só precisa passar neles.

Enquanto uma checagem ainda não existe na CI, a regra vale do mesmo jeito, conferida na revisão.

## 1. Três níveis

| Nível | O que acontece |
|---|---|
| **bloqueia** | o PR não entra, ou a versão não sobe para a produção |
| **avisa** | a CI passa, com a falha mostrada no PR |
| **revisa** | não há checagem automática: o material vai para o PR, e quem revisa confere |

Bloqueio fica para o que é objetivo e caro de errar. Regra subjetiva que bloqueia vira discussão em
todo PR, e logo vira exceção permanente.

## 2. O que é conferido

| Regra | Como | Nível |
|---|---|---|
| Login e acesso | teste de contrato contra a imagem do sistema, com um provedor de teste: sem sessão vai para `/auth/entrar`; sem papel cai em `/auth/sem-acesso`; o leitor não consegue escrever; cookie `__Host-`, `HttpOnly`, `Secure` e `SameSite`; sair só por `POST`; `?volta=` para fora recusado; sem registro e sem `AUTH_DISABLED=true`, o sistema não sobe | bloqueia |
| Versões das peças | o pacote de login, a paleta e os componentes estão numa versão suportada | bloqueia abaixo da mínima; avisa abaixo da atual |
| Cores | nenhum hex, `rgb()` ou passo de rampa fora do `tokens.css` | avisa na homologação; bloqueia na produção |
| Acessibilidade | varredura automática das telas principais: contraste, rótulos, foco | avisa na homologação; bloqueia na produção |
| Interface que não se mede | capturas das telas principais anexadas ao PR, o checklist de [`interface.md`](interface.md) e uma revisão por IA, como sugestão | revisa |
| Testes do sistema | o sistema tem testes, e eles passam | bloqueia |

As cores e a acessibilidade avisam na homologação porque é lá que a tela ainda está mudando. Na
produção, o que chega já precisa estar certo.

## 3. Exceção

- **Fica num arquivo versionado do sistema**: a regra, o motivo, quem aprovou e até quando.
- **Quem aprova é o dono do padrão**, no PR que acrescenta a exceção.
- **Vencido o prazo, a regra volta a valer** sozinha.

Uma exceção sem prazo é uma regra que deixou de existir sem ninguém decidir isso.

## 4. Sistemas que já existem

- **Entram com uma nota** dizendo o que já cumprem e o que falta, e **com um prazo** para o resto.
- **Não são bloqueados no primeiro dia.** Cada falta vale como aviso até o prazo vencer, e vira
  bloqueio depois.

Barrar de uma vez um sistema que funciona só ensina a pedir exceção.

## 5. A nota de conformidade

Cada sistema mostra, na plataforma de deploy, quais regras cumpre e quais não cumpre, com a versão
do padrão. Assim dá para ver de uma vez quem está atrás, sem abrir projeto por projeto.

## 6. Regra nova entra avisando

Uma checagem nova entra como **aviso numa versão** deste repositório e só vira **bloqueio na versão
seguinte**. Ninguém descobre uma regra nova quando o PR já está pronto para entrar.

## 7. Quem muda as regras

As regras mudam por PR neste repositório, com a aprovação do dono do padrão, e cada mudança entra
no `CHANGELOG.md`. Uma regra de projeto que contradiz o padrão é uma exceção (item 3), não uma regra
nova.

## Nunca

- Desligar uma checagem no projeto para o PR passar.
- Exceção sem prazo ou sem aprovação.
- Bloquear com uma regra que depende de gosto.
