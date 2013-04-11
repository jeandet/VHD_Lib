#GRLIB=../..
TOP=leon3mp
BOARD=Projet-LeonLFR-A3P3K-Sheldon
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(GRLIB)/boards/$(BOARD)/$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=config.vhd ahbrom.vhd leon3mp.vhd Top_Data_Acquisition.vhd
VHDLSIMFILES=testbench.vhd TB_Data_Acquisition.vhd
SIMTOP=testbench
SDCFILE=$(GRLIB)/boards/$(BOARD)/synplify.sdc
SDC=$(GRLIB)/boards/$(BOARD)/leon3mp.sdc
PDC=$(GRLIB)/boards/$(BOARD)/Projet-LeonLFR-A3P3K-Sheldon.pdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean

TECHLIBS = proasic3
LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann micron usbhc
DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps  slink ascs pwm coremp7 spi ac97

FILESKIP = i2cmst.vhd

#TECHLIBS = unisim
include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile

my-clean: clean
	-rm -rf *~

##################  project specific targets ##########################

