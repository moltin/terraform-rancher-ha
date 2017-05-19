.PHONY: docs
docs: ## terraform docs
	@$(MAKE) pull-extra-docs && \
	\
	bin/docs && \
	\
	rm docs/RESOURCES.md && \
	\
	$(MAKE) changelog

.PHONY: changelog
changelog: ## generate changelog
	@docker run --rm -it -v $$(pwd):/code moltin/gitchangelog > CHANGELOG.md

pull-extra-docs: ## pull extra documentation to be used by the docs task
	@git clone -q git@github.com:moltin/terraform-modules.git tmp && \
	cd tmp && \
	git filter-branch -f --prune-empty --subdirectory-filter docs --index-filter 'git rm -q --cached --ignore-unmatch $$(git ls-files | grep -v "RESOURCES.md")' && \
	mv *.md ../docs && \
	cd .. && \
	rm -rf tmp
