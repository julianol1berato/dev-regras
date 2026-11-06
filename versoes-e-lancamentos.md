# Versões e lançamentos

Uma versão responde a três perguntas: **o que está no ar**, **o que mudou desde a anterior** e
**como voltar se der errado**. Cada regra abaixo existe para que essas três respostas sejam
sempre fáceis.

## 1. O número: SemVer, decidido pelo changelog

A versão tem a forma `X.Y.Z` ([SemVer](https://semver.org/lang/pt-BR/)):

| Sobe | Quando | Exemplo |
|---|---|---|
| **Z** (o último) | só correções | 1.4.2 → 1.4.3 |
| **Y** (o do meio) | qualquer coisa nova ou mudada, sem quebrar o que já funcionava | 1.4.3 → 1.5.0 |
| **X** (o primeiro) | algo que funcionava deixa de funcionar do mesmo jeito: API que muda, campo que some, dado removido | 1.5.0 → 2.0.0 |

Na série **0.x** (antes da primeira versão estável), quebrar também sobe o do meio. O changelog
avisa a quebra com ⚠️.

**Quem decide o número é o conteúdo do changelog, não a vontade de quem lança.** Se a seção
`[Não lançado]` só tem Corrigido, a versão é de correção. Se tem um Acrescentado, é minor, mesmo
que seja pequeno. Assim o número diz algo verdadeiro: quem vê 1.4.3 → 1.4.4 sabe que pode
atualizar sem medo de mudança de comportamento.

## 2. O changelog

Um arquivo `CHANGELOG.md` na raiz, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/):

```markdown
## [Não lançado]

### Acrescentado
- Exportar o extrato em planilha.

### Corrigido
- O saldo não cruza mais de cliente quando dois ramais têm o mesmo número.

## [1.4.3] — 2026-10-14
...
```

- **Todo PR que muda comportamento acrescenta a linha no mesmo PR.** Deixar para escrever na hora
  de lançar é como se perde metade das mudanças.
- **Escreva na língua de quem usa o sistema**, não na de quem escreveu o código. "O saldo não cruza
  mais de cliente" serve para suporte, venda e cliente; "fix race em UpdateSaldo" não serve para
  ninguém além de quem escreveu.
- **Grupos**: Acrescentado, Modificado, Corrigido, Removido, Segurança. Use só os que tiver.
- **Mudança de banco diz o número da migração.** Depois que uma migração roda em produção, voltar de
  versão deixa de ser só trocar a imagem, e quem for voltar precisa saber disso pelo changelog.
- **Refatoração, teste e doc interna não entram**: o changelog é sobre o que muda para quem usa.
- Se o projeto entrega **dois produtos com versões independentes** (um servidor e um SDK, por
  exemplo), cada um tem a sua série de tags e o seu changelog. Um número que significa duas coisas
  é pior que número nenhum.

## 3. Lançar pequeno e com frequência

**Correção não espera funcionalidade.** Uma versão com 5 mudanças é fácil de testar, de explicar e
de desfazer. Uma com 150 commits e 15 migrações não é nenhuma das três coisas: se der problema,
ninguém sabe qual das mudanças causou, e voltar exige restaurar banco.

Regra prática: com mais de uma semana ou um punhado de PRs desde a última tag, feche uma versão.
Se o agente de IA notar isso, ele deve propor.

## 4. A tag

- A versão é uma **tag anotada** (`git tag -a`), com uma frase de resumo e as notas da seção do
  changelog.
- **A tag aponta para um commit que a CI já viu passar**, e que está no servidor do git (GitHub,
  GitLab). Nunca para uma árvore modificada.
- **Tag publicada nunca se move nem se apaga.** Se a versão saiu errada, a correção é a próxima
  versão. Mover a tag faz duas pessoas falarem da "1.4.3" e terem códigos diferentes.
- Use um alvo de `make` que confira tudo isso antes de criar a tag (veja `modelos/lancar.mk`).
  Regra que depende de lembrar acaba esquecida; regra que o `make` recusa, não.

## 5. A imagem e a produção

- A CI (ou um alvo de `make`) constrói a imagem **com a versão no nome**: `app:1.4.3`.
- **Não existe `latest` em produção.** `latest` é como se perde a conta do que está no ar: dois
  servidores com a mesma etiqueta e binários diferentes.
- **Produção nunca compila.** Ela puxa a imagem versionada e sobe. Compilar em produção dá um
  binário que não corresponde a commit nenhum.
- **A mesma imagem passa pela homologação antes**, não uma reconstruída "igual".

## 6. A ordem de um lançamento

1. `main` verde na CI.
2. Num PR, renomeie `[Não lançado]` para `## [X.Y.Z] — AAAA-MM-DD`, abra um `[Não lançado]` vazio
   acima dela, e faça o merge.
3. `make lancar VERSAO=X.Y.Z`: confere a seção datada, a árvore limpa e o commit no servidor, e
   cria e envia a tag.
4. A CI publica a imagem `app:X.Y.Z`.
5. Homologação com essa imagem; conferência.
6. Produção: aponte para `X.Y.Z` e suba.

## 7. Correção urgente quando a `main` já está à frente

Às vezes a produção tem um defeito e a `main` já tem coisa nova que ainda não pode sair. A saída é
uma **linha de correção a partir da tag que está no ar**:

```bash
git switch -c correcao/1.4.4 v1.4.3   # parte do que está em produção, não da main
# corrija, com teste; no CHANGELOG desta linha, a seção ## [1.4.4] — AAAA-MM-DD
git push -u origin correcao/1.4.4      # a CI roda
make lancar VERSAO=1.4.4               # a tag sai desta linha
```

Depois, **leve a linha de volta para a `main`** (merge da linha na `main`, nunca o contrário) e
acerte o `[Não lançado]` da `main` para não anunciar de novo o que já saiu.

### E os dois branches fixos, como no ai-memory?

O ai-memory mantém dois branches o tempo todo: `main` só com correções (de onde saem as 3.2.x) e
`release/3.3` com as novidades da próxima minor. Correções entram na `main` e são levadas para o
`release/3.3`, nunca o contrário. Quando a minor fica pronta, o `release/3.3` volta para a `main` e
a versão sai de lá.

Isso compensa quando **muita gente instala o seu software** e as novidades levam semanas para
amadurecer. Para uma equipe pequena que lança o próprio serviço, é cerimônia demais: uma `main`
com tags frequentes e a linha de correção do item acima, criada só quando precisa, resolvem o
mesmo problema.

## 8. Voltar de versão

Voltar é apontar a produção para a tag anterior e subir. Funciona sempre, **desde que nenhuma
migração de banco tenha rodado** entre as duas versões. Se rodou, voltar exige restaurar o banco ou
uma migração de volta, e por isso o changelog diz cada migração. Antes de lançar uma versão com
migração, saiba qual é o plano de volta.

## 9. CI: os portões, em todo PR

- Os mesmos comandos de "antes de dar algo por pronto" do projeto (build, tipos, lint, testes),
  rodando **em todo PR, em todo push na `main` e em toda tag**. Teste que só roda se alguém lembrar
  não protege nada.
- Um **aviso** (que não bloqueia) quando o código muda e o changelog não. Bloquear irrita quando a
  mudança não é visível; o aviso basta para lembrar.
- Testes que dependem de um serviço que a CI não tem (um banco de desenvolvimento, por exemplo)
  podem se pular com uma mensagem clara, mas devem continuar rodando na máquina de quem desenvolve.

## 10. Nunca

- Tag sem seção datada no changelog.
- Imagem construída de árvore modificada.
- `latest` em produção.
- Mover ou apagar uma tag publicada.
- Compilar em produção.
- Deixar a `main` semanas sem versão.

## Checklist de um lançamento

- [ ] `main` verde na CI
- [ ] `[Não lançado]` revisado: tudo na língua de quem usa, migrações citadas
- [ ] número escolhido pela regra do item 1
- [ ] PR que data a seção, já com merge
- [ ] `make lancar VERSAO=…` sem recusa
- [ ] imagem publicada com a versão no nome
- [ ] homologação com a mesma imagem
- [ ] plano de volta conhecido (há migração?)
- [ ] produção atualizada e conferida
