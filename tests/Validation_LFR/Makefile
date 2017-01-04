VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=testbench
BOARD=LFR-FM
include $(VHDLIB)/boards/$(BOARD)/Makefile_RTAX.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=
QSF=
EFFORT=high
XSTOPT=
SYNPOPT=
VHDLSYNFILES=
VHDLSIMFILES= $(VHDLIB)/designs/SOLO_LFR_LFR-FM/LFR-FM.vhd  tb.vhd
SIMTOP=testbench
CLEAN=soft-clean

TECHLIBS = axcelerator


LIBSKIP = tmtc openchip hynix cypress ihp usbhc fmf gsi spansion eth micron

DIRSKIP = leon2 leon2ft crypto usb satcan ddr greth grusbhc \
	leon4 leon4v0 l2cache iommu slink ascs pwm net spi can \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./lpp_uart \
	./lpp_usb \
	./lpp_debug_lfr \
	./dsp/lpp_fft

FILESKIP = i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_MULTI_DIODE.vhd \
	Top_MatrixSpec.vhd \
	APB_FFT.vhd \
	lpp_lfr_sim_pkg.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile
##################  project specific targets ##########################
distclean:myclean

myclean:
	rm -f input.txt output_fx.txt *.log
	rm -rf ./2016*

test: | ghdl ghdl-run archivate


