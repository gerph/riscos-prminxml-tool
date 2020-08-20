COMPONENT = riscos-prminxml

TOOL = ${ROTOOL_DIR}/riscos-prminxml
RESOURCES = ${ROTOOL_DIR}/riscos-prminxml-resources

CATALOG_SRC = ../catalog

.PHONY: dirs catalog tool

all: cross_install

cross_export:
	@echo No exports

cross_install: \
		tool_dir \
		${TOOL}
	@echo Installed to ${TOOL}

tool: ${TOOL}

tool_dir:
	mkdir -p ${RESOURCES}

catalog: dirs
	cp -R "${CATALOG_SRC}"/* "${RESOURCES}"

${TOOL}: ../process.pl dirs catalog
	sed "s/VERSION/$${CI_BRANCH_VERSION:-VERSION}/" ../process.pl > $@
	chmod 755 $@

clean:
	@echo Nothing to clean.
