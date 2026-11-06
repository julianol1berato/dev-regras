# Cores

Todo sistema usa a mesma paleta, **Areia · Navy · Ardósia**, mantida no repositório
[color-navy](https://github.com/julianol1berato/color-navy): areia nas superfícies, ardósia no
texto, navy na marca e na interação. A paleta já traz o tema claro e o escuro, e o contraste e a
distância de cor para daltonismo são calculados por um script, não no olho. Esta página diz como
usá-la num sistema. As cores em si, os valores e o porquê de cada uma estão no README da paleta.

## 1. A paleta entra por versão

- **O sistema usa o `tokens.css` de uma versão da paleta**, e a versão fica registrada no projeto.
- **Subir de versão é um PR**, como qualquer dependência.

Sem versão, uma mudança na paleta muda todos os sistemas no mesmo dia, sem revisão em nenhum.

## 2. O código fala em papéis, nunca em cor

- **Use os papéis**: `--cor-*` na interface, `--serie-*`, `--seq-*`, `--div-*` e `--status-*` nos
  dados.
- **Nada de hex, `rgb()` ou passo de rampa** (`--navy-700`) no código do sistema. A única exceção é o
  próprio `tokens.css`.

É isso que deixa o tema escuro de graça e a paleta trocável: o sistema que só fala em papéis muda
de tema e de versão sem uma linha alterada. Também é uma regra que dá para conferir na CI
([`conformidade.md`](conformidade.md)).

## 3. Claro, escuro e o do sistema

Todo sistema funciona nos dois temas e oferece **Claro, Escuro e Sistema**. Sem escolha da pessoa,
vale o tema do sistema operacional. Com os papéis da regra 2, o tema escuro não custa trabalho, e
quem passa o dia com o sistema aberto escolhe o que cansa menos a vista.

## 4. A faixa da marca

- **A identidade aparece num lugar forte**: o cabeçalho de todo sistema é a faixa navy
  (`--cor-marca-fundo`) com o nome em areia.
- **O resto da tela é areia e ardósia.** O navy volta só no que é ação ou escolha: o botão
  principal, o item ativo, o link, os títulos dos cartões.
- **Dentro da faixa, os controles usam os papéis da faixa**, como mostra o README da paleta.

Uma faixa só, igual em todos os sistemas, diz "isto é da empresa" sem precisar de logo grande, e
navy espalhado pela tela inteira deixa de indicar onde clicar.

## 5. Cada cor de dado faz um trabalho só

| Trabalho | Pergunta | Papéis |
|---|---|---|
| identidade | "qual é este?" | `--serie-1` … `--serie-8`, `--serie-contexto`, `--serie-outros` |
| quantidade | "quanto?" | `--seq-1` … `--seq-9` |
| lado | "acima ou abaixo da referência?" | `--div-n4` … `--div-0` … `--div-p4` |
| estado | "está bom ou ruim?" | `--status-bom`, `-atencao`, `-alerta`, `-critico` |

- **A ordem das séries é fixa, e a cor segue a entidade, não a posição.**
- **Nada de nona cor**: da nona série em diante, agrupe em "outros".
- **Status nunca vira cor de série**, e nem o contrário.

As regras completas de gráfico estão no README da paleta.

## 6. A cor nunca é a única pista

- **Status leva sempre ícone e rótulo** (✓ bom, ! atenção, ▲ alerta, ✕ crítico), além da cor.
- **Texto é sempre tinta** (`--cor-tinta`, `-2`, `-3`) ou `--status-*-texto`. A cor da série vai na
  marca ao lado, nunca na letra.
- **Gráfico com duas séries ou mais tem legenda.**

Uma em cada doze pessoas não distingue bem algumas cores, e numa tela projetada ninguém distingue.

## 7. Cor nova entra na paleta, não no sistema

Se faltar uma cor, ela é proposta no repositório da paleta, passa pelo `scripts/verificar.mjs`
(contraste e daltonismo nos dois temas) e sai numa versão nova. Cor criada dentro de um sistema
não foi conferida por ninguém e só existe nele.

## 8. Fonte e números

- **A fonte é a do sistema operacional** (`--fonte`). Nenhuma fonte baixada de serviço externo.
- **Colunas de números e eixos usam algarismos tabulares** (`--fonte-numeros`) e ficam alinhados à
  direita.

A fonte do sistema carrega na hora e não depende de rede. Algarismos tabulares deixam os números
de uma coluna comparáveis de relance.

## Nunca

- Hex, `rgb()` ou passo de rampa no código do sistema.
- Cor criada fora da paleta.
- Status só por cor.
- Um tema só.
- Fonte de CDN externo.
