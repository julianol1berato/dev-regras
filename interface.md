# Interface: UI e UX

Regras obrigatórias para **toda tela nova ou alterada** de um sistema interno. O objetivo é que
todos os sistemas tenham a mesma cara e se comportem do mesmo jeito: quem aprendeu a usar um sabe
usar o outro. As cores vêm de [`cores.md`](cores.md), e as telas de login, perfil e acessos seguem
[`login-e-acesso.md`](login-e-acesso.md).

**Precedência:** pedido explícito de quem é dono do sistema, depois este documento, e por último o
gosto pessoal.

**Telas antigas:** quem mexe numa tela antiga traz essa tela para estas regras no mesmo PR (a tela,
não o sistema inteiro). Assim o sistema melhora sem um projeto de migração que nunca começa.

## 1. Princípios

| Princípio | O que significa |
|---|---|
| Hierarquia | **Uma única ação primária por tela.** O resto é secundário, ghost ou link. Tamanho, peso e cor indicam importância, nessa ordem. |
| Proximidade | O que é relacionado fica junto: 8px entre controles de um mesmo grupo, 16 a 24px entre grupos. O espaço separa antes de qualquer borda. |
| Similaridade | Mesma função, mesma aparência: todo filtro é chip, toda ação é botão. Nunca dois visuais para a mesma coisa. |
| Região comum | Borda e fundo só para o que precisa ser lido como unidade (card, painel, menu). Não se encaixota tudo. |
| Alinhamento | Tudo numa grade de 4/8px. As bordas esquerdas de títulos, barras e tabelas coincidem. |
| Menos opções à vista | Revele aos poucos ("Mais filtros", menus, "Exibição"). Uma barra não passa de uns 7 controles visíveis. |
| Alvos | Ação frequente tem alvo grande e perto de onde o olho está: no mínimo 32px no desktop e 40px em toque. Ação destrutiva fica longe da primária. |
| Padrões conhecidos | As pessoas passam a maior parte do tempo em outros sistemas (Jira, Linear, Gmail). Siga os padrões que elas já conhecem. |
| Estado visível | O controle mostra o valor atual ("Status: A fazer +1", "Agrupar: Projeto"). Contagens, carregamento e "N ocultas pelos filtros" ficam sempre à vista. |
| Reconhecer, não lembrar | Mostre as opções e os valores. Atalho é bônus, sempre anunciado no `title`. |
| Sem repetição | A mesma informação não aparece duas vezes na mesma vista. |
| Acessibilidade | WCAG 2.2 AA: texto com pelo menos 4,5:1, texto grande, ícones essenciais, foco e selecionado com pelo menos 3:1. Foco sempre visível, tudo operável por teclado, cor nunca é a única pista. |

## 2. Medidas

### 2.1 Espaçamento: grade de 4/8

`4 · 8 · 12 · 16 · 24 · 32 · 48`, e nada fora disso. Use `gap` em flex e grid, em vez de margem
elemento por elemento.

| Onde | Valor |
|---|---|
| Entre controles do mesmo grupo | 8px |
| Entre grupos de uma barra | 16px (ou um divisor vertical de 1px por 20px de altura) |
| Cabeçalho da página → barra | 24px |
| Barra → conteúdo | 16px |
| Margem interna da página | 24px (16px no celular) |
| Margem interna do card | 16px (20 a 24px em card de formulário) |

### 2.2 Tipografia: escala fixa

A fonte é a dos tokens (`--fonte`, em [`cores.md`](cores.md)).

| Tamanho | Peso | Uso |
|---|---|---|
| 20px | 700 | título da página, um por tela |
| 16px | 600 | título de seção e de modal |
| 14px | 500–600 | destaque, nome de grupo |
| 13px | 400 | corpo, células de tabela, campos |
| 12px | 500 | chips, botões pequenos, metadados, subtítulo |
| 11px | 600, MAIÚSCULAS, espaçamento .05em | cabeçalho de tabela, rótulo de formulário, título de seção de menu |

Números em colunas e contadores usam algarismos tabulares.

### 2.3 Forma e tamanho

