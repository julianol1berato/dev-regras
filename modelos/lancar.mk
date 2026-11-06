# lancar: marca uma versão. Confere o CHANGELOG, cria a tag anotada com a frase e
# as notas da seção, e a envia ao remoto (GitHub ou GitLab). Só marca: publicar a
# imagem e subir em produção continuam passos separados, porque a tag é o registro
# do que foi lançado, e subir é uma decisão.
#
# Uso:  make lancar VERSAO=v1.4.3 RESUMO='o extrato sai em planilha'
#
# Recusa, cada uma com o motivo:
#   - VERSAO ausente ou fora do formato <PREFIXO_TAG>X.Y.Z (a versão de um
#     lançamento nunca vem de `git describe`);
#   - RESUMO ausente (a frase da tag, na língua de quem usa);
#   - árvore modificada (a tag tem de corresponder a um commit);
#   - commit que não está no remoto (a CI tem de ter visto passar);
#   - tag que já existe (tag publicada não se move);
#   - CHANGELOG.md sem a seção `## [X.Y.Z] — AAAA-MM-DD` (versão sem nota é
#     versão que ninguém sabe dizer o que trouxe).
#
# Para incluir num Makefile existente: `include modelos/lancar.mk`, ou copie o
# bloco. Exige bash.

SHELL := /bin/bash
PREFIXO_TAG ?= v
CHANGELOG ?= CHANGELOG.md
REMOTO ?= origin

.PHONY: lancar
lancar:
	@if [ "$(origin VERSAO)" != "command line" ]; then \
	    echo "  ⚠️  Chame com VERSAO=$(PREFIXO_TAG)X.Y.Z RESUMO='…'."; exit 1; fi
	@[[ "$(VERSAO)" =~ ^$(PREFIXO_TAG)[0-9]+\.[0-9]+\.[0-9]+$$ ]] || { \
	    echo "  ⚠️  VERSAO=\"$(VERSAO)\" não é $(PREFIXO_TAG)X.Y.Z."; exit 1; }
	@[ -n "$(RESUMO)" ] || { \
	    echo "  ⚠️  Falta RESUMO='…': a frase da tag, na língua de quem usa."; exit 1; }
	@[ -z "$$(git status --porcelain)" ] || { \
	    echo "  ⚠️  A árvore está modificada: commite (ou guarde) antes de lançar."; exit 1; }
	@git fetch -q $(REMOTO) --tags
	@[ -n "$$(git branch -r --contains HEAD)" ] || { \
	    echo "  ⚠️  Este commit não está em $(REMOTO): dê push e deixe a CI passar antes."; exit 1; }
	@! git rev-parse -q --verify "refs/tags/$(VERSAO)" >/dev/null || { \
	    echo "  ⚠️  A tag $(VERSAO) já existe, e tag publicada não se move."; exit 1; }
	@v="$(patsubst $(PREFIXO_TAG)%,%,$(VERSAO))"; \
	  grep -qE "^## \[$${v//./\\.}\] — [0-9]{4}-[0-9]{2}-[0-9]{2}$$" $(CHANGELOG) || { \
	    echo "  ⚠️  $(CHANGELOG) não tem a seção '## [$$v] — AAAA-MM-DD'."; \
	    echo "      Renomeie [Não lançado] para a versão, com a data, num PR, e faça o merge."; \
	    exit 1; }
	@v="$(patsubst $(PREFIXO_TAG)%,%,$(VERSAO))"; \
	  notas=$$(awk -v cab="## [$$v] " 'index($$0, cab) == 1 { dentro = 1; next } dentro && /^## \[/ { exit } dentro' $(CHANGELOG)); \
	  git tag -a --cleanup=whitespace "$(VERSAO)" -m "$(VERSAO) — $(RESUMO)" -m "$$notas" && git push -q $(REMOTO) "$(VERSAO)"
	@echo "  lançada: $(VERSAO)"
