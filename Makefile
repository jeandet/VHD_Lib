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
	@echo " make Patch-GRLIB     : install library into GRLIB at : $(GRLIB)"
	@echo " make dist            : create a tar file for using into an other computer"
	@echo " make Patched-dist    : create a tar file for with a patched grlib for using"
	@echo "                        into an other computer"
	@echo " make allGPL          : add a GPL HEADER in all vhdl Files"
	@echo " make init            : add a GPL HEADER in all vhdl Files, init all files"
	@echo " make doc             : make documentation for VHDL IPs"
	@echo " make pdf             : make pdf documentation for VHDL IPs"
	@echo " make C-libs          : make C drivers for APB devices"
	@echo "                        binary files availiable on VHD_Lib/LPP_DRIVERS/lib ./includes"
	@echo



allGPL:
	@echo "Scanning VHDL files ..."
	sh $(SCRIPTSDIR)/GPL_Patcher.sh -R vhd lib
	@echo "Scanning C files ..."
	sh $(SCRIPTSDIR)/GPL_Patcher.sh -R c LPP_drivers
	@echo "Scanning H files ..."
	sh $(SCRIPTSDIR)/GPL_Patcher.sh -R h LPP_drivers

init: C-libs
	sh $(SCRIPTSDIR)/vhdlsynPatcher.sh
	sh $(SCRIPTSDIR)/makeDirs.sh lib/lpp

C-libs:APB_devs
	make -C LPP_drivers


APB_devs:
	sh $(SCRIPTSDIR)/APB_DEV_UPDATER.sh


Patch-GRLIB: init doc
	sh $(SCRIPTSDIR)/patch.sh $(GRLIB)

link:
	sh $(SCRIPTSDIR)/linklibs.sh $(GRLIB)

dist: init
	tar -cvzf ./../lpp-lib.tgz ./../VHD_Lib/*


Patched-dist: Patch-GRLIB
	tar -cvzf ./../lpp-patched-GRLIB.tgz $(GRLIB)/*


doc:
	mkdir -p doc/html
	cp doc/ressources/*.jpg doc/html/
	cp doc/ressources/doxygen.css doc/html/
	make -C lib/lpp doc
	make -C LPP_drivers doc


pdf: doc
	sh $(SCRIPTSDIR)/doc.sh





