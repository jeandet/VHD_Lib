VHDLIB=../..
SCRIPTSDIR=$(VHDLIB)/scripts/

GRLIB := $(shell sh $(VHDLIB)/scripts/lpp_relpath.sh)
TOP=TB

CMD_VLIB=vlib
CMD_VMAP=vmap
CMD_VCOM=@vcom -quiet -93 -work 

##################  project specific targets ##########################

all:
	@echo "make vsim"
	@echo "make libs"
	@echo "make clean"
	@echo "make vcom_grlib vcom_lpp vcom_tb"

run:    
	@vsim work.TB -do run.do
#	@vsim work.TB 
#	@vsim lpp.lpp_lfr_ms

vsim:   libs vcom run

libs:
	@$(CMD_VLIB) modelsim
	@$(CMD_VMAP) modelsim modelsim
	@$(CMD_VLIB) modelsim/techmap 
	@$(CMD_VMAP) techmap modelsim/techmap
	@$(CMD_VLIB) modelsim/grlib 
	@$(CMD_VMAP) grlib modelsim/grlib 
	@$(CMD_VLIB) modelsim/gaisler
	@$(CMD_VMAP) gaisler modelsim/gaisler
	@$(CMD_VLIB) modelsim/work
	@$(CMD_VMAP) work modelsim/work
	@$(CMD_VLIB) modelsim/lpp
	@$(CMD_VMAP) lpp modelsim/lpp
	@$(CMD_VLIB) modelsim/esa
	@$(CMD_VMAP) esa modelsim/esa
	@echo "libs done"


clean:
	@rm -Rf modelsim
	@rm -Rf modelsim.ini
	@rm -Rf *~
	@rm -Rf transcript
	@rm -Rf wlft*
	@rm -Rf *.wlf
	@rm -Rf vish_stacktrace.vstf
	@rm -Rf libs.do

vcom: vcom_grlib vcom_techmap vcom_gaisler vcom_lpp vcom_esa vcom_tb


vcom_tb:
##	$(CMD_VCOM) lpp  lpp_memory.vhd
##	$(CMD_VCOM) lpp  lppFIFOxN.vhd
##	$(CMD_VCOM) lpp  lpp_FIFO.vhd
##	$(CMD_VCOM) lpp  lpp_lfr_ms.vhd
	$(CMD_VCOM) lpp  ../MINI-LFR_testdma/lpp_lfr_apbreg.vhd
	$(CMD_VCOM) lpp  testbench_package.vhd
	$(CMD_VCOM) lpp  testbench_package.vhd
	$(CMD_VCOM) work TB.vhd
	@echo "vcom done"

vcom_esa:
	$(CMD_VCOM) esa $(GRLIB)/lib/esa/memoryctrl/memoryctrl.vhd
	$(CMD_VCOM) esa $(GRLIB)/lib/esa/memoryctrl/mctrl.vhd
	@echo "lib esa done"

vcom_grlib:
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/version.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/config_types.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/config.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/stdlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/stdio.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/stdlib/testlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/ftlib/mtie_ftlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/util/util.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/sparc/sparc.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/sparc/sparc_disas.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/sparc/cpu_disas.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/modgen/multlib.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/modgen/leaves.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/amba.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/devices.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/defmst.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/apbctrl.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ahbctrl.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/dma2ahb_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/dma2ahb.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ahbmst.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ahbmon.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/apbmon.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/ambamon.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/dma2ahb_tp.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/amba/amba_tp.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_mst_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_slv_pkg.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_util.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_mst.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_slv.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahbs.vhd
	$(CMD_VCOM) grlib $(GRLIB)/lib/grlib/atf/at_ahb_ctrl.vhd
	@echo "vcom grlib done"

