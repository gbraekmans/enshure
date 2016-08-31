#!/bin/sh

set -u
set -e

for po in src/po/*.po; do
	lang=${po%.po}
	lang=${lang#src/po/}
	mkdir -p src/locale/${lang}/LC_MESSAGES
	(cd src/po && msgmerge -U ${lang}.po enSHure.pot)
	msgfmt -v  src/po/${lang}.po -o src/locale/${lang}/LC_MESSAGES/enSHure.mo
done
