DOC_BUILDCMD = sphinx-build
DOC_DIR = doc
HELPER_DIR = helpers
TEST_DIR = test
KCOV_DIR = coverage

.PHONY: help clean doc simpletest test timings coverage shellcheck dependencies i18n

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  doc        to make HTML documentation in $(DOC_DIR)/_build/html"
	@echo "  todo       to show a list of all todo's in the code"
	@echo "  test       to run all tests in the code"
	@echo "  simpletest to run a quick test of the code"
	@echo "  timings    to show how long each shell tests the code"
	@echo "  shellcheck to statically check all code using shellcheck"
	@echo "  coverage   to generate a test coverage report in $(KCOV_DIR)/index.html"
	@echo "  clean      to remove all generated documentation and coverage reports"

clean:
	rm -rf $(DOC_DIR)/_*
	rm -rf $(KCOV_DIR)
	rm -rf $(TEST_DIR)/shunit2
	rm -rf enSHure.pot
	rm -rf src/locale

todo:
	@find -name '*.sh' -o -name '*.rst' -o -name enshure | xargs grep TODO | awk -F: '{ gsub("*",""); printf "%s:%-35s %s\n", $$2, $$3, $$1}' | sed 's|^\s*#\s*||g'

doc:
	mkdir -p  $(DOC_DIR)/_templates
	mkdir -p  $(DOC_DIR)/_static
	# Set version
	sed -i "s/version = .*/version = $$(grep '^_VERSION' src/core/version.sh | cut -d= -f2)/" $(DOC_DIR)/conf.py
	# Create autogenerated indexes
	$(HELPER_DIR)/shelldoc.py -r '[a-z][a-z_]*' -p src functions src/bin/enshure src/*/*.sh > $(DOC_DIR)/reference/function_idx.rst
	$(HELPER_DIR)/shelldoc.py -r '__[a-z_]+' -p src functions src/bin/enshure src/*/*.sh > $(DOC_DIR)/reference/internal_function_idx.rst
	$(HELPER_DIR)/shelldoc.py -r '[A-Z_]+' -p src globals src/bin/enshure src/*/*.sh  > $(DOC_DIR)/reference/global_idx.rst
	$(DOC_BUILDCMD) -b html $(DOC_DIR) $(DOC_DIR)/_build/html
	@echo
	@echo "The HTML documentation is in $(DOC_DIR)/_build/html."

$(TEST_DIR)/shunit2:
	([ -e "/usr/share/shunit2/shunit2" ] && ln -s "/usr/share/shunit2/shunit2" $(TEST_DIR)/shunit2) || (cd $(TEST_DIR) && wget "https://github.com/kward/shunit2/raw/master/source/2.1/src/shunit2")

test: shellcheck $(TEST_DIR)/shunit2
	bash $(TEST_DIR)/core.sh
	dash $(TEST_DIR)/core.sh
	ksh  $(TEST_DIR)/core.sh
	mksh $(TEST_DIR)/core.sh
	SHUNIT_PARENT="$(TEST_DIR)/core.sh" zsh -y $(TEST_DIR)/core.sh

simpletest: $(TEST_DIR)/shunit2
	sh $(TEST_DIR)/core.sh

coverage:
	rm -rf "$(KCOV_DIR)"
	kcov --include-path=./src "./$(KCOV_DIR)" "$(TEST_DIR)/core.sh"

timings:
	@/usr/bin/time -f "bash: %e seconds, CPU %P, MEM %Mkb" bash $(TEST_DIR)/core.sh > /dev/null
	@/usr/bin/time -f "dash: %e seconds, CPU %P, MEM %Mkb" dash $(TEST_DIR)/core.sh > /dev/null
	@/usr/bin/time -f "ksh:  %e seconds, CPU %P, MEM %Mkb" ksh $(TEST_DIR)/core.sh > /dev/null
	@/usr/bin/time -f "mksh: %e seconds, CPU %P, MEM %Mkb" mksh $(TEST_DIR)/core.sh > /dev/null
	@SHUNIT_PARENT="$(TEST_DIR)/core.sh" /usr/bin/time -f "zsh:  %e seconds, CPU %P, MEM %Mkb" zsh -y "$(TEST_DIR)/core.sh" > /dev/null

shellcheck:
	shellcheck -s sh src/bin/enshure
	find src -name '*.sh' | xargs shellcheck -s sh
	find $(TEST_DIR) -name '*.sh' | xargs shellcheck -s sh

dependencies:
	@strace -f -e execve test/core.sh 2>&1 | grep -o 'execve("[A-Z|a-z|/|0-9]*"' | cut -d'"' -f2 | sort | uniq

i18n:
	find src -name '*.sh' | xargs xgettext --from-code utf-8 -o src/po/enSHure.pot  -L Shell --keyword --keyword=translate
	mkdir -p src/locale/nl/LC_MESSAGES
	cd src/po && msgmerge -U nl.po enSHure.pot
	cd src/po && msgfmt -v  nl.po -o ../locale/nl/LC_MESSAGES/enSHure.mo

