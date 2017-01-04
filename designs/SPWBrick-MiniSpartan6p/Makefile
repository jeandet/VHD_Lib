VHDLIB=../..
SELFDIR := $(dir $(lastword $(MAKEFILE_LIST)))
SCRIPTSDIR=$(VHDLIB)/scripts/
GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=leon3mp
BOARD=MiniSpartan6p
DESIGN=leon3-MiniSpartan6p
include $(VHDLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=withSPW.ucf
UCF_PLANAHEAD=$(UCF)
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=high
XSTOPT=-uc leon3mp.xcf
SYNPOPT="set_option -pipe 1; set_option -retiming 1; set_option -write_apr_constraint 0"


VHDLOPTSYNFILES = sdctrl16.vhd config.vhd leon3mp.vhd

VHDLSIMFILES=mt48lc16m16a2.vhd testbench.vhd

SIMTOP=testbench
SDCFILE=$(GRLIB)/boards/$(BOARD)/default.sdc
BITGEN=$(VHDLIB)/boards/$(BOARD)/default.ut

TECHLIBS = unisim

LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc openchip hynix ihp gleichmann  usbhc fmf ftlib gsi

DIRSKIP = b1553 pcif leon2 leon2ft crypto satcan ddr usb ata i2c \
	pci grusbhc haps slink ascs can pwm greth coremp7 ac97 atf \
	grlfpc \
	./dsp/lpp_fft_rtax \
	./amba_lcd_16x2_ctrlr \
	./general_purpose/lpp_AMR \
	./general_purpose/lpp_balise \
	./general_purpose/lpp_delay \
	./lpp_bootloader \
	./lpp_sim/CY7C1061DV33 \
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

##################  project specific targets ##########################

load-ram:
	xc3sprog -c ftdi -p0 leon3mp.bit

load-flash:
	xc3sprog -c ftdi -p0 $(VHDLIB)/boards/$(BOARD)/bscan_spi_s6lx25_ftg256.bit
	xc3sprog -c ftdi -I leon3mp.bit
