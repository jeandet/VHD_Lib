GRLIB ?= ../../grlib-gpl/
VHDLIB=../..
TOP=LFR_em
BOARD=LFR-EM
include $(VHDLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=LFR-em.vhd
VHDLSIMFILES=testbench.vhd

PDC=$(VHDLIB)/boards/$(BOARD)/LFR-EM.pdc

SDCFILE=$(VHDLIB)/boards/$(BOARD)/LFR_EM_place_and_route.sdc
SDC=$(VHDLIB)/boards/$(BOARD)/LFR_EM_place_and_route.sdc

BITGEN=$(VHDLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = proasic3e

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc opencores can greth

DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs pwm coremp7 spi ac97 \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./dsp/lpp_fft_rtax \
	./lpp_uart \
	./lpp_usb \
	./lpp_sim/CY7C1061DV33 \

FILESKIP = i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_MULTI_DIODE.vhd \
	Top_MatrixSpec.vhd \
	APB_FFT.vhd\
	CoreFFT_simu.vhd \
	lpp_lfr_apbreg_simu.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

##################  project specific targets ##########################

