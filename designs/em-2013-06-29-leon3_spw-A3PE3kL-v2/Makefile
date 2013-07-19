GRLIB=../..
TOP=leon3mp
BOARD=em-LeonLPP-A3PE3kL-v2
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
#VHDLSYNFILES=config.vhd ahbrom.vhd leon3mp.vhd
VHDLSYNFILES=config.vhd leon3mp.vhd
#VHDLSIMFILES=testbench.vhd
#SIMTOP=testbench
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
	./dsp/lpp_fft \
	./lpp_bootloader \
	./lpp_cna \
	./lpp_demux \
	./lpp_matrix \
	./lpp_uart \
	./lpp_usb \
	./lpp_Header \

FILESKIP = i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_SIMPLE_DIODE.vhd 

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

##################  project specific targets ##########################

