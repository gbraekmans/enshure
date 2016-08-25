DOC_BUILDCMD = sphinx-build-3
DOC_DIR = doc
HELPER_DIR = helpers
TEST_DIR = test
TEST_FILENAME = all_tests.sh

.PHONY: help clean doc test timings shellcheck

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  doc        to make HTML documentation in $(DOC_DIR)/_build/html"
	@echo "  todo       to show a list of all todo's in the code"
	@echo "  test       to run all tests in the code"
	@echo "  timings    to show how long each shell tests the code"
	@echo "  shellcheck to statically check all code using shellcheck"
	@echo "  clean      to reset the project in the initial state"

clean:
	rm -rf $(DOC_DIR)/_*
	rm -rf "$(TEST_DIR)/$(TEST_FILENAME)"

todo:
	@find -name '*.sh' -o -name '*.rst' -o -name enshure | xargs grep TODO | awk -F: '{ gsub("*",""); printf "%s:%-35s %s\n", $$2, $$3, $$1}' | sed 's|^\s*#\s*||g'

doc:
	mkdir -p  $(DOC_DIR)/_templates
	mkdir -p  $(DOC_DIR)/_static
	$(HELPER_DIR)/shelldoc.py -r '[a-z][a-z_]*' -p src functions src/bin/enshure src/*/*.sh > $(DOC_DIR)/code/function_idx.rst
	$(HELPER_DIR)/shelldoc.py -r '__[a-z_]+' -p src functions src/bin/enshure src/*/*.sh > $(DOC_DIR)/code/internal_function_idx.rst
	$(HELPER_DIR)/shelldoc.py -r '[A-Z_]+' -p src globals src/bin/enshure src/*/*.sh  > $(DOC_DIR)/code/global_idx.rst
	$(HELPER_DIR)/help_to_rst.py src/core/help.txt > $(DOC_DIR)/user/help_query_mode.rst
	$(DOC_BUILDCMD) -b html $(DOC_DIR) $(DOC_DIR)/_build/html
	@echo
	@echo "The HTML documentation is in $(DOC_DIR)/_build/html."

$(TEST_DIR)/$(TEST_FILENAME): $(TEST_DIR)/common.sh
	echo '#!/bin/sh' > "$(TEST_DIR)/$(TEST_FILENAME)"
	find "$(TEST_DIR)/core" -name '*.sh' | sort | xargs cat >> "$(TEST_DIR)/$(TEST_FILENAME)"
	cat "$(TEST_DIR)/common.sh" >> "$(TEST_DIR)/$(TEST_FILENAME)"
	chmod +x "$(TEST_DIR)/$(TEST_FILENAME)"

test: shellcheck $(TEST_DIR)/$(TEST_FILENAME)
	bash $(TEST_DIR)/$(TEST_FILENAME)
	dash $(TEST_DIR)/$(TEST_FILENAME)
	ksh  $(TEST_DIR)/$(TEST_FILENAME)
	mksh $(TEST_DIR)/$(TEST_FILENAME)
	SHUNIT_PARENT="$(TEST_DIR)/$(TEST_FILENAME)" zsh -y "$(TEST_DIR)/$(TEST_FILENAME)"

timings: $(TEST_DIR)/$(TEST_FILENAME)
	@/usr/bin/time -f "bash: %e seconds, CPU %P, MEM %Mkb" bash $(TEST_DIR)/$(TEST_FILENAME) > /dev/null
	@/usr/bin/time -f "dash: %e seconds, CPU %P, MEM %Mkb" dash $(TEST_DIR)/$(TEST_FILENAME) > /dev/null
	@/usr/bin/time -f "ksh:  %e seconds, CPU %P, MEM %Mkb" ksh $(TEST_DIR)/$(TEST_FILENAME) > /dev/null
	@/usr/bin/time -f "mksh: %e seconds, CPU %P, MEM %Mkb" mksh $(TEST_DIR)/$(TEST_FILENAME) > /dev/null
	@SHUNIT_PARENT="$(TEST_DIR)/$(TEST_FILENAME)" /usr/bin/time -f "zsh:  %e seconds, CPU %P, MEM %Mkb" zsh -y "$(TEST_DIR)/$(TEST_FILENAME)" > /dev/null

shellcheck: $(TEST_DIR)/$(TEST_FILENAME)
	shellcheck -s sh src/bin/enshure
	find -name '*.sh' | xargs shellcheck -s sh
