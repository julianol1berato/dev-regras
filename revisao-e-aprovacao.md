# Revisão e aprovação

A revisão de código serve para três coisas: **pegar o defeito antes de quem usa**, **fazer pelo
menos duas pessoas entenderem cada mudança** e **manter o padrão do projeto**. Não serve para
provar quem sabe mais. Com IA escrevendo boa parte do código, escrever ficou barato e revisar
não: o gargalo do time passou a ser a revisão. As regras abaixo existem para que ela seja rápida
sem ficar rasa.

Elas foram pensadas para um time pequeno, de três pessoas, em que todo mundo usa agentes de IA. O
uso dos agentes em si está em [`agentes-de-ia.md`](agentes-de-ia.md).

Aqui, **PR** quer dizer o pedido de merge: *pull request* no GitHub, *merge request* (MR) no
GitLab. As regras valem igual nos dois; o que muda de uma forja para a outra está no item 10.

## 1. Quem abre o PR responde por cada linha

**O autor do PR responde por ele, não importa quem digitou.** Antes de pedir revisão, você leu o
diff inteiro e sabe explicar cada trecho. "Foi a IA que fez" não é resposta numa revisão.

Se o autor não leu, o revisor vira o primeiro leitor, e a revisão vira a escrita, feita pela
pessoa errada e sem o contexto.

## 2. Antes de pedir revisão

1. **Combine o desenho antes de gerar o código** quando a mudança mexe em estrutura, banco,
   contrato de API ou leva mais de um dia. Dez minutos de conversa, ou um issue, evitam o pior
   resultado de uma revisão: descobrir no PR que a abordagem estava errada. Com IA, gerar 800
   linhas na direção errada leva minutos, e jogá-las fora dói do mesmo jeito.
