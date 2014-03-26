VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/

GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=TB

##VHDLSYNFILES=	TB.vhd 

##LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
##	tmtc openchip hynix ihp gleichmann micron usbhc

##DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
##	pci grusbhc haps slink ascs pwm coremp7 spi ac97 \
##	./amba_lcd_16x2_ctrlr \
##	./general_purpose/lpp_AMR \
##	./general_purpose/lpp_balise \
##	./general_purpose/lpp_delay \
##	./dsp/lpp_fft \
##	./lpp_bootloader \
##	./lpp_cna \
##	./lpp_demux \
##	./lpp_matrix \
##	./lpp_uart \
##	./lpp_usb \
##	./lpp_Header \

##FILESKIP =lpp_lfr_ms.vhd \x
##	i2cmst.vhd \
##	APB_MULTI_DIODE.vhd \
##	APB_SIMPLE_DIODE.vhd \
##	Top_MatrixSpec.vhd \
##	APB_FFT.vhd

##include $(GRLIB)/bin/Makefile
##include $(GRLIB)/software/leon3/Makefile

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
	@$(CMD_VLIB) modelsim/grlib 
	@$(CMD_VMAP) grlib modelsim/grlib 
	@$(CMD_VLIB) modelsim/work
	@$(CMD_VMAP) work modelsim/work
	@$(CMD_VLIB) modelsim/lpp
	@$(CMD_VMAP) lpp modelsim/lpp
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

vcom:	vcom_grlib vcom_lpp vcom_tb

vcom_tb:
	$(CMD_VCOM) work TB.vhd
	@echo "vcom work done"

vcom_grlib:
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/version.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/config_types.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/config.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/stdlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/stdio.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/testlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/ftlib/mtie_ftlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/util/util.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/sparc/sparc.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/sparc/sparc_disas.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/sparc/cpu_disas.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/modgen/multlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/modgen/leaves.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/amba.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/devices.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/defmst.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/apbctrl.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ahbctrl.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/dma2ahb_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/dma2ahb.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ahbmst.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ahbmon.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/apbmon.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ambamon.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/dma2ahb_tp.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/amba_tp.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_mst_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_slv_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_util.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_mst.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_slv.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahbs.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_ctrl.vhd
	@echo "vcom grlib done"

vcom_lpp:
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_amba/apb_devices_list.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/general_purpose.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/ADDRcntr.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/ALU.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Adder.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clk_Divider2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clk_divider.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_CONTROLER.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_MUX.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_MUX2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_REG.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MUX2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MUXN.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Multiplier.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/REG.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/SYNC_FF.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Shifter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/TwoComplementer.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clock_Divider.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_to_level.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_detection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_positive_detection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/SYNC_VALID_BIT.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/RR_Arbiter_4.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/counter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/lpp_lfr_time_management.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/apb_lfr_time_management.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/lfr_time_management.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/fine_time_counter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/coarse_time_counter.vhd
	@echo "vcom lpp done"
