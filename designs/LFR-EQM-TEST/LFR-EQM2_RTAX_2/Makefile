VHDLIB=../../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)

TOP=LFR_EQM
BOARD=LFR-EQM

include $(VHDLIB)/boards/$(BOARD)/Makefile_RTAX.inc

DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=

VHDLSYNFILES=LFR-EQM.vhd
VHDLSIMFILES=testbench.vhd

PDC=$(VHDLIB)/boards/$(BOARD)/LFR_EQM_RTAX.pdc
SDC=$(VHDLIB)/boards/$(BOARD)/LFR_EQM_altran_syn_fanout.sdc

BITGEN=$(VHDLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = axcelerator 

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc ge_1000baseX

DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs pwm coremp7 spi ac97 \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./dsp/lpp_fft \
	./lpp_uart \
	./lpp_usb \
	./lpp_sim/CY7C1061DV33 \

FILESKIP = i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_MULTI_DIODE.vhd \
	Top_MatrixSpec.vhd \
	APB_FFT.vhd\
	CoreFFT_simu.vhd \
	lpp_lfr_apbreg_simu.vhd \
	sgmii.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

##################  project specific targets ##########################

