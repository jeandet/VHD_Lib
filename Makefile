SCRIPTSDIR=scripts/
LIBDIR=lib/
BOARDSDIR=boards/
DESIGNSDIR=designs/


.PHONY:doc


all: help

help:
	@echo
	@echo " batch targets:"
	@echo
	@echo " make link            : link lpp library to GRLIB at : $(GRLIB)"
	@echo " make test            : run all tests /!\\ might take a lot of time."


APB_devs:
	sh $(SCRIPTSDIR)/APB_DEV_UPDATER.sh

link:
	sh $(SCRIPTSDIR)/linklibs.sh $(GRLIB)


test:
	$(MAKE) -C tests test


distclean:
	$(MAKE) -C tests distclean
	$(MAKE) -C designs distclean

