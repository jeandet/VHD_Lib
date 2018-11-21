GRLIB ?= ../../grlib-gpl/
VHDLIB=../..
TOP=leon3mp
BOARD=em-LeonLPP-A3PE3kL-v3-core1
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
#VHDLSYNFILES=config.vhd ahbrom.vhd leon3mp.vhd
VHDLSYNFILES=
VHDLSIMFILES= tb.vhd 
SIMTOP=testbench
#SDCFILE=$(GRLIB)/boards/$(BOARD)/synplify.sdc
#SDC=$(GRLIB)/boards/$(BOARD)/leon3mp.sdc
PDC=$(GRLIB)/boards/$(BOARD)/em-LeonLPP-A3PE3kL.pdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = proasic3e

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc

DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs pwm coremp7 spi ac97 \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./lpp_cna \
	./lpp_uart \
	./lpp_usb \
	./dsp/lpp_fft_rtax \

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

