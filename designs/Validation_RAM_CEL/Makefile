VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/

GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=TB

CMD_VLIB=vlib
CMD_VMAP=vmap
CMD_VCOM=@vcom -quiet -93 -work 

##################  project specific targets ##########################

all:
	@echo "make vsim"
	@echo "make libs"
	@echo "make clean"
	@echo "make vcom_grlib vcom_lpp vcom_tb"

run:    
	@vsim work.TB -do run.do

vsim:   libs vcom run

libs:
	@$(CMD_VLIB) modelsim
	@$(CMD_VMAP) modelsim modelsim
	@$(CMD_VLIB) modelsim/techmap 
	@$(CMD_VMAP) techmap modelsim/techmap
	@$(CMD_VLIB) modelsim/grlib 
	@$(CMD_VMAP) grlib modelsim/grlib 
	@$(CMD_VLIB) modelsim/work
	@$(CMD_VMAP) work modelsim/work
	@echo "libs done"


clean:
	@rm -Rf modelsim
	@rm -Rf modelsim.ini
	@rm -Rf *~
	@rm -Rf transcript
	@rm -Rf wlft*
	@rm -Rf *.wlf
	@rm -Rf vish_stacktrace.vstf
	@rm -Rf libs.do

vcom: vcom_grlib vcom_techmap vcom_tb


vcom_tb:
	$(CMD_VCOM) work $(VHDLIB)/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
	$(CMD_VCOM) work TB.vhd  

vcom_grlib:
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/version.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/config_types.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/config.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/stdlib.vhd

vcom_techmap:
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/gencomp/gencomp.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/memory_inferred.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/allmem.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram_2p.vhd