vcom_gaisler:
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/arith/arith.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/arith/mul32.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/arith/div32.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/memctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/sdctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/sdctrl64.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/sdmctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/srctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ssrctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsrctrlc.vhd
# #	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsrctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsdctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsdmctrl.vhd
# #	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftmctrlc.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsrctrl8.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsdmctrlx.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftmctrlcx.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftmctrl.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/memctrl/ftsdctrl64.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/grlfpu/mtie_grlfpu.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/grlfpc/mtie_grlfpc.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/grlfpcft/mtie_grlfpcft.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmuconf# ig.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmuiface.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/libmmu.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmutlbcam.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmulrue.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmulru.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmutlb.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmutw.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/srmmu/mmu.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/leon3.vhd
# #	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/libiu.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/libcache.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/tbufmem.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/dsu3x.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/dsu3.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/dsu3_2x.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/clk2xsync.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/clk2xqual.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3/grfpushwx.vhd
# 	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/libproc3.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/cachemem.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/mmu_icache.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/mmu_dcache.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/mmu_acache.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/mmu_cache.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/iu3.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/grfpwx.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/mfpwx.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/grlfpwx.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/proc3.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/leon3s2x.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/leon3s.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/leon3cg.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/grfpwxsh.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3v1/leon3sh.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/leon3ftv2/mtie_leon3ftv2.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/irqmp/irqmp2x.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/irqmp/irqmp.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/irqmp/irqamp.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/irqmp/irqamp2x.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/can.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/can_mod.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/can_oc.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/can_mc.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/canmux.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/can_rd.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/can_oc_core.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/can/grcan.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/misc.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/rstgen.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/gptimer.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbram.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbdpram.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbtrace.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbtrace_mb.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbtrace_mmb.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grgpio.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ftahbram.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ftahbram2.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbstat.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/logan.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/apbps2.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/charrom_package.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/charrom.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/apbvga.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahb2ahb.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbbridge.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/svgactrl.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grfifo.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/gradcdac.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grsysmon.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/gracectrl.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grgpreg.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbmst2.vhd
##	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/memscrub.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahb_mst_iface.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grgprbank.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grclkgate.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grclkgate2x.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grtimer.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grpulse.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/grversion.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/misc/ahbfrom.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/ambatest/ahbtbp.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/ambatest/ahbtbm.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/net/net.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/uart/uart.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/uart/libdcom.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/uart/apbuart.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/uart/dcom.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/uart/dcom_uart.vhd
# $(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/uart/ahbuart.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/sim.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/sram.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/sramft.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/sram16.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/phy.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/ahbrep.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/delay_wire.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/pwm_check.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/ramback.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/zbtssram.vhd
	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/sim/slavecheck.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/jtag.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/libjtagcom.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/jtagcom.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/ahbjtag.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/ahbjtag_bsd.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/bscanctrl.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/bscanregs.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/bscanregsbd.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/jtag/jtagtst.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/ethernet_mac.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/greth.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/greth_mb.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/greth_gbit.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/greth_gbit_mb.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/grethm.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/greth/rgmii.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/spacewire/spacewire.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/spacewire/grspw.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/spacewire/grspw2.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/spacewire/grspwm.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/spacewire/grspw2_phy.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/spacewire/grspw_phy.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/gr1553b/gr1553b_pkg.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/gr1553b/gr1553b_pads.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/gr1553b/simtrans1553.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/nand/nandpkg.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/nand/nandfctrlx.vhd
#	$(CMD_VCOM) gaisler $(GRLIB)/lib/gaisler/nand/nandfctrl.vhd
	@echo "vcom gaisler done"

