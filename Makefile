SCRIPTSDIR=scripts/
LIBDIR=lib/
BOARDSDIR=boards/
DESIGNSDIR=designs/
	





all: help

help:
	@echo
	@echo " batch targets:"
	@echo
	@echo " make Patch-GRLIB     : install library into GRLIB at : $(GRLIB)"
	@echo " make dist            : create a tar file for using into an other computer"
	@echo " make Patched-dist    : create a tar file for with a patched grlib for using into an other computer"
	@echo " make allGPL          : add a GPL HEADER in all vhdl Files"
	@echo " make init            : add a GPL HEADER in all vhdl Files, init all files"
	@echo " make doc             : make documentation for VHDL IPs"
	@echo " make pdf             : make pdf documentation for VHDL IPs"
	@echo

allGPL:
	sh $(SCRIPTSDIR)/GPL_Patcher.sh -R 

init: allGPL
	sh $(SCRIPTSDIR)/vhdlsynPatcher.sh
	sh $(SCRIPTSDIR)/makeDirs.sh lib/lpp


Patch-GRLIB: init doc
	sh $(SCRIPTSDIR)/patch.sh $(GRLIB)


dist: init
	tar -cvzf ./../lpp-lib.tgz ./../VHD_Lib/*

Patched-dist: Patch-GRLIB
	tar -cvzf ./../lpp-patched-GRLIB.tgz $(GRLIB)/*


doc:
	doxygen lib/lpp/Doxyfile

pdf:
	make lib/lpp/doc/latex
	cp lib/lpp/doc/latex/refman.pdf lib/lpp/doc/VHD_lib.pdf