2. **Os portões passam na sua máquina**: os mesmos comandos da CI (build, tipos, lint, testes).
3. **Uma revisão por IA de contexto limpo já rodou**, e você tratou cada achado: corrigiu, ou
   descartou com o motivo ([agentes, item 9](agentes-de-ia.md#9-revisão-por-ia-contexto-limpo-antes-da-humana)).
4. **Todo bug corrigido tem um teste que morde**: falha sem a correção e passa com ela. Teste que
   passa nos dois casos não prova nada.
5. **O PR é pequeno e de um assunto só.** Acima de umas 400 linhas de código alterado (fora testes
   e arquivos gerados), quebre. Refatoração vai num PR, mudança de comportamento em outro. Num diff
   grande a atenção cai e a revisão vira leitura por cima; e um PR pequeno se reverte sem levar
   junto o que estava certo.
6. **A descrição segue o modelo** ([`modelos/descricao-de-pr.md`](modelos/descricao-de-pr.md)):
   o que mudou (antes e depois), por quê, como testou, o impacto na versão e onde o revisor deve
   olhar com mais cuidado. Diga ali o trecho de que você tem menos certeza, inclusive o que a IA
   escreveu e você não teria escrito assim.
7. **A linha do CHANGELOG está no PR**, se o comportamento mudou
   ([versões, item 2](versoes-e-lancamentos.md#2-o-changelog)).
8. **O que ainda não está pronto abre como rascunho** (*draft*). Pedir revisão de algo que vai
   mudar gasta a revisão duas vezes.

## 3. Quem revisa, e em quanto tempo

- **Uma aprovação humana, de quem não é o autor.** Com três pessoas, exigir duas faz todo mundo
  parar a cada PR; uma, com rodízio, já garante que cada mudança é entendida por duas.
- **O autor escolhe o revisor pelo nome** e alterna, para que cada um conheça o código dos outros
  dois. "Alguém revisa?" é um pedido para ninguém. Se uma área tem dono de fato (infraestrutura,
  migrações), o `CODEOWNERS` diz quem é; use só para isso. No GitLab, o `CODEOWNERS` só vale
  nos planos Premium e Ultimate.
- **Primeira resposta no mesmo dia útil.** Revisar vem antes de começar tarefa nova. PR parado
  acumula conflito, e o autor, que já está em outra coisa, perde o contexto.
- **O revisor também pode usar IA** na primeira leitura, mas o veredito e cada comentário são
  dele (item 5).

## 4. O que o revisor confere

Na ordem, do mais caro de errar para o mais barato:

| # | Pergunta | Como conferir |
|---|---|---|
| 1 | É a coisa certa? Resolve o problema descrito, e só ele? | a descrição contra o diff |
| 2 | Funciona? O teste morde? | rode o teste novo contra o código da `main`: tem de falhar |
| 3 | O escopo é só o pedido? | nada de refatoração de carona, código morto, abstração sem uso, dependência nova sem necessidade |
| 4 | É seguro? | segredo no código, entrada sem validação, dado de um cliente visível para outro, SQL ou comando montado com texto de fora |
| 5 | E quem já usa? | dados existentes, migração e plano de volta, default mudado chegando a todo lugar que o lê |
| 6 | A API de terceiros existe do jeito que foi usada? | a documentação do fornecedor, não a memória da IA |
| 7 | CHANGELOG e documentação acompanham? | no mesmo PR |
| 8 | Dá para entender daqui a seis meses? | nomes, e comentários que dizem o porquê, não o quê |

O item 3 pesa mais com IA: o agente tende a entregar mais do que foi pedido, e cada linha a mais
é linha a revisar e manter. Estilo que o lint pega não é assunto de revisão humana; se o lint não
pega e importa, vira regra do lint.

Para o item 2, o jeito mais simples é rodar só o teste novo sobre o código da `main`, numa pasta
à parte, sem mexer na sua (ou peça ao [agente revisor](modelos/agente-revisor.md), que faz isso):

```bash
d=$(mktemp -d) && git worktree add --detach "$d" origin/main
git -C "$d" checkout <branch do PR> -- tests/test_saldo.py   # só o teste novo
(cd "$d" && <comando do teste>)                               # esperado: falha na asserção
git worktree remove --force "$d"
```

## 5. Como comentar

**Cada comentário começa com um rótulo**, para o autor saber o que é obrigatório sem adivinhar o
tom:

| Rótulo | Quer dizer | Bloqueia o merge? |
|---|---|---|
| `bloqueia:` | precisa mudar antes do merge | sim |
| `sugestão:` | ficaria melhor; o autor decide | não |
| `pergunta:` | não entendi; a resposta pode virar comentário no código | até ser respondida |
| `detalhe:` | cosmético | nunca |
| `bom:` | o que ficou bom, dito com o detalhe | — |

- **Todo `bloqueia:` diz o porquê e propõe o caminho.** "Isto está errado", sem caminho, devolve
  o problema sem a metade útil da revisão.
- **Todo `bloqueia:` é uma conversa no diff, e só quem a abriu a resolve.** Com a forja exigindo
  as conversas resolvidas para o merge (item 10), o bloqueio segura o PR de verdade. Se o próprio
  autor pudesse resolver, o bloqueio seria só uma opinião.
- **Comente o código, não a pessoa**: "este laço refaz a consulta a cada item", e não "você fez a
  consulta dentro do laço".
- **Pergunte quando não entender**, em vez de afirmar que está errado. Às vezes o autor sabe algo
  que você não sabe.
- **Preferência não bloqueia.** Se é só como você teria feito, é `sugestão:` ou `detalhe:`. Se
  importa de verdade para o time, proponha a regra num PR à parte, no `CLAUDE.md` ou no lint.
- **Comentário gerado por IA só entra depois que você conferiu e concorda**, e aí ele é seu. Um
  achado falso de IA colado no PR custa ao autor o tempo de provar que está errado.
- **Passou de duas idas e voltas no mesmo ponto, conversem** por voz, dez minutos, e o resultado
  vai escrito no PR. Texto é ruim para negociar e ótimo para registrar.
- **Diga o que ficou bom**, com o detalhe: "os casos de ramal vazio no teste deixaram fácil
  conferir a borda". Elogio específico ensina tanto quanto crítica.

## 6. Bloqueio leve: o revisor resolve

Esta vem do ai-memory: **o que o revisor resolve em minutos, ele resolve, em vez de devolver**.

- **Bloqueio leve**: falta a linha do CHANGELOG, falta um caso no teste, a doc ficou para trás, o
  branch precisa da `main` mais nova, uma correção pequena e óbvia. O revisor faz: uma linha vira
  uma sugestão no diff (*suggestion*, no GitHub e no GitLab), que o autor aplica com um clique; o
  resto vira um commit dele no branch do PR, com a mensagem dizendo o quê e por quê, e citado no
  comentário final. Faça os commits **antes** de aprovar: com a configuração do item 10, um commit
  depois da aprovação a derruba.
- **Bloqueio duro**: a abordagem está errada, o defeito pede uma decisão de desenho, ou é preciso
  cortar escopo. Esses voltam ao autor como *Request changes*, cada um com o caminho proposto.

Devolver "falta o CHANGELOG" custa uma volta inteira (o autor para o que está fazendo, corrige,
pede de novo, o revisor relê) por uma mudança de um minuto. E o revisor com um agente faz o commit
em menos tempo do que levaria para escrever o comentário.

Mudança de desenho nunca entra como bloqueio leve: o branch é do autor, e essa decisão também.

## 7. A barra que não se negocia

Bloqueia o merge mesmo com aprovação:

- regressão: algo que funcionava deixa de funcionar sem estar anunciado;
- teste desligado, pulado ou afrouxado para passar, ou um portão da CI enfraquecido;
- segredo no código, num teste ou num exemplo;
- segurança pior que antes;
- doc que a mudança deixou errada;
- código ofuscado, ou que ninguém do time sabe explicar.

## 8. O comentário que fecha a revisão

Um comentário no fim, curto, nesta ordem: **o que você conferiu e como**, **o que acrescentou**,
**o que fica para depois** e **a decisão**. É o formato que o Akita usa nos PRs do ai-memory:

```text
Aprovado. Conferi: o teste novo falha na main e passa aqui, e o caso sem ramal continua igual.
Acrescentei um commit com a linha do CHANGELOG e o caso de ramal duplicado no teste.
Fica para depois: o relatório mensal tem o mesmo problema; abri o #123.
Sai na próxima correção.
```

Quando a resposta é não, os motivos vêm com evidência (o arquivo, o cenário que quebra) e com um
caminho:

```text
Não vamos seguir com este PR, por dois motivos:
- o limite de tentativas já existe no proxy (config/proxy.conf), e repeti-lo na aplicação
  deixa dois lugares para manter;
- o bloqueio novo recusa as chamadas internas entre app e fila, que a doc de instalação usa.
Se aparecer um caminho que passa pelo proxy sem limite, abra um issue com o cenário.
```

"LGTM" não diz se o revisor rodou o teste ou passou o olho. Dizer o que foi conferido mostra ao
autor o que ainda é responsabilidade só dele, e deixa o PR útil para quem chegar nele depois.

## 9. Aprovação e merge

- **O merge pode ser feito quando há**: uma aprovação, a CI verde, todas as conversas resolvidas e
  o branch em dia com a `main`.
- **Quem faz o merge é o autor**, depois de ler os commits que o revisor acrescentou. Assim toda
  linha passou por dois pares de olhos, inclusive as do revisor, e o merge fica com quem vai
  acompanhar a mudança depois que ela sair.
- **Squash**: um PR vira um commit na `main` (*Squash and merge* no GitHub, *Squash commits when
  merging* no GitLab). Os commits separados servem à revisão; na `main`, um commit por PR se
  desfaz com um `git revert` e não deixa o `git bisect` parar num estado pela metade.
- **Correção urgente não pula a revisão: encurta.** Continua sendo PR, com CI; a revisão pode ser
  ao vivo, com a tela compartilhada. Se ninguém puder revisar, o merge sai sem a aprovação: no
  GitHub, por quem administra o repositório, pela lista de *bypass*; no GitLab Premium, baixando a
  regra de aprovação para zero só durante esse merge; no GitLab Free, onde a aprovação não é
  imposta, pelo próprio autor. Em todos os casos, o PR ganha a nota "mesclado sem revisão:
  <motivo>", e a revisão acontece até o dia útil seguinte. Exceção que vira hábito é proteção que
  não existe.

## 10. A configuração na forja

As regras são as mesmas no GitHub e no GitLab. O que muda é onde ligar cada coisa, e o quanto o
plano da forja deixa impor.

### GitHub

Em **Settings → Rules → Rulesets**, um ruleset para a `main`:

| Opção | Valor | Por quê |
|---|---|---|
| Restrict deletions | ligado | ninguém apaga a `main` |
| Block force pushes | ligado | histórico publicado não se reescreve |
| Require a pull request before merging | ligado | nada chega na `main` sem PR |
| ↳ Required approvals | 1 | item 3 |
| ↳ Dismiss stale pull request approvals when new commits are pushed | ligado | a aprovação vale para o código que vai entrar, não para uma versão anterior dele |
| ↳ Require approval of the most recent reviewable push | **desligado** | ligado, o revisor que acrescenta um commit (item 6) não pode mais aprovar, e só sobra a terceira pessoa |
| ↳ Require conversation resolution before merging | ligado | nenhum `bloqueia:` fica para trás |
| ↳ Allowed merge methods | Squash | item 9 |
| Require status checks to pass | ligado, com os jobs da CI | o portão é a CI, não a memória de alguém |
| ↳ Require branches to be up to date before merging | ligado | a CI rodou sobre o que vai ficar na `main`, não sobre uma `main` antiga |
| Bypass list | só o administrador, uso registrado no PR | item 9 |

Em repositório privado, rulesets e proteção de branch exigem um plano pago do GitHub (Pro ou
Team).

### GitLab

| Onde | Opção | Valor | Plano | Por quê |
|---|---|---|---|---|
| Settings → Repository → Branch rules → `main` | Allowed to push and merge | No one | Free | nada chega na `main` sem MR |
| ↳ | Allowed to merge | Developers + Maintainers | Free | o autor faz o merge (item 9) |
| ↳ | Allowed to force push | desligado | Free | histórico publicado não se reescreve |
| Settings → Merge requests | Merge method | Fast-forward merge | Free | o MR tem de estar em dia com a `main`, e a CI rodou sobre o que vai ficar nela |
| ↳ | Squash commits when merging | Require | Free | item 9 |
| ↳ Merge checks | Pipelines must succeed | ligado | Free | o portão é a CI, não a memória de alguém |
| ↳ Merge checks | All threads must be resolved | ligado | Free | nenhum `bloqueia:` fica para trás (item 5) |
| ↳ Merge request approvals | uma regra de aprovação, com 1 aprovação | 1 | Premium | item 3 |
| ↳ Approval settings | Prevent approval by merge request creator | ligado (é o padrão) | Premium | quem aprova não é o autor |
| ↳ Approval settings | Prevent approvals by users who add commits | **desligado** | Premium | ligado, o revisor que acrescenta um commit (item 6), ou que clica em *Rebase*, não pode mais aprovar |
| ↳ Approval settings | Prevent editing approval rules in merge requests | ligado | Premium | o autor não zera a regra no próprio MR |
| ↳ Approval settings | Remove all approvals (quando entram commits) | ligado (é o padrão) | Premium | a aprovação vale para o código que vai entrar |

**No GitLab Free, a aprovação é opcional**: o botão *Approve* existe e fica registrado, mas não
impede o merge. Lá, a regra do item 3 é um combinado do time, e quem segura o merge de verdade é o
*All threads must be resolved*, porque cada `bloqueia:` é uma conversa que só quem abriu resolve.
O *Request changes* também só bloqueia o merge no Premium, nas versões a partir da 17.2.

No Free, então, ligue as linhas marcadas Free e combinem: **o merge só sai com o *Approve* de
alguém que não é o autor**. O MR registra quem aprovou e quem fez o merge; na conversa mensal do
item 11, confiram se algum MR entrou sem aprovação. Se a plataforma de deploy conferir a aprovação,
a trava dura fica na produção: ela recusa o commit de um MR sem *Approve*
([`conformidade.md`](conformidade.md)).

## 11. A revisão alimenta as regras

**O mesmo comentário duas vezes é uma regra faltando.** Quando um `bloqueia:` se repete, ele vira:

- **uma checagem automática**, se a máquina consegue recusar (lint, teste, CI, alvo de `make`).
  Regra que a máquina recusa não depende de ninguém lembrar;
- senão, **uma regra no `CLAUDE.md` do projeto, com o porquê**, para o agente de cada um parar de
  cometer o erro na origem.

O ai-memory faz isso às claras: a linha do CHANGELOG era a obrigação mais esquecida nas levas de
revisão, então a regra passou a dizer isso e virou bloqueio. Uma vez por mês, olhem juntos os
bloqueios do mês: o que se repetiu e ainda não virou regra nem portão?

Corrigir o mesmo erro em cada PR é trabalho que não acaba. E com IA, o erro que não vira regra
volta no próximo PR de qualquer um dos três.

## 12. Nunca

- Aprovar sem ler: "LGTM" em um minuto num PR de 600 linhas.
- Fazer merge do próprio PR sem aprovação, fora do *bypass* registrado do item 9.
- Pedir revisão de código que você não leu.
- Colar no PR um achado de IA que você não conferiu.
- Bloquear por preferência pessoal.
- Discutir a pessoa em vez do código.

## Checklist do autor

- [ ] li o diff inteiro e sei explicar cada trecho
- [ ] portões passando na minha máquina
- [ ] revisão por IA de contexto limpo feita, achados tratados
- [ ] bug corrigido tem teste que falha sem a correção
- [ ] um assunto só, abaixo de umas 400 linhas de código
- [ ] descrição pelo modelo, dizendo onde olhar com mais cuidado
- [ ] linha no CHANGELOG, se o comportamento mudou
- [ ] revisor escolhido pelo nome

## Checklist do revisor

- [ ] é a coisa certa, e só ela
- [ ] rodei o teste novo sem a correção, e ele falhou
- [ ] nada fora do escopo
- [ ] segurança e quem já usa
- [ ] API de terceiros conferida na fonte
- [ ] CHANGELOG e doc
- [ ] cada comentário com rótulo; cada `bloqueia:` com o porquê e o caminho
- [ ] bloqueios leves resolvidos com commit ou *suggestion*, antes de aprovar
- [ ] comentário final: o que conferi, o que acrescentei, o que fica para depois, a decisão
