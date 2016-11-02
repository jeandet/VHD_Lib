#GRLIB=../..
VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=testbench
BOARD=LFR-EQM
include $(VHDLIB)/boards/$(BOARD)/Makefile_RTAX.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
#VHDLSYNFILES=config.vhd ahbrom.vhd leon3mp.vhd
VHDLSYNFILES= IIR_CEL_TEST.vhd tb.vhd IIR_CEL_TEST_v3.vhd generator.vhd
VHDLSIMFILES= tb.vhd
SIMTOP=testbench
#SDCFILE=$(GRLIB)/boards/$(BOARD)/synplify.sdc
PDC=$(VHDLIB)/boards/$(BOARD)/LFR_EQM_RTAX.pdc
SDC=$(VHDLIB)/boards/$(BOARD)/LFR_EQM_altran_syn_fanout.sdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = axcelerator

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc  opencores

DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs can pwm greth coremp7 spi ac97 \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./lfr_management \
	./lpp_sim \
	./lpp_sim/CY7C1061DV33 \
	./lpp_cna \
	./lpp_uart \
	./lpp_usb \
	./dsp/lpp_fft \

FILESKIP = i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_MULTI_DIODE.vhd \
	Top_MatrixSpec.vhd \
	APB_FFT.vhd \
	lpp_lfr_apbreg.vhd \
	CoreFFT.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

##################  project specific targets ##########################

