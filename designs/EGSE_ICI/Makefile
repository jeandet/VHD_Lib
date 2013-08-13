#GRLIB=../..
VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=TOP_EGSE2
BOARD=GSE_ICI
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=config.vhd EGSE_ICI.vhd DC_GATE_GEN.vhd LF_GATE_GEN.vhd MajF_Gen.vhd MinF_Gen.vhd Serial_driver.vhd ICI_EGSE_PROTOCOL.vhd 
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
SDCFILE=$(GRLIB)/boards/$(BOARD)/synplify.sdc
SDC=$(GRLIB)/boards/$(BOARD)/default.sdc
PDC=$(GRLIB)/boards/$(BOARD)/GSE_ICI.pdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = proasic3
LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc spw  fmf gsi  eth spansion  esa
DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps  slink ascs pwm coremp7 spi ac97 spacewire leon3 leon3ft can greth net gr1553b ./amba_lcd_16x2_ctrlr ./lpp_waveform \
	./lpp_dma

FILESKIP = i2cmst.vhd

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

##################  project specific targets ##########################