| Medida | Valor | Uso |
|---|---|---|
| controle pequeno | 28px | ações dentro de uma linha ou do cabeçalho de um grupo |
| controle | 32px | barras de ferramentas: chips, busca, seletores, ghost |
| controle grande | 36px | botão primário do cabeçalho, campos de formulário, botões de modal |
| toque | 40px ou mais | com `pointer: coarse`, todo controle interativo sobe para 40px |
| raio de badge | 6px | badges |
| raio de controle | 8px | botões e campos de formulário |
| raio de painel | 12px | cards, menus, popovers, modais |
| pílula | 999px | chips e todo controle de barra de filtros ou de exibição, inclusive a busca |

**Numa mesma linha, todos os controles têm a mesma altura e o mesmo raio.**

### 2.4 Sombra

Sombra só no que flutua: menu, popover, modal, aviso. Card no fluxo da página tem borda, não sombra.

### 2.5 Ícones

- **Biblioteca única:** Lucide.
- **Tamanho:** 14px em controles de 28 a 32px e 16px nos de 36px ou mais, sempre à esquerda do texto.
- **Acessibilidade:** ícone com texto leva `aria-hidden="true"`; ícone sozinho exige `aria-label` e
  `title`.

### 2.6 Movimento

- **Durações:** hover e cor em 150ms; menu e popover em 150 a 200ms (aparece e desliza 4px); modal em
  200ms.
- **Nada pisca nem se mexe sozinho.**
- **Com `prefers-reduced-motion`, a animação some.**

## 3. Estrutura da tela

- **Barra lateral** fixa de 256px à esquerda:
  - abaixo de 1024px, vira gaveta, aberta pelo botão de menu;
  - no topo, o logo e o nome do sistema;
  - os itens em grupos, com rótulo de 11px MAIÚSCULAS, que recolhem e são lembrados.
- **O menu mostra só o que a pessoa pode usar:**
  - cada item usa a mesma permissão da rota, e um grupo vazio não aparece;
  - o item continua ativo nas páginas de detalhe dele.
- **Barra superior** de 56px, fixa no topo:
  - à esquerda, o caminho de navegação ("Sistema › Página");
  - à direita, as ações globais: tema, notificações e o menu da pessoa.
