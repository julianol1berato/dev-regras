<!--
  Cole esta seção no CLAUDE.md de um sistema com telas e troque o que está entre <…>.
  As políticas completas, com o porquê de cada regra: login-e-acesso.md, cores.md, interface.md e
  conformidade.md, no repositório dev-regras.
-->

## Login, cores e interface — vale sempre; leia antes de mexer em qualquer tela

1. **Login só pelo pacote compartilhado** (`<pacote de login>`), nunca código de provedor de
   identidade escrito aqui.
   - Quem entra começa sem acesso e pede. Os papéis são sem acesso, leitor (só GET) e admin.
   - O primeiro admin vem de `<VARIÁVEL DE ADMINS>`.
   - As rotas são as de `/auth/*` da política.
   - Login desligado só com `AUTH_DISABLED=true` ou escutando no loopback.
2. **Cor só por papel da paleta** (`--cor-*`, `--serie-*`, `--status-*`), da versão
   `<versão da paleta>`.
   - Nunca hex, `rgb()`, classe de cor do framework nem passo de rampa num componente.
   - Todo sistema funciona no claro e no escuro.
   - Cor nunca é a única pista.
3. **Uma ação primária por tela.**
   - Cancelar à esquerda e o primário à direita.
   - Hover, foco, desabilitado e carregando em todo botão.
   - Nunca `outline: none` sem substituto.
4. **Medidas só da escala:**
   - espaçamento 4/8 (4, 8, 12, 16, 24, 32, 48);
   - controles de 28, 32 e 36px (40px em toque);
   - raios de 6, 8, 12 e 999px;
   - texto em 20, 16, 14, 13, 12 e 11px.

   Numa mesma linha, todos os controles têm a mesma altura e o mesmo raio.
5. **A estrutura da tela:**
   - a barra superior é a faixa da marca, com a pesquisa global (`Ctrl/Cmd+K`);
   - um endereço que não existe mostra "Página não encontrada" dentro da estrutura;
   - dinheiro usa o campo de moeda com máscara, nunca `type="number"`.
6. **Toda lista usa a barra de filtros padrão:**
   - a ordem é busca (pílula de 32px, atalho `/`, 300ms, valor no endereço), liga/desliga,
     seletores, "Mais filtros (N)" e "Limpar tudo" por último;
   - todo filtro é chip;
   - nunca `<select>` nativo nem data solta na barra.
7. **Tabelas:**
   - cabeçalho 11px MAIÚSCULAS e linha de pelo menos 40px;
   - linha clicável com um link de verdade, e coluna ordenável com `aria-sort`;
   - vazio é "—", números com algarismos tabulares, e nunca UUID à vista;
   - 25 por página, no servidor.
8. **Formulários:**
   - rótulo acima, `*` no obrigatório, e o texto de exemplo é exemplo;
   - erro inline no campo, sem banner de resumo, com o foco indo para o primeiro inválido;
   - texto longo com rascunho local.
9. **Modais e confirmação:**
   - o modal não fecha com clique fora; `Ctrl/Cmd+Enter` envia, e o foco volta a quem abriu;
   - ação destrutiva passa pelo diálogo único, com o impacto concreto e o foco em Cancelar.
10. **Estados e avisos:**
    - carregando, vazio (sem dados e com filtros), erro, sem permissão e não encontrado tratados em
      toda tela;
    - resultado de ação é aviso flutuante, nunca modal de "Sucesso!" nem texto técnico do servidor.
11. **Textos e formatos:**
    - pt-BR com acento, só a inicial maiúscula, sem emoji;
    - datas dd/MM/aaaa HH:mm, moeda R$ 1.234,56 e duração "1h 30min", todos pelo formatador único
      de `<caminho dos formatadores>`.
12. **Tela antiga que você tocar entra nestas regras no mesmo PR.** PR com tela leva as capturas
    antes e depois, no claro e no escuro, em 1920 e 1440.
13. **Não desligue uma checagem de conformidade para o PR passar.** Exceção é com o dono do padrão,
    com motivo e prazo.
