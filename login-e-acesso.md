# Login e acesso

Todo sistema interno entra pelo provedor de identidade da empresa (Entra ID ou outro OpenID
Connect) e controla, ele mesmo, o que cada pessoa pode fazer. **O login diz quem é a pessoa; o
acesso diz o que ela pode.** As regras abaixo valem para todo sistema novo e são cumpridas por um
pacote de login compartilhado: quem desenvolve o sistema não escreve código de provedor de
identidade, porque código de login escrito à mão em cada projeto é onde as falhas de segurança
moram.

A cara das telas (perfil, sem acesso, acessos) está em [`interface.md`](interface.md).

## 1. Login só pelo provedor da empresa

- **OpenID Connect com code + PKCE**, num registro de tenant único, e o ID token conferido
  (emissor, público, `nonce`, validade).
- **Nada de senha própria**: o sistema não tem tela de cadastro, não guarda senha e não tem "esqueci
  minha senha".

Uma senha a mais por sistema é uma senha a mais para vazar, e desligar alguém vira uma lista de
sistemas para lembrar. Com o provedor da empresa, quem é desligado no diretório perde o acesso a
todos de uma vez.

## 2. Quem entra começa sem acesso

- **Qualquer conta membro do tenant consegue entrar**, mas cai numa tela "sem acesso", com um botão
  "Pedir acesso".
- **O pedido chega ao admin do sistema**, que vê o número de pedidos pendentes no menu.

Deixar o login aberto e o acesso fechado faz o pedido chegar sozinho, sem e-mail nem chamado, e o
admin sabe exatamente quem pediu, porque a pessoa já está identificada.

## 3. Três papéis

| Papel | O que pode |
|---|---|
| sem acesso | só as telas do pacote: pedir acesso e sair |
| leitor | ler: só `GET` e `HEAD` nas rotas do sistema |
| admin | tudo, inclusive a tela de acessos |

Um papel a mais só entra quando o sistema precisar dele, e o leitor continua só lendo. Com três
papéis, qualquer pessoa entende o que o outro pode sem abrir o código, e a regra do leitor é
conferida pelo método HTTP, não por tela.

## 4. O primeiro admin vem da configuração

- **Os admins iniciais ficam numa variável de ambiente**, como uma lista de padrões de e-mail (por
  exemplo `nome.sobrenome@*`, que casa com a mesma pessoa em mais de um domínio da empresa).
- **O padrão só vale para conta membro do tenant**, nunca para convidado.
- **Os outros papéis são dados pela tela de acessos**, por pessoa ou por grupo do diretório.

Assim, um sistema novo nunca nasce trancado: o dono entra e já é admin, sem ninguém mexer no
banco. Restringir o padrão aos membros impede que um convidado com um e-mail parecido vire admin.

## 5. Acesso por grupo do diretório

- **Uma regra de grupo dá um papel a todo mundo do grupo** (por exemplo, "TI → leitor").
- **O papel efetivo é o maior** entre o da pessoa e o de todos os grupos dela que têm regra.
- **Os grupos vêm do token**, pelo nome. Se a pessoa estiver em grupos demais e o token vier sem
  eles (o *overage* do Entra), as regras de grupo não valem para ela até o próximo login com os
  grupos, e o papel dado por pessoa continua valendo.

Liberar por grupo tira do admin o trabalho de dar acesso pessoa por pessoa, e quem sai do grupo no
diretório perde o papel no próximo login.

## 6. Convidados ficam de fora

Conta de convidado (de outro tenant) é recusada no login. Aceitar convidados é uma configuração
explícita do sistema, e mesmo assim o convidado nunca casa com o padrão de admin da regra 4.

## 7. O papel sai do banco, não do cookie

- **O cookie de sessão leva só a identidade.**
- **O papel é lido do banco do sistema a cada requisição**, com um cache curto (segundos).

Tirar um acesso vale na hora, sem esperar a sessão vencer.

## 8. A sessão

- **Cookie assinado**, com o prefixo `__Host-`, `HttpOnly`, `Secure` e `SameSite=Lax`.
- **Vence com 12 horas sem uso e nunca passa de 24 horas desde o login**: quem foi desligado no
  diretório sai em no máximo um dia.
- **Sem estado no servidor**: reiniciar o sistema não derruba ninguém.
- **Proteção contra requisição de outra origem** (CSRF) em tudo que não é leitura, e respostas
  autenticadas sem cache compartilhado.
- **Sair é um `POST`**, nunca um link que um `<img>` consiga disparar.

## 9. As mesmas rotas em todos os sistemas

| Rota | Para quê |
|---|---|
| `/auth/entrar` | começa o login (aceita `?volta=` com um caminho do próprio sistema) |
| `/auth/retorno` | o retorno do provedor; é a única URI de retorno do registro |
| `/auth/sair` | encerra a sessão (`POST`) |
| `/auth/eu` | quem está logado, o papel e, para admin, os pedidos pendentes |
| `/auth/sem-acesso` | a tela de quem ainda não tem papel, com "Pedir acesso" |
| `/auth/acessos` | a tela do admin: pessoas, pedidos e regras de grupo |

O `?volta=` só aceita caminho interno, nunca outro domínio. Rotas fixas deixam o registro no
provedor igual em todo sistema, e a mesma checagem automática confere todos os sistemas.

## 10. A tela de acessos e o histórico

- **A tela lista quem já entrou** (com o último acesso), os pedidos pendentes e as regras de grupo,
  e deixa dar, trocar e tirar papéis.
- **Toda ação vai para um histórico que só cresce**: quem fez, o quê, sobre quem e quando. Os
  pedidos de acesso também entram nele.

O histórico responde "quem deu acesso a esta pessoa?" sem depender da memória de ninguém.

## 11. O que não passa pelo login

- **A rota de saúde** responde sem login, e não mostra dado nenhum.
- **Leitura entre sistemas** usa um token próprio da integração, só nas rotas listadas para ela,
  nunca a sessão de uma pessoa.

## 12. Desenvolvimento local sem login, só quando dito

O login só pode ficar desligado em dois casos: quando a configuração diz isso explicitamente
(`AUTH_DISABLED=true`) ou quando o sistema escuta só no endereço local (`127.0.0.1`/`::1`). Sem o
registro no provedor e fora desses dois casos, o sistema não sobe.

Assim, quem desenvolve trabalha na própria máquina sem precisar de credencial do provedor, e um
sistema publicado sem login por esquecimento falha na subida, em vez de ficar aberto.

## Nunca

- Senha própria ou tela de cadastro.
- Papel guardado no cookie.
- Login desligado por omissão, sem `AUTH_DISABLED=true`.
- Convidado como admin.
- `?volta=` para fora do sistema.
- Código de login escrito no projeto, em vez do pacote compartilhado.
