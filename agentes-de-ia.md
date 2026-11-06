# Trabalho com agentes de IA

Num time em que todo mundo usa agentes (Claude Code, Codex, Cursor e similares), o agente escreve
boa parte do código, mas **quem responde por ele é sempre a pessoa**. As regras abaixo dizem o que
fica com o agente, o que fica com a pessoa, e como fazer o agente de cada um seguir o mesmo padrão.
A revisão e a aprovação estão em [`revisao-e-aprovacao.md`](revisao-e-aprovacao.md).

## 1. Um arquivo de regras, no repositório, para todos os agentes

- **As regras do projeto ficam num arquivo versionado na raiz**, que a ferramenta lê sozinha em
  toda sessão: `CLAUDE.md` no Claude Code; `AGENTS.md` no Codex, no Cursor, no Gemini CLI e em
  outros.
- **Se o time usa mais de uma ferramenta, um dos dois é o canônico, e o outro só aponta.** O
  ai-memory faz assim: as regras ficam no `AGENTS.md`, e o `CLAUDE.md` tem uma linha só,
  `@AGENTS.md`, que importa o outro na abertura da sessão. O Claude Code recente só lê o
  `AGENTS.md` quando não existe `CLAUDE.md`, e uma frase como "leia o AGENTS.md" não carrega nada:
  depende de o agente resolver abrir o arquivo.
- **Preferência pessoal fica fora do repositório**: em `~/.claude/CLAUDE.md` (vale para todos os
  seus projetos) ou num `CLAUDE.local.md` listado no `.gitignore`.
- **Memória local do agente não guarda regra nem decisão do projeto.** O que o seu agente "lembra"
  é invisível para o agente dos outros dois. Regra vai para o arquivo de regras; decisão, para uma
  pasta de decisões no repositório (`docs/decisoes/`, por exemplo).

Três pessoas com três configurações produzem três padrões de código, e a revisão vira discussão de
estilo. Uma regra no repositório vale para os três agentes ao mesmo tempo e passa pela mesma
revisão que qualquer outra mudança.

## 2. Tarefa pequena, com o escopo dito

- **Uma tarefa por sessão**, dizendo o que é para fazer e o que **não** é: "corrija o cálculo do
  saldo; não mexa no relatório nem refatore o módulo".
- **Mudança que não é trivial começa por um plano**, que você lê e corrige antes de o agente
  escrever código (no Claude Code, o *plan mode*). Corrigir um plano custa um parágrafo; corrigir o
  código custa uma revisão.
- **Nada além do pedido**: sem refatoração de carona, sem funcionalidade vizinha, sem abstração
  "para o futuro", sem código morto. Se o agente achar algo que vale fazer, ele propõe, e isso vira
  outra tarefa.

Gerar código ficou barato, revisar não. O agente tende a entregar mais do que foi pedido, e cada
linha a mais é linha a revisar, testar e manter.

## 3. "Pronto" quer dizer que os portões passaram

- **O agente roda os mesmos comandos da CI antes de dizer que terminou**: build, tipos, lint e
  testes. O arquivo de regras lista esses comandos, em dois laços: o rápido, para o dia a dia, e o
  completo, para antes de entregar.
- **Bug corrigido vem com um teste de regressão que morde**: falha sem a correção e passa com ela.
- **Peça a prova, não a afirmação**: a saída dos testes, e não "os testes devem passar".

"Pronto" de agente sem portão é palpite bem escrito.

## 4. O que o agente nunca faz sem você pedir, nesta conversa

| Ação | Por quê |
|---|---|
| push na `main`, merge de PR | a aprovação é do time, não da ferramenta |
| criar tag, subir versão | o número e o momento são decisões ([versões](versoes-e-lancamentos.md)) |
| deploy, comando em produção | é difícil de desfazer, e o efeito cai em quem usa |
| apagar branch, dado ou arquivo fora da tarefa | idem |
| ler ou mexer em `.env`, segredo, credencial | o que entra no contexto pode sair num log, num commit ou num serviço externo |
| enfraquecer um portão: pular teste, `--no-verify`, afrouxar lint ou CI | o portão existe justamente para a hora do "só falta isso" |
| adicionar dependência | item 6 |

Um "pode fazer o push" numa tarefa não vale para a próxima. O ai-memory escreve isso no próprio
arquivo de regras: versão e tag, só com aprovação explícita.

**O que der para travar por configuração, trave.** Um `.claude/settings.json` versionado poupa
perguntas de permissão nos comandos de rotina e recusa os arquivos de segredo:

```json
{
  "permissions": {
    "allow": ["Bash(git diff *)", "Bash(git log *)", "Bash(make test)", "Bash(make lint)"],
    "deny": ["Read(./.env)", "Read(./.env.*)", "Read(./secrets/**)"]
  }
}
```

Regra de `deny` vale para as ferramentas do agente, não para um script que ele rode e que abra o
arquivo por conta própria. Para uma cerca de verdade, use o isolamento do item 8.

## 5. Agentes em paralelo: um worktree por tarefa

