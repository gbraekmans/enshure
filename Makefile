DOC_BUILDCMD   = sphinx-build-3
DOC_DIR   = doc
HELPER_DIR = helpers

.PHONY: help clean doc

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  doc        to make HTML documentation in $(DOC_DIR)/_build/html"
	@echo "  todo       to show a list of all todo's in the code"
	@echo "  clean      to reset the project in the initial state"

clean:
	rm -rf $(DOC_DIR)/_*

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
