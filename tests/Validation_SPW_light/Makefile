VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=testbench
BOARD=MiniSpartan6p
include $(VHDLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=
QSF=
EFFORT=high
XSTOPT=
SYNPOPT=
VHDLSYNFILES=
VHDLSIMFILES= tb.vhd
SIMTOP=testbench
CLEAN=soft-clean

TECHLIBS = unisim


LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann  usbhc fmf ftlib gsi

DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs can pwm greth coremp7 ac97 atf \
	grlfpc \
	./dsp/lpp_fft_rtax \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./lpp_sim/CY7C1061DV33 \
	./lpp_uart \
	./dsp/lpp_fft \
	./lpp_leon3_soc \
	./lpp_debug_lfr

FILESKIP = i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_MULTI_DIODE.vhd \
	Top_MatrixSpec.vhd \
	APB_FFT.vhd \
	lpp_lfr_ms_FFT.vhd \
	lpp_lfr_apbreg.vhd \
	CoreFFT.vhd \
	lpp_lfr_ms.vhd \
	lpp_lfr_sim_pkg.vhd \
	mtie_maps.vhd \
	ftsrctrlc.vhd \
	ftsdctrl.vhd \
	ftsrctrl8.vhd \
	ftmctrl.vhd \
	ftsdctrl64.vhd \
	ftahbram.vhd \
	ftahbram2.vhd \
	sramft.vhd \
	nandfctrlx.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile
##################  project specific targets ##########################
distclean:myclean

myclean:
	rm -f input.txt output_fx.txt *.log
	rm -rf ./2016*

test: | ghdl ghdl-run archivate