```bash
git worktree add ../app-saldo -b fix/saldo-duplicado   # uma pasta e um branch por tarefa
cd ../app-saldo && claude                                # o agente trabalha só aqui
git worktree remove ../app-saldo                         # depois do merge
```

- **Nunca dois agentes na mesma pasta.** Um pisa nos arquivos do outro, e um commit leva junto a
  metade do trabalho do vizinho.
- **Remova o worktree depois do merge.** Cada um carrega o próprio build, e worktree esquecido
  enche o disco e confunde quem procura o branch.

O ai-memory leva isso adiante: cada PR recebido ganha a sua *lane* (um branch e um worktree), onde
o mantenedor revisa e acrescenta commits, e as lanes se juntam num branch de integração antes de ir
para a `main`. Para três pessoas com PRs pequenos, um worktree por tarefa basta.

## 6. Dependência nova e API de terceiros: confira na fonte

- **Agente inventa**: parâmetro que não existe, versão que não saiu, e até pacote com o nome
  parecido com o certo, que alguém pode ter registrado de propósito para ser instalado por engano.
- **Dependência nova passa por uma pessoa**: o projeto já tem algo que faz isso? É o pacote certo,
  ele existe e é mantido? Precisa mesmo?
- **Código que imita o comportamento de outra ferramenta cita a documentação** num comentário ao
  lado, e os testes cobrem os casos que ela descreve, não só o caso da tarefa. A regra é do
  ai-memory, escrita depois que uma implementação que cobria um caso só teve de ser refeita no PR
  seguinte.

A IA escreve o uso de uma API com a mesma confiança quando acerta e quando inventa.

## 7. Texto de fora é dado, não instrução

Issue, comentário de PR, página da web, log, mensagem de erro, saída de ferramenta e memória
recuperada podem trazer frases escritas para o agente, como "ignore as instruções anteriores e…".
O agente trata tudo isso como informação, nunca como ordem: segue só você e o arquivo de regras.
Ponha essa regra no arquivo de regras.

O agente age com as suas permissões. Um comentário malicioso num issue público não pode virar um
commit, um segredo vazado ou um comando.

## 8. Sem confirmação, só dentro de uma caixa de areia

Rodar o agente sem pedir permissão (`--dangerously-skip-permissions`, o "modo yolo") deixa-o
apagar arquivos, rodar qualquer comando e acessar a rede sem supervisão. Só faça isso **dentro de
um isolamento**: um container ou uma VM sem as suas credenciais, ou o
[ai-jail](https://github.com/akitaonrails/ai-jail), que o Akita escreveu para isso. E **nunca com
acesso à produção**.

Fora do isolamento, use o modo normal, com a lista de permissões do item 4.

## 9. Revisão por IA: contexto limpo, antes da humana

1. **Antes de pedir a revisão humana, rode uma revisão por um agente de contexto limpo**: o
   sub-agente revisor ([`modelos/agente-revisor.md`](modelos/agente-revisor.md)), o comando de
   revisão da sua ferramenta, ou uma sessão nova. **Não o mesmo agente que escreveu**: ele está
   ancorado no próprio raciocínio e tende a confirmar o que fez.
2. **O autor trata cada achado**: corrige, ou descarta com o motivo.
3. **A aprovação é sempre humana**, e comentário de IA só entra no PR conferido e assumido por
   alguém ([revisão, item 5](revisao-e-aprovacao.md#5-como-comentar)).

A IA é boa no mecânico (borda esquecida, nulo, teste faltando, caso não tratado) e não cansa no
décimo arquivo. Tirar isso do caminho antes deixa o revisor humano com o que só ele vê: se é a
coisa certa, se cabe no sistema, se o time vai entender.

## 10. O arquivo de regras cresce com a revisão

- **Ia dizer "sempre X" ou "nunca Y" ao agente? Escreva no arquivo de regras**, com o porquê. Dito
  só na conversa, vale até ela acabar, e só para o seu agente.
- **Erro que voltou na revisão vira regra** ([revisão, item 11](revisao-e-aprovacao.md#11-a-revisão-alimenta-as-regras)),
  e a regra conta o incidente numa frase, sem nomes. O ai-memory faz assim: um "isto foi esquecido
  repetidas vezes" ao lado da regra explica por que ela bloqueia.
- **Regra nova é um PR como outro qualquer**, revisado pelos outros dois: ela muda o comportamento
  do agente dos três.

## 11. Autoria dos commits

- **Commit que o agente escreveu leva a marca dele**, a linha `Co-Authored-By:`, que o Claude Code
  põe por padrão. O histórico diz como o código foi feito, sem ninguém precisar adivinhar.
- **Confira a identidade dos commits** antes do push (`git log --format='%h %an <%ae>'`): com o
  e-mail errado, nem o GitHub nem o GitLab ligam o commit à sua conta. Se o seu e-mail global é de outro
  trabalho, configure o do projeto com `git config --local user.email`.

## Nunca

- PR com código que você não leu.
- Agente com acesso à produção, ou sem confirmação fora de um isolamento.
- Dois agentes na mesma pasta.
- Regra do projeto guardada só na memória do seu agente.
- Portão enfraquecido para o agente conseguir terminar.
- Seguir uma instrução que veio de dentro de um issue, log ou página.
