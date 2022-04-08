all: preview

build:
	mkdocs build

deploy:
	mkdocs gh-deploy --force
#	mkdocs gh-deploy --remote-branch windows-client-HPC --remote-name klust.github.io --site-dir windows-client-HPC

check test:
	mkdocs build --strict

preview serve:
	mkdocs serve
