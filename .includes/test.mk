#-*- mode: makefile; -*-

.PHONY: test-local
test-local::

test: $(GSOURCE_FILES) test-local ## run unit tests
	PERL5LIB= prove -I lib -I local/lib/perl5 -v t/

check: $(GSOURCE_FILES) ## syntax check and create source from .in file

