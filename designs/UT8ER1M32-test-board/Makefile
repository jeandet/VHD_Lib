VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=UT8ER1M32_test_board_top
BOARD=UT8ER1M32-test-board
include $(VHDLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(VHDLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(VHDLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=	UT8ER1M32-test-board_top.vhd

PDC=$(VHDLIB)/boards/$(BOARD)/default.pdc
BITGEN=$(VHDLIB)/boards/$(BOARD)/default.ut
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
	./lpp_sim \
	./lpp_lfr_pkg \
	./lpp_debug_lfr_pkg \
	./lpp_top_lfr

FILESKIP =lpp_lfr_ms.vhd \
	i2cmst.vhd \
	APB_MULTI_DIODE.vhd \
	APB_SIMPLE_DIODE.vhd \
	Top_MatrixSpec.vhd \
	APB_FFT.vhd \
	async_1Mx16.vhd \
	CY7C1061DV33.vhd



include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

##################  project specific targets ##########################

