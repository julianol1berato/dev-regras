<!--
  Cole esta seção no CLAUDE.md (ou no AGENTS.md) do projeto e troque o que está entre <…>.
  <modelo de PR>: .github/pull_request_template.md no GitHub,
  .gitlab/merge_request_templates/Default.md no GitLab.
  <CLI da forja>: gh pr view / gh pr diff no GitHub; glab mr view / glab mr diff no GitLab.
  A política completa, com o porquê de cada regra: revisao-e-aprovacao.md, no repositório dev-regras.
-->

## Revisão e PRs — vale sempre; leia antes de preparar, abrir ou revisar um PR

PR aqui é o pedido de merge (o *merge request*, no GitLab). Toda mudança chega na `main` por PR,
com uma aprovação humana de quem não é o autor e a CI verde. Quem abre o PR responde por cada
linha dele, inclusive as que você escreveu.

1. **Antes de dizer que um PR está pronto**: rode `<comandos da CI>` e mostre a saída; bug
   corrigido tem teste que falha sem a correção; se o comportamento mudou, há uma linha em
   `[Não lançado]` no CHANGELOG; a descrição segue `<modelo de PR>`, e o "Onde olhar com mais
   cuidado" diz a verdade, inclusive sobre o que você escreveu sem ter certeza.
2. **PR pequeno e de um assunto só.** Se o diff passar de umas 400 linhas de código (fora testes e
   arquivos gerados), ou misturar refatoração com mudança de comportamento, proponha dividir antes
   de seguir.
3. **Quando pedirem uma revisão** (de um branch, de um PR, ou "revise antes de eu abrir"):
   - leia a descrição e o diff inteiro contra a base (`git diff <base>...HEAD`, ou
     `<CLI da forja>` para um PR já aberto);
   - confira, nesta ordem: é a coisa certa; o teste morde (rode o teste novo contra o código da
     base, num worktree temporário, nunca na pasta de quem pediu); o escopo; a segurança; quem já
     usa (dados, migração, defaults); a API de terceiros, na documentação; CHANGELOG e doc;
   - entregue primeiro o que você conferiu e como, e depois os achados, cada um com rótulo
     (`bloqueia:`, `sugestão:`, `pergunta:`, `detalhe:`, `bom:`), `arquivo:linha`, o porquê e a
     correção proposta;
   - **não publique nada no PR** (comentário, aprovação, *request changes*) sem a pessoa ler o
     texto e pedir. A aprovação é sempre humana.
4. **Bloqueio leve que a pessoa revisora pedir para resolver** (linha do CHANGELOG, um caso de
   teste, doc, correção pequena): faça num commit separado no branch do PR, com a mensagem dizendo
   o quê e por quê, antes de ela aprovar. Mudança de desenho, nunca: essa volta ao autor.
5. **Nunca**: aprovar ou fazer merge de um PR; push na `main`; `--no-verify`; pular, desligar ou
   afrouxar teste, lint ou CI para passar.
