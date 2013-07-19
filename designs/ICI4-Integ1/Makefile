include .config

#GRLIB=$(GRLIB)
TOP=ici4
BOARD=ICI4-main-BD
#BOARD=SP601
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
#UCF=$(GRLIB)/boards/$(BOARD)/ICI3.ucf
UCF=$(GRLIB)/boards/$(BOARD)/ICI4-Main-BD.ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
ISEMAPOPT="-timing"
XSTOPT=""
SYNPOPT="set_option -maxfan 100; set_option -pipe 1; set_option -retiming 1; set_option -write_apr_constraint 0"
VHDLOPTSYNFILES= \
                 ICI4HDL/Convertisseur_config.vhd \
                 ICI4HDL/Convertisseur_Data.vhd \
                 ICI4HDL/DC_FRAME_PLACER.vhd \
                 ICI4HDL/DC_SMPL_CLK.vhd \
                 ICI4HDL/LF_FRAME_PLACER.vhd \
                 ICI4HDL/LF_SMPL_CLK.vhd

VHDLSYNFILES= \
	config.vhd  ici4.vhd
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
#SDCFILE=$(GRLIB)/boards/$(BOARD)/default.sdc
SDCFILE=default.sdc
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=soft-clean
VCOMOPT=-explicit
TECHLIBS = secureip unisim 

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip cypress ihp gleichmann gsi fmf spansion 
DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan pci leon3ft ambatest \
	leon4 leon4b64 l2cache gr1553b iommu haps ascs slink coremp7 pwm \
	ac97 hcan usb
DIRADD = 
FILEADD = 
FILESKIP = grcan.vhd ddr2.v mobile_ddr.v

include $(GRLIB)/bin/Makefile
include $(GRLIB)/software/leon3/Makefile


##################  project specific targets ##########################