vcom_techmap:
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/gencomp/gencomp.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/gencomp/netcomp.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/memory_inferred.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/tap_inferred.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/ddr_inferred.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/mul_inferred.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/ddr_phy_inferred.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/ddrphy_datapath.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/inferred/sim_pll.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/proasic3e/buffer_apa3e.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/proasic3e/clkgen_proasic3e.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/proasic3e/ddr_proasic3e.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/proasic3e/memory_apa3e.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/proasic3e/pads_apa3e.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/proasic3e/tap_proasic3e.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/allclkgen.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/allddr.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/allmem.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/allmul.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/allpads.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/alltap.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/clkgen.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/clkmux.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/clkand.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/ddr_ireg.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/ddr_oreg.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/ddrphy.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram64.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram_2p.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram_dp.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncfifo.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/regfile_3p.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/tap.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/techbuf.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/nandtree.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/clkpad.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/clkpad_ds.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/inpad.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/inpad_ds.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/iodpad.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/iopad.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/iopad_ds.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/lvds_combo.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/odpad.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/outpad.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/outpad_ds.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/toutpad.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/skew_outpad.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grspwc_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grspwc2_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grlfpw_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grlfpw4_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grfpw_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grfpw4_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/leon4_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/mul_61x61.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/cpu_disas_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/ringosc.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/corepcif_net.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/pci_arb_net.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grpci2_phy_net.vhd
#	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/system_monitor.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/grgates.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/inpad_ddr.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/outpad_ddr.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/iopad_ddr.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram128bw.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram256bw.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram128.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram156bw.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/techmult.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/spictrl_net.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/scanreg.vhd
	$(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncrambw.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/syncram_2pbw.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/obt1553_net.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/sdram_phy.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/from.vhd
# $(CMD_VCOM) techmap $(GRLIB)/lib/techmap/maps/mtie_maps.vhd
	@echo "vcom techmap done"

vcom_lpp:
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_amba/apb_devices_list.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_amba/lpp_amba.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/iir_filter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/lpp_fft/fft_components.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/general_purpose.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/ADDRcntr.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/ALU.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Adder.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clk_Divider2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clk_divider.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_CONTROLER.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_MUX.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_MUX2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_REG.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MUX2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MUXN.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Multiplier.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/REG.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/SYNC_FF.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Shifter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/TwoComplementer.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clock_Divider.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_to_level.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_detection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_positive_detection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/SYNC_VALID_BIT.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/RR_Arbiter_4.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/general_counter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_ad_Conv/lpp_ad_Conv.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/dsp/iir_filter/FILTERcfg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_amba/apb_devices_list.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_dma/lpp_dma_pkg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/lpp_matrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/MatriceSpectrale.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/ALU_Driver.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/ReUse_CTRLR.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/Dispatch.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/DriveInputs.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/GetResult.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/MatriceSpectrale.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/Matrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/TopSpecMatrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_matrix/SpectralMatrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_Header/lpp_Header.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_Header/HeaderBuilder.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lpp_memory.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lppFIFOxN.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lpp_FIFO.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lpp_FIFO_4_Shared.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lpp_FIFO_control.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lpp_FIFO_4_Shared_headreg_latency_0.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_memory/lpp_FIFO_4_Shared_headreg_latency_1.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/lpp_fft/CoreFFT_simu.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_spectral_matrix/spectral_matrix_package.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_spectral_matrix/spectral_matrix_switch_f0.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_spectral_matrix/spectral_matrix_time_managment.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_spectral_matrix/MS_control.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_spectral_matrix/MS_calculation.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_amba/apb_devices_list.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/general_purpose.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/ADDRcntr.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/ALU.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/Adder.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/Clk_Divider2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/Clk_divider.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MAC.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MAC_CONTROLER.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MAC_MUX.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MAC_MUX2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MAC_REG.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MUX2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/MUXN.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/Multiplier.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/REG.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/SYNC_FF.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/Shifter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/TwoComplementer.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/Clock_Divider.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/lpp_front_to_level.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/lpp_front_detection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/lpp_front_positive_detection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/SYNC_VALID_BIT.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/RR_Arbiter_4.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./general_purpose/general_counter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_amba/apb_devices_list.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_amba/lpp_amba.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/iir_filter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/FILTERcfg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/RAM.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lfr_time_management/lpp_lfr_time_management.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lfr_time_management/apb_lfr_time_management.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lfr_time_management/lfr_time_management.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lfr_time_management/fine_time_counter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lfr_time_management/coarse_time_counter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_ad_Conv/RHF1401.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_ad_Conv/TestModule_RHF1401.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_ad_Conv/top_ad_conv_ADS7886_v2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_ad_Conv/ADS7886_drvr_v2.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_spectral_matrix/spectral_matrix_package.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_spectral_matrix/MS_calculation.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_spectral_matrix/MS_control.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_spectral_matrix/spectral_matrix_switch_f0.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_spectral_matrix/spectral_matrix_time_managment.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_demux/DEMUX.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_demux/lpp_demux.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_Header/lpp_Header.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_Header/HeaderBuilder.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/ALU_Driver.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/Dispatch.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/DriveInputs.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/GetResult.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/Matrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/SpectralMatrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/TopSpecMatrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_matrix/lpp_matrix.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_memory/lpp_memory.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_memory/lpp_FIFO.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_memory/lppFIFOxN.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/lpp_dma_pkg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/fifo_latency_correction.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_pkg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/lpp_dma.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/lpp_dma_ip.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_dma/lpp_dma_singleOrBurst.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_burst.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo_withoutLatency.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo_latencyCorrection.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo_ctrl.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo_headreg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_snapshot_controler.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_genaddress.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_dma_genvalid.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter_reg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_pkg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd
##	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_apbreg_simu.vhd
##	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg_ms_pointer.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_ms_fsmdma.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_ms_FFT.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr_ms.vhd
#	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_top_lfr/lpp_lfr.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_Header/lpp_Header.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_Header/HeaderBuilder.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_leon3_soc/lpp_leon3_soc_pkg.vhd
#	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_leon3_soc/leon3_soc.vhd
#	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_debug_lfr/lpp_debug_lfr_pkg.vhd
#	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_debug_lfr/lpp_debug_dma_singleOrBurst.vhd
#	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/./lpp_debug_lfr/lpp_debug_lfr.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_pkg.vhd	
#	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr.vhd	
##	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_apbreg_ms_pointer.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_ms.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_ms_reg_head.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_ms_fsmdma.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_top_lfr/lpp_lfr_ms_FFT.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_dma/DMA_SubSystem.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_dma/DMA_SubSystem_GestionBuffer.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_dma/DMA_SubSystem_Arbiter.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_dma/DMA_SubSystem_MUX.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_sim/CY7C1061DV33/package_utility.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_sim/CY7C1061DV33/package_timing.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_sim/CY7C1061DV33/CY7C1061DV33_pkg.vhd
	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lpp_sim/CY7C1061DV33/CY7C1061DV33.vhd
	@echo "vcom lpp done"

# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/general_purpose.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/ADDRcntr.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/ALU.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Adder.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clk_Divider2.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clk_divider.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_CONTROLER.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_MUX.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_MUX2.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MAC_REG.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MUX2.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/MUXN.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Multiplier.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/REG.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/SYNC_FF.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Shifter.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/TwoComplementer.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/Clock_Divider.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_to_level.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_detection.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/lpp_front_positive_detection.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/SYNC_VALID_BIT.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/RR_Arbiter_4.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/general_purpose/general_counter.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/lpp_lfr_time_management.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/apb_lfr_time_management.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/lfr_time_management.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/fine_time_counter.vhd
# 	$(CMD_VCOM) lpp $(VHDLIB)/lib/lpp/lfr_time_management/coarse_time_counter.vhd
# 	@echo "vcom lpp done"

#include Makefile_vcom_lpp
