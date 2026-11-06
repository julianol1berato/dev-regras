<!--
  Modelo de descrição de PR (pull request no GitHub, merge request no GitLab). Copie para o
  projeto e troque o que está entre <…>:
    - GitHub: .github/pull_request_template.md
    - GitLab: .gitlab/merge_request_templates/Default.md (o nome Default faz o GitLab usá-lo
      em todo MR novo)
  As regras por trás de cada parte: revisao-e-aprovacao.md, no repositório dev-regras.
-->

## O que mudou

<!-- O comportamento antes e depois, do ponto de vista de quem usa. -->

## Por quê

<!-- O motivo: defeito, pedido, desempenho. O link do issue, se houver. -->

## Como testei

- [ ] Os portões passam na minha máquina (`<comandos da CI>`).
- [ ] Bug corrigido: o teste novo falha sem a correção e passa com ela.
- [ ] Revisão por IA de contexto limpo feita; cada achado corrigido ou descartado com o motivo.
- [ ] Teste manual: <!-- o que rodou e o que viu -->

## Impacto na versão

<!-- Marque um. Ele decide o número da próxima versão (versoes-e-lancamentos.md). -->

- [ ] **Correção**: só corrige, nada novo.
- [ ] **Novidade**: acrescenta ou muda, sem quebrar o que funcionava.
- [ ] **Quebra**: algo que funcionava deixa de funcionar do mesmo jeito (diga o quê em "O que mudou").
- [ ] **Nenhum**: refatoração, teste ou doc interna.

- [ ] Se o comportamento mudou, há uma linha em `[Não lançado]` no `CHANGELOG.md`.
- [ ] Se há migração de banco, ela está citada no CHANGELOG, e o plano de volta é: <!-- … -->

## Onde olhar com mais cuidado

<!-- O trecho de que você tem menos certeza, uma decisão que tomou, ou o que o agente escreveu
     e você não teria escrito assim. "Nada em especial" também é resposta. -->

## Li este diff inteiro

- [ ] Li cada linha e sei explicar cada trecho, inclusive o que o agente escreveu.