- **Caminho de navegação:** vem da rota. A página de detalhe define o próprio caminho ("Projetos ›
  Projeto › CHAVE-12").
- **Cabeçalho da página:**
  - título (20/700), subtítulo opcional (quase sempre a contagem) e as ações à direita;
  - no máximo uma primária, de 36px.
- **Faixas de estado no topo:** sem conexão, sessão especial e configuração pendente. Condição que
  dura não vira aviso que some sozinho.
- **Menu da pessoa:**
  - nome e e-mail;
  - "Meu perfil";
  - "Acessos" (só admin, com o número de pedidos);
  - "Sessões ativas", quando houver;
  - um divisor e "Sair".

## 4. Botões

### 4.1 Variantes

| Variante | Quando | Visual |
|---|---|---|
| Primário | **a** ação principal da tela ou do modal, uma por vista | fundo `--cor-acento`, texto `--cor-sobre-acento`, 600 |
| Secundário | outras ações relevantes (Cancelar, Exportar) | fundo `--cor-superficie-3`, borda `--cor-borda` |
| Ghost | ações utilitárias e de pouca ênfase (Recolher tudo, Limpar tudo) | sem borda nem fundo; fundo só no hover |
| Perigo | excluir, revogar, encerrar | tom crítico da paleta, sempre com confirmação (item 9) |
| Link | navegação ou ação dentro de um texto | texto `--cor-link`, sublinhado no hover |

### 4.2 Tamanhos

Pequeno de 28px (texto de 12px), padrão de 32px (13px) e grande de 36px (13px). O primário do
cabeçalho é o grande.

### 4.3 Estados (todos obrigatórios)

| Estado | Regra |
|---|---|
| hover | muda o fundo, nunca só o cursor; 150ms |
| active | escurece ou afunda de leve |
| foco | `outline: 2px solid var(--cor-foco); outline-offset: 2px`. Nunca `outline: none` sem substituto |
| desabilitado | `opacity: .5`, sem hover; o porquê no `title` quando não for óbvio |
| carregando | spinner no lugar do ícone, o texto fica, a largura não muda, `aria-busy="true"` e clique bloqueado |

### 4.4 Texto e ordem

- **Texto do botão:** verbo ou nome da ação ("Salvar", "Nova tarefa", "Exportar CSV"), em até três
  palavras. Nunca "Clique aqui" nem "OK" solto.
- **No rodapé de modal ou de formulário, Cancelar fica à esquerda e o primário à direita.** O botão
  destrutivo nunca é o do Enter.
- **Nunca dois primários lado a lado.** A ação destrutiva fica separada da primária por espaço ou
  por um divisor.

## 5. Chips, seletores e menus

### 5.1 O que usar

| Necessidade | Controle |
|---|---|
| filtro de várias escolhas (status, responsável, tags) | chip de múltipla escolha |
| escolha única numa barra (prazo, agrupar, ordem) | chip de escolha única |
| liga/desliga ("Atribuídas a mim") | chip com `aria-pressed` |
| período | chip de período: atalhos (Hoje, Ontem, Esta semana, Semana passada, Este mês, Mês passado, Últimos 30 dias, Personalizado, Qualquer data) e as datas num popover |
| escolha única em formulário, com busca | lista suspensa com busca |
| escolha única em formulário simples | `<select>` estilizado como os campos |

**Proibido `<select>` nativo e `<input type="date">` solto em barra de ferramentas ou de filtros:**
eles não seguem o tema, a altura, o raio nem os estados.

### 5.2 O chip

- **Forma:** pílula de 32px, 12px de margem lateral, texto de 12px/500 e ícone de 14px.
- **Neutro:** borda `--cor-borda` e texto `--cor-tinta-2`, com um rótulo simples ("Projeto").
- **Valor padrão:** mostra o valor sem destaque ("Status: abertas"). O padrão não conta como filtro.
- **Ativo:**
  - fundo `--cor-acento-suave`, borda `--cor-acento` e texto `--cor-link`, com o valor ("Status: A
    fazer +1", "Prazo: Esta semana");
  - um **×** próprio limpa o filtro com um clique, sem abrir o menu
    (`aria-label="Remover filtro Prazo"`).
- **Seletor de exibição** (agrupar, ordem): ícone, rótulo e valor ("▤ Agrupar: Projeto ▾"). Ele nunca
  fica com cara de ativo, porque não filtra.

### 5.3 Menus e popovers

- **Painel:** fundo `--cor-superficie`, borda `--cor-borda`, raio de painel, sombra e 4px de margem
  interna. A largura mínima é a do botão que abriu.
- **Item:** 32px (40px em toque), texto de 13px, ✓ à esquerda do selecionado, e o mesmo realce no
  hover e no item ativo pelo teclado.
- **Título de seção:** 11px MAIÚSCULAS, em `--cor-tinta-3`.
- **Teclado:**
  - setas, Home e End movem;
  - Enter ou Espaço seleciona, e digitar pula para a opção;
  - **Esc fecha e devolve o foco ao botão**, e Tab fecha.
- **Clique fora fecha o menu** (o modal não; item 8).
- **ARIA:**
  - o botão leva `aria-haspopup="listbox"` e `aria-expanded`;
  - a lista leva `role="listbox"`;
  - cada item leva `role="option"` e `aria-selected`.

## 6. Telas de lista

```
┌ Cabeçalho ─────────────────────────────────────────────────────────────┐
│ Título (20/700)                                        [+ Ação primária]│
├ Barra "o quê" (filtros) ───────────────────────────────────────────────┤
│ [Visões ▾] │ [🔍 Buscar…  /] [Atribuídas a mim] [Status ▾] [Projeto ▾]  │
│              [Prazo ▾] [Mais filtros (2)] [× Limpar tudo]               │
├ Barra de resultados ("como") ──────────────────────────────────────────┤
│ 2 itens · 69 ocultos pelos filtros    [▤ Agrupar: Projeto ▾] [⇅ Ordem ▾] │
└ Conteúdo ──────────────────────────────────────────────────────────────┘
```

### 6.1 A pesquisa da lista

- **Forma:** pílula de 32px, lupa de 14px à esquerda, texto de 12px e `type="search"`. A largura vai
  de 180 a 300px.
- **Lugar:** é sempre o **primeiro item** da barra de filtros. Só vem depois do menu "Visões", quando
  ele existe.
- **Texto de exemplo:** "Buscar <coisas>..." ou, quando cobre campos específicos, "Buscar por
  <campos>..." ("Buscar por nome ou e-mail...").
- **Atalho `/`:**
  - foca a busca de qualquer lugar, menos enquanto se digita ou com um modal aberto;
  - a pílula mostra um `<kbd>/</kbd>`, que some no foco, e tem `title="Buscar (/)"`;
  - só uma busca por tela tem o atalho.
- **Espera de 300ms** depois da última tecla. Apagar o texto busca na hora.
- **O texto da busca vai para o endereço** (substituindo a entrada do histórico), e os filtros entram
  como navegação. Todo valor que vem do endereço é validado antes de chegar à API.
- **Ignora acentos** quando a busca é de texto livre.

### 6.2 A barra de filtros

1. **A ordem é fixa:** busca, liga/desliga, seletores, "Mais filtros (N)" (atalho F), e "Limpar tudo"
   por último.
2. **Filtros ("o quê") e exibição ("como") são grupos separados**, nunca misturados na mesma fileira
   sem separação.
3. **O estado do filtro vive no próprio chip.** No desktop não há uma fileira extra repetindo os
   filtros ativos.
4. **"Limpar tudo":**
   - é um botão ghost em pílula, com ícone ×, e é o **último item da fileira**, no fluxo normal (nunca
     empurrado para a direita);
   - aparece quando há busca ou filtro fora do padrão, ou uma visão ativa;
   - zera a busca e os filtros e mantém o agrupamento e a ordem;
   - depois dele, o foco vai para a busca.
5. **"Mais filtros"** abre uma segunda fileira, sem caixa tracejada (o tracejado é área de soltar
   arquivo).
6. **Visões salvas** (nas telas de trabalho diário):
   - padrões fixos e uma visão padrão por pessoa;
   - "Salvar alterações", "Salvar como nova" e "Desfazer alterações";
   - um × no chip da visão ativa volta para "Todos";
   - as visões ficam guardadas no servidor.
7. **Barra de resultados**, logo acima da lista:
   - à esquerda, a contagem e "N ocultos pelos filtros";
   - à direita, agrupar, ordem e recolher/expandir.
8. **Nenhum botão fica órfão numa quebra de linha.** Em telas estreitas, some primeiro o que é
   redundante, nunca a ação.
9. **Nenhum botão que some deixa o foco solto** no `<body>`.

### 6.3 Resultado vazio

- **Sem dados:** um convite para criar, com a ação primária.
- **Com filtros:** "Nenhum <item> com esses filtros" e "Limpar tudo".
- **Lista agrupada:** um grupo vazio nos filtros atuais não aparece, e uma linha discreta no fim diz
  quantos ficaram de fora.

## 7. Tabelas

- **Cabeçalho:** 11px/600 MAIÚSCULAS, em `--cor-tinta-3`, espaçamento .05em e fundo
  `--cor-superficie-2`.
- **Linha:** pelo menos 40px, células de 13px e hover em `--cor-acento-suave`.
- **Linha que abre um detalhe é clicável inteira**, e o nome ou a chave é um link de verdade, para o
  teclado.
- **Coluna ordenável** é um botão com ↑/↓ e `aria-sort`.
- **Texto longo** trunca com reticências **e** com o valor completo no `title`.
- **Números:** alinhados à direita, com algarismos tabulares. Vazio é "—", em `--cor-tinta-3`.
- **Nunca um identificador interno (UUID) à vista:** use o nome, a chave (`CHAVE-12`) ou o assunto. Se
  o registro sumiu, "(registro removido)".
- **Paginação no servidor**, 25 por página, com "Página X de Y — N resultados" e
  Anterior/Próxima, só quando há mais de uma página. Em lista agrupada, 20 por grupo e "Mostrar mais
  (N)". Sem rolagem infinita.
- **Ações em lote:** caixa de seleção por linha e por grupo, e uma barra flutuante com "N
  selecionados", as ações e "Limpar seleção".
- **Exportar** é "Exportar CSV", como botão secundário pequeno, desabilitado sem dados.
- **No celular**, a tabela vira cards.

## 8. Formulários e modais

### 8.1 Formulários

- **Rótulo acima do campo** (11px MAIÚSCULAS), com `*` no obrigatório e `aria-required`.
- **Campo:** 36px de altura e raio de controle. O foco aparece com o anel de 2px.
- **O texto de exemplo é exemplo, não rótulo** ("00.000.000/0000-00").
- **Validação:**
  - ao enviar, todos os erros aparecem, e o foco rola até o primeiro inválido;
  - depois do primeiro envio, o campo é conferido ao sair dele, e digitar apaga o erro.
- **Erro inline no campo:**
  - borda, ícone e texto logo abaixo, com `role="alert"`, `aria-invalid` e `aria-describedby`;
  - **sem banner de resumo**: só um aviso perto do botão de enviar quando o erro ficou fora da tela
    ("2 campos precisam de atenção · Ver");
  - erro da API que tem campo vai para o campo; o aviso flutuante fica só para o resto.
- **As mensagens de erro são frases com ponto final**, que dizem o que fazer ("Informe um CNPJ
  válido.").
- **Campos de máscara:** CPF, CNPJ (inclusive o alfanumérico), telefone com DDD e CEP, sempre com
  máscara e conferência do dígito.
- **Duração:**
  - aceita `01:30`, `1h30` e `90m`;
  - aparece sempre como "1h 30min";
  - nunca vira um campo de minutos crus.
- **Texto longo** (comentário, descrição, motivo) fica num **rascunho local** até o servidor
  confirmar: "Rascunho não enviado de … restaurado · Descartar". O rascunho é apagado ao salvar e ao
  sair do sistema.

### 8.2 Modais

- **Nunca fecham com clique fora.** Fecham pelo ×, por "Cancelar" e pelo Esc (só o modal do topo).
  Clique fora não salva nem descarta o que a pessoa digitou.
- **`Ctrl+Enter` (ou `Cmd+Enter`) envia**, com a dica visível no rodapé.
- **O foco fica preso dentro do modal** e, ao fechar, volta para quem abriu.
- **Enquanto salva**, o Esc e o envio travam, e o primário mostra "Salvando...".
- **Título:** 16/600. O rodapé fica fixo, com Cancelar à esquerda e o primário à direita.
- **Larguras:** 600px no padrão, 780px no largo e cerca de 480px nas confirmações curtas.

### 8.3 Edição no lugar

Quando a tela de detalhe edita no lugar, sem modal:
- **A dica de que dá para editar** (lápis ou fundo no hover) aparece só no que é editável.
- **Cada edição salva um campo só** (um PATCH).
- **Salvando, a linha mostra um spinner.** No erro, o valor volta ao salvo e a mensagem aparece
  abaixo do campo.
- **Esc cancela.**

## 9. Confirmação de ação destrutiva

- **Um diálogo único**, acima de qualquer modal:
  - **título** em pergunta ("Excluir comentário?");
  - **mensagem** com o impacto concreto ("1h 30min lançadas deixam de contar nas horas do ticket.");
  - **botão** de perigo, com o **foco inicial em Cancelar**: um Enter perdido nunca confirma.
- **Impacto grande exige digitar uma palavra** ("Digite ACEITO para confirmar"). Exclusão em cascata
  lista o que vai junto, com a contagem.
- **Quando dá, excluir manda para uma lixeira restaurável**, com prazo, e a confirmação diz o que vai
  para a lixeira e o que some de vez.

## 10. Avisos e estados

### 10.1 Avisos flutuantes

- **Resultado de ação é aviso flutuante**: um título curto e uma linha de detalhe, no canto inferior
  direito (no topo, no celular). Nunca um modal de "Sucesso!".
- **Duração por tipo:** sucesso 4s, informação 5s, atenção 7s e erro 10s.
- **No máximo 3 ao mesmo tempo.** Uma mensagem repetida vira "×2", e o aviso pausa com o mouse ou o
  foco em cima.
- **O erro leva `role="alert"`.**
- **Nunca texto técnico do servidor:** a mensagem passa por um filtro que só deixa sair texto feito
  para pessoas. Um 403 vira "Sem permissão".

### 10.2 Estados da tela

| Estado | Como |
|---|---|
| carregando | skeleton com `aria-busy` (ou "Carregando <coisa>..."), barra de 3px no topo durante a navegação |
| vazio | card centralizado com ícone, frase e ação (item 6.3) |
| erro | "Erro inesperado", com o código copiável, "Tentar de novo" e "Voltar" |
| sem permissão | "Sem permissão para ver isto"; o que a pessoa não pode usar nem aparece no menu |
| não encontrado | "Registro não encontrado" |
| sem conexão | faixa no topo: "Sem conexão com o servidor" |
| sessão vencida | modal "Sua sessão expirou · Entrar novamente", que volta à mesma página |

## 11. Badges e status

- **Badge:** 11px/600, raio de 6px, **sempre com texto** (nunca só cor). A prioridade é um ponto
  colorido mais o texto.
- **Significado fixo dos tons**, igual em todos os sistemas:

  | Tom | Significa |
  |---|---|
  | azul | aberto, a fazer, informativo |
  | âmbar | em andamento, atenção, média |
  | roxo | aguardando, bloqueado |
  | verde | resolvido, concluído, ativo, pago, baixa |
  | cinza | fechado, rascunho, expirado, neutro |
  | vermelho | crítico, atrasado, cancelado, erro |

  As cores dos tons vêm da paleta, com o par texto/fundo a pelo menos 4,5:1 nos dois temas.
- **O texto do status é um só** para o mesmo estado em todo o sistema. Os rótulos ficam num lugar
  único do código, nunca repetidos por tela.

## 12. Textos e formatos

- **pt-BR:**
  - frase com inicial maiúscula e o resto minúsculo ("Nova tarefa", não "Nova Tarefa");
  - acentos sempre;
  - termo em inglês só quando é nome de produto.
- **Tom:**
  - curto e humano, sem culpar a pessoa e sem emoji, sempre com o próximo passo ("Fale com um
    administrador");
  - gênero e plural certos ("1 campo precisa", "2 campos precisam").
- **Datas:**
  - dd/MM/aaaa e HH:mm, ou dd/MM dentro do ano atual;
  - na tela, no fuso de quem usa;
  - o que tem fuso de negócio (fechamento do dia, relatório) usa o fuso configurado no sistema;
  - tempo relativo é "há 5 min".
- **Moeda:** R$ 1.234,56, sempre com centavos (`Intl.NumberFormat('pt-BR', { style: 'currency',
  currency: 'BRL' })`).
- **Um formatador só no projeto**, para datas, moeda e duração. Formatador local em cada tela
  diverge.
- **Título da aba:** o nome do sistema.

## 13. Teclado

| Tecla | Faz |
|---|---|
| `/` | foca a busca da lista |
| `F` | abre "Mais filtros" |
| `Esc` | fecha o menu, o popover ou o modal do topo |
| `Ctrl/Cmd+Enter` | envia o formulário ou o modal |

Atalho de uma tecla é ignorado enquanto se digita e com modal aberto, e é anunciado no `title` do
controle ("Mais filtros (F)").

## 14. Desktop primeiro, sem quebrar no celular

- **O alvo é o computador**, em 1920 e 1440 de largura.
- **Abaixo de 768px:**
  - a lateral vira gaveta;
  - os filtros viram busca mais "Filtros (N)", numa folha que sobe de baixo, com os chips ativos
    removíveis logo abaixo;
  - a tabela vira cards;
  - os alvos sobem para 40px;
  - nada de rolagem horizontal da página.

## Checklist de PR com tela

- [ ] Capturas antes e depois, no claro e no escuro, em 1920 e 1440 (e 1024 quando o layout mudar).
- [ ] Mesma altura e raio em cada linha de controles; grade de 4/8.
- [ ] Uma ação primária por vista; hover, foco, desabilitado e carregando presentes.
- [ ] Nenhum `<select>` nativo nem data solta em barra; nenhuma cor fora dos papéis da paleta.
- [ ] Contraste AA nos dois temas.
- [ ] Tudo navegável só com o teclado; o Esc devolve o foco; `aria-*` corretos.
- [ ] Nenhuma informação repetida na mesma vista; nenhum UUID à vista.
- [ ] Carregando, vazio e erro tratados.
- [ ] Datas, moeda e duração pelo formatador do projeto.

## Nunca

- Dois primários lado a lado.
- Modal que fecha com clique fora.
- `outline: none` sem substituto.
- Status só por cor.
- Cor literal no componente.
- Texto técnico do servidor na tela.
