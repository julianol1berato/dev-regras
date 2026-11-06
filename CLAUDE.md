# dev-regras — instruções para o Claude

## O que é este repositório

Regras de trabalho genéricas, para qualquer projeto, escritas em pt-BR: versões e lançamentos
(`versoes-e-lancamentos.md`), revisão e aprovação (`revisao-e-aprovacao.md`) e trabalho com
agentes de IA (`agentes-de-ia.md`), com modelos prontos para copiar em `modelos/`. E o padrão
dos sistemas internos: login e acesso (`login-e-acesso.md`), cores (`cores.md`, sobre a paleta do
repositório color-navy), interface (`interface.md`) e conformidade (`conformidade.md`).

## ⚠️ Este repositório é PÚBLICO

Tudo o que entra aqui fica visível para qualquer pessoa. Antes de cada commit, confira que nada
disto entrou, nem em exemplo:

- nome de servidor, IP, domínio interno, rede ou VPN;
- nome de cliente, de empresa contratante ou de projeto privado;
- caminho de máquina pessoal, usuário de sistema, e-mail que não seja público;
- token, senha, chave, ou trecho de `.env`;
- detalhe de arquitetura ou de negócio de um projeto privado.

Exemplos usam nomes neutros (`app`, `v1.4.3`, "o saldo não cruza mais de cliente"). Uma regra
aprendida num projeto privado entra aqui **generalizada**: o princípio e o porquê, sem a história
de onde veio.

## Como escrever

- Cada regra diz **o porquê**. Regra sem motivo vira cerimônia e é a primeira a ser pulada.
- Direto e curto: frase de ação, tabela quando compara, exemplo quando o texto não basta.
- Modelo em `modelos/` é **testado antes de entrar**: um alvo de `make` ou um workflow que não
  funciona ensina errado. Teste num repositório descartável, não num real.
- Mudou uma regra → atualize o resumo do `README.md` e o modelo correspondente na mesma entrega.

## Versões deste repositório

Este repositório segue as próprias regras: `CHANGELOG.md` com `[Não lançado]`, tags `vX.Y.Z`.
