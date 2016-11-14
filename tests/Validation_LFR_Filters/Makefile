VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=testbench
BOARD=LFR-EQM
include $(VHDLIB)/boards/$(BOARD)/Makefile_RTAX.inc
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

TECHLIBS = axcelerator

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc  opencores fmf ftlib gsi

DIRSKIP = b1553 pcif leon2 leon3v3 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs can pwm greth coremp7 spi ac97 srmmu atf \
	grlfpc \
	./dsp/lpp_fft_rtax \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./lfr_management \
	./lpp_sim/CY7C1061DV33 \
	./lpp_cna \
	./lpp_uart \
	./lpp_usb \
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
vsim:cp_for_vsim

myclean:
	rm -f input.txt output_f*.txt
	rm -rf ./2016*

generate :
	python ./generate.py

cp_for_vsim: generate
	cp ./input.txt simulation/

archivate:
	xonsh ./archivate.xsh

test: | generate ghdl ghdl-run archivate
