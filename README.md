# ABOUT


LPP's VHD_Lib is a kind of addon to gaisler's grlib with most [LPP](http://www.lpp.fr/?lang=en) VHDL IPs. For setup read instalation section.


# REQUIREMENTS


To use this library you need a linux shell or mingw for windows users wtih make and TCL/TK.
[Jupyter](http://jupyter.org/) and [GHDL](http://ghdl.free.fr/) migh also be useful.


# PERSONALIZATION


You can add your IPs to the library.


# INSTALLATION


To set up the VHD_Lib follow this steps:


```bash
git clone --recursive https://github.com/jeandet/VHD_Lib
cd VHD_Lib && make link
```


## Xilinx toolchain

 To use Vivado toolchain you'll have to set the following environment variables,
add this in your bashrc and change path according to your Vivado installation.

```
export XILINX=/opt/Xilinx/Vivado/2018.2/ids_lite/ISE
export XILINX_VIVADO=/opt/Xilinx/Vivado/2018.2
export PATH=$PATH:/opt/Xilinx/Vivado/2018.2/bin:/opt/Xilinx/SDK/2018.2/bin
```

 Then you need to install Xilinx simulation libraries:
 
```
make install-secureip install-secureip_ver install-unimacro install-unisim install-unisim_ver install-xilinxcorelib_ver
```

## Test installation
Now you can use VHD_Lib's and grlib's Makefiles, designs and IPs, you can for example run the following test:

### With QuestaSim or ModelSim

```
cd tests/lpp_memory/lpp_fifo
GRLIB_SIMULATOR=Questa make test-vsim
```

This should produce the following output:

```
GRLIB settings: 
  GRLIB = ../../../grlib-gpl 
  GRLIB_CONFIG is library default 
  GRLIB_SIMULATOR = ModelSim 
  TECHLIBS setting = unisim 
  Top-level design = testbench 
  Simulation top-level = testbench 
 Scanning libraries: 
  grlib: stdlib util sparc modgen amba dftlib generic_bm 
  unisim: ise 
  techmap: gencomp inferred unisim maps 
  spw: comp wrapper 
  eth: comp core wrapper 
  gaisler: arith memctrl leon3 leon4 irqmp l2cache/pkg axi misc ambatest net uart sim jtag spacewire gr1553b grdmac subsys 
  esa: memoryctrl 
  spansion: flash 
  lpp: ./general_purpose ./lpp_amba ./dsp/chirp ./dsp/iir_filter ./dsp/cic ./dsp/lpp_downsampling ./dsp/window_function ./lpp_memory ./lpp_ad_Conv ./lpp_spectral_matrix ./lpp_demux ./lpp_Header ./lpp_matrix ./lpp_dma ./lpp_waveform ./lpp_top_lfr ./lpp_Header ./lpp_sim ./lpp_file 
  opencores_spw: spw_light 
  cypress: ssram 
  work: debug 
Reading pref.tcl

# 10.7_1

# do libs.do
#  quit
make[1] : on entre dans le répertoire « /tmp/VHD_Lib/tests/lpp_memory/lpp_fifo »
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/stdlib/version.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/stdlib/config_types.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/stdlib/config.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/stdlib/stdlib.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/stdlib/stdio.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/stdlib/testlib.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/util/util.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/sparc/sparc.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/sparc/sparc_disas.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/sparc/cpu_disas.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/modgen/multlib.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/modgen/leaves.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/amba.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/devices.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/defmst.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/apbctrl.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/apbctrlx.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/apbctrldp.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/apbctrlsp.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/ahbctrl.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/dma2ahb_pkg.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/dma2ahb.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/ahbmst.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/ahblitm2ahbm.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/dma2ahb_tp.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/amba/amba_tp.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/dftlib/dftlib.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/dftlib/synciotest.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/generic_bm_pkg.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/ahb_be.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/axi4_be.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/bmahbmst.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/bm_fre.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/bm_me_rc.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/bm_me_wc.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/fifo_control_rc.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/fifo_control_wc.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/generic_bm_ahb.vhd
vcom -quiet -explicit -O0 -93  -work grlib ../../../grlib-gpl/lib/grlib/generic_bm/generic_bm_axi.vhd
vcom -quiet -explicit -O0 -93  -work unisim ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VPKG.vhd
vcom -quiet -explicit -O0 -93  -work unisim ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VCOMP.vhd
vcom -quiet -explicit -O0 -93  -work unisim ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/gencomp/gencomp.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/gencomp/netcomp.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/memory_inferred.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/ddr_inferred.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/mul_inferred.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/ddr_phy_inferred.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/ddrphy_datapath.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/fifo_inferred.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/sim_pll.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/inferred/lpddr2_phy_inferred.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/memory_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/buffer_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/pads_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/clkgen_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/tap_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/ddr_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/ddr_phy_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/sysmon_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/mul_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/unisim/spictrl_unisim.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/allclkgen.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/techbuf.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/allddr.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/allmem.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/allmul.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/allpads.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/alltap.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/clkgen.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/clkmux.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/clkinv.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/clkand.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/grgates.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/ddr_ireg.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/ddr_oreg.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/clkpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/clkpad_ds.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/inpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/inpad_ds.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/iodpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/iopad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/iopad_ds.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/lvds_combo.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/odpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/outpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/outpad_ds.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/toutpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/toutpad_ds.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/skew_outpad.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/ddrphy.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram64.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram_2p.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram_dp.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncfifo_2p.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/regfile_3p.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/tap.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/nandtree.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/grlfpw_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/grfpw_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/leon3_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/leon4_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/mul_61x61.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/cpu_disas_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/ringosc.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/grpci2_phy_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/system_monitor.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/inpad_ddr.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/outpad_ddr.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/iopad_ddr.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram128bw.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram256bw.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram128.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram156bw.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/techmult.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/spictrl_net.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/scanreg.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncrambw.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncram_2pbw.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/sdram_phy.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/syncreg.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/serdes.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/iopad_tm.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/toutpad_tm.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/memrwcol.vhd
vcom -quiet -explicit -O0 -93  -work techmap ../../../grlib-gpl/lib/techmap/maps/cdcbus.vhd
vcom -quiet -explicit -O0 -93  -work spw ../../../grlib-gpl/lib/spw/comp/spwcomp.vhd
vcom -quiet -explicit -O0 -93  -work spw ../../../grlib-gpl/lib/spw/wrapper/grspw_gen.vhd
vcom -quiet -explicit -O0 -93  -work spw ../../../grlib-gpl/lib/spw/wrapper/grspw2_gen.vhd
vcom -quiet -explicit -O0 -93  -work spw ../../../grlib-gpl/lib/spw/wrapper/grspw_codec_gen.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/comp/ethcomp.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/greth_pkg.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/eth_rstgen.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/eth_edcl_ahb_mst.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/eth_ahb_mst.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/greth_tx.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/greth_rx.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/core/grethc.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/wrapper/greth_gen.vhd
vcom -quiet -explicit -O0 -93  -work eth ../../../grlib-gpl/lib/eth/wrapper/greth_gbit_gen.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/arith/arith.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/arith/mul32.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/arith/div32.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/memctrl/memctrl.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/memctrl/sdctrl.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/memctrl/sdctrl64.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/memctrl/sdmctrl.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/memctrl/srctrl.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/leon3/leon3.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/leon3/grfpushwx.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/leon4/leon4.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/irqmp/irqmp.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/irqmp/irqamp.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/irqmp/irqmp_bmode.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/l2cache/pkg/l2cache.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/axi.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/ahbm2axi.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/ahbm2axi3.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/ahbm2axi4.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/axinullslv.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/ahb2axib.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/ahb2axi3b.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/axi/ahb2axi4b.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/misc.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/rstgen.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/gptimer.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbdpram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbtrace_mmb.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbtrace_mb.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbtrace.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/grgpio.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbstat.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/logan.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/apbps2.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/charrom_package.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/charrom.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/apbvga.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/svgactrl.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/grsysmon.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/gracectrl.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/grgpreg.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahb_mst_iface.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/grgprbank.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/grversion.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/apb3cdc.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbsmux.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbmmux.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/ambatest/ahbtbp.vhd
###### ../../../grlib-gpl/lib/gaisler/ambatest/ahbtbp.vhd(378): variable length : integer := tost(NOW / 1 ns)'length; 
** Warning: ../../../grlib-gpl/lib/gaisler/ambatest/ahbtbp.vhd(378): (vcom-1515) Prefix of predefined attribute "length" is function call "tost".
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/ambatest/ahbtbm.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/net/net.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/uart/uart.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/uart/libdcom.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/uart/apbuart.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/uart/dcom.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/uart/dcom_uart.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/uart/ahbuart.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/sim.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/sram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/sram16.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/phy.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/ser_phy.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/ahbrep.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/delay_wire.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/pwm_check.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/slavecheck_slv.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/ddrram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/ddr2ram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/ddr3ram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/sdrtestmod.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/ahbram_sim.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/aximem.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/axirep.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/sim/axixmem.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtag.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/libjtagcom.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtagcom.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/bscanregs.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/bscanregsbd.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtagcom2.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/ahbjtag.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/ahbjtag_bsd.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtagtst.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/spacewire/spacewire.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_pkg.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_pads.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_nlw.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_stdlogic.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/simtrans1553.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_pkg.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/grdmac/apbmem.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_ahbmst.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_alignram.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_1p.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/subsys/subsys.vhd
vcom -quiet -explicit -O0 -93  -work gaisler ../../../grlib-gpl/lib/gaisler/subsys/leon_dsu_stat_base.vhd
vcom -quiet -explicit -O0 -93  -work esa ../../../grlib-gpl/lib/esa/memoryctrl/memoryctrl.vhd
vcom -quiet -explicit -O0 -93  -work esa ../../../grlib-gpl/lib/esa/memoryctrl/mctrl.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/data_type_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/general_purpose.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/D_FF.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/ADDRcntr.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/ALU.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Adder.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Clk_Divider2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Clk_divider.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_CONTROLER.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_MUX.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_MUX2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_REG.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MUX2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MUXN.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Multiplier.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/REG.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/SYNC_FF.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Shifter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/TwoComplementer.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Clock_Divider.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/lpp_front_to_level.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/lpp_front_detection.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/SYNC_VALID_BIT.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/RR_Arbiter_4.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/general_counter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/ramp_generator.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/TimeGenAdvancedTrigger.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/saturation.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/apb_devices_list.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/lpp_amba.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/APB_ADVANCED_TRIGGER.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/APB_ADVANCED_TRIGGER_v.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/chirp/chirp_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/chirp/chirp.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/iir_filter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/FILTERcfg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v3_DATAFLOW.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v3.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_integrator.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_downsampler.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_comb.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_control.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_add_sub.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_address_gen.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_r2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_control_r2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/window_function_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/window_function.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/WF_processing.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/WF_rom.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_memory.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_4_Shared.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_control.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_4_Shared_headreg_latency_0.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_4_Shared_headreg_latency_1.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lppFIFOxN.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/RHF1401.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401_withFilter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/TestModule_RHF1401.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/top_ad_conv_ADS7886_v2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/ADS7886_drvr_v2.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/lpp_lfr_hk.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/spectral_matrix_package.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/MS_calculation.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/MS_control.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/spectral_matrix_switch_f0.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/spectral_matrix_time_managment.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_demux/DEMUX.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_demux/lpp_demux.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_Header/lpp_Header.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_Header/HeaderBuilder.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/lpp_matrix.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/ALU_Driver.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/Dispatch.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/DriveInputs.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/GetResult.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/MatriceSpectrale.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/Matrix.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/SpectralMatrix.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/TopSpecMatrix.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/fifo_latency_correction.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_ip.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_singleOrBurst.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem_GestionBuffer.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem_Arbiter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem_MUX.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_SEND16B_FIFO2DMA.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_burst.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_withoutLatency.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_latencyCorrection.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_ctrl.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_headreg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_snapshot_controler.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_genaddress.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_dma_genvalid.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter_reg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fsmdma.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_filter_coeff.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg_ms_pointer.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_ms_fsmdma.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_ms_reg_head.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lpp_sim_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/sig_reader.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/sig_recorder.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lpp_sim_pkg.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/spw_sender.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/spw_receiver.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lfr_input_gen.vhd
vcom -quiet -explicit -O0 -93  -work lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_file/reader_pkg.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwpkg.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwambapkg.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwlink.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwrecv.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwxmit.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwxmit_fast.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwrecvfront_generic.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwrecvfront_fast.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/syncdff.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwram.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwamba.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwstream.vhd
vcom -quiet -explicit -O0 -93  -work opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwahbmst.vhd
vcom -quiet -explicit -O0 -93  -work cypress ../../../grlib-gpl/lib/cypress/ssram/components.vhd
vcom -quiet -explicit -O0 -93  -work cypress ../../../grlib-gpl/lib/cypress/ssram/package_utility.vhd
vcom -quiet -explicit -O0 -93  -work cypress ../../../grlib-gpl/lib/cypress/ssram/cy7c1354b.vhd
vcom -quiet -explicit -O0 -93  -work cypress ../../../grlib-gpl/lib/cypress/ssram/cy7c1380d.vhd
vcom -quiet -explicit -O0 -93  -work work ../../../grlib-gpl/lib/work/debug/debug.vhd
vcom -quiet -explicit -O0 -93  -work work ../../../grlib-gpl/lib/work/debug/grtestmod.vhd
vcom -quiet -explicit -O0 -93  -work work ../../../grlib-gpl/lib/work/debug/cpu_disas.vhd
vcom -quiet -explicit -O0 -93  -work work tb.vhd
make[1] : on quitte le répertoire « /tmp/VHD_Lib/tests/lpp_memory/lpp_fifo »
make[1] : on entre dans le répertoire « /tmp/VHD_Lib/tests/lpp_memory/lpp_fifo »
make[1]: rien à faire pour « whole_library ».
make[1] : on quitte le répertoire « /tmp/VHD_Lib/tests/lpp_memory/lpp_fifo »
Reading pref.tcl

# 10.7_1

# vsim -c -voptargs="+acc" -do "wave.do" -do "../../../grlib-gpl//bin/runvsim.do" testbench 
# Start time: 19:41:08 on Nov 21,2018
# ** Note: (vsim-3812) Design is being optimized...
# ** Warning: (vopt-2009) At least one design unit was compiled with optimization level -O0 or -O1.
# Use vdir -l command to find such design units.
# //  Questa Sim-64
# //  Version 10.7_1 linux_x86_64 Jan 21 2018
# //
# //  Copyright 1991-2018 Mentor Graphics Corporation
# //  All Rights Reserved.
# //
# //  QuestaSim and its associated documentation contain trade
# //  secrets and commercial or financial information that are the property of
# //  Mentor Graphics Corporation and are privileged, confidential,
# //  and exempt from disclosure under the Freedom of Information Act,
# //  5 U.S.C. Section 552. Furthermore, this information
# //  is prohibited from disclosure under the Trade Secrets Act,
# //  18 U.S.C. Section 1905.
# //
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_signed(body)
# Loading ieee.math_real(body)
# Loading grlib.config_types
# Loading grlib.config
# Loading techmap.gencomp
# Loading lpp.general_purpose
# Loading lpp.data_type_pkg(body)
# Loading grlib.version
# Loading grlib.stdlib(body)
# Loading grlib.amba(body)
# Loading gaisler.uart
# Loading grlib.devices
# Loading gaisler.misc(body)
# Loading gaisler.libdcom(body)
# Loading grlib.stdio(body)
# Loading gaisler.sim(body)
# Loading gaisler.jtagtst(body)
# Loading lpp.lpp_sim_pkg(body)
# Loading lpp.lpp_amba
# Loading lpp.iir_filter
# Loading gaisler.memctrl
# Loading lpp.lpp_memory
# Loading work.testbench(behav)#1
# Loading lpp.lpp_fifo(ar_lpp_fifo)#1
# Loading ieee.std_logic_textio(body)
# Loading lpp.ram_cel(ar_ram_cel)#1
# ** Note: initialysing RAM CEL To 0
#    Time: 0 ps  Iteration: 0  Instance: /testbench/DUT/memCEL/CRAM File: ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
# Loading lpp.lpp_fifo_control(beh)#1
# do wave.do
# hexadecimal
# hexadecimal
# hexadecimal
# hexadecimal
# hexadecimal
# hexadecimal
# hexadecimal
# hexadecimal
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# configure wave not supported in batch mode
# do ../../../grlib-gpl//bin/runvsim.do
# ** Note: end of test
#    Time: 20940010 ps  Iteration: 0  Instance: /testbench
# ** Note: end of test
#    Time: 20950010 ps  Iteration: 0  Instance: /testbench
# End time: 19:41:09 on Nov 21,2018, Elapsed time: 0:00:01
# Errors: 0, Warnings: 1
Test FIFO done

```

### With GHDL

```
cd tests/lpp_memory/lpp_fifo
make test
```
This should produce the following output:

```
GRLIB settings: 
  GRLIB = ../../../grlib-gpl 
  GRLIB_CONFIG is library default 
  GRLIB_SIMULATOR = ModelSim 
  TECHLIBS setting = unisim 
  Top-level design = testbench 
  Simulation top-level = testbench 
 Scanning libraries: 
  grlib: stdlib util sparc modgen amba dftlib generic_bm 
  unisim: ise 
  techmap: gencomp inferred unisim maps 
  spw: comp wrapper 
  eth: comp core wrapper 
  gaisler: arith memctrl leon3 leon4 irqmp l2cache/pkg axi misc ambatest net uart sim jtag spacewire gr1553b grdmac subsys 
  esa: memoryctrl 
  spansion: flash 
  lpp: ./general_purpose ./lpp_amba ./dsp/chirp ./dsp/iir_filter ./dsp/cic ./dsp/lpp_downsampling ./dsp/window_function ./lpp_memory ./lpp_ad_Conv ./lpp_spectral_matrix ./lpp_demux ./lpp_Header ./lpp_matrix ./lpp_dma ./lpp_waveform ./lpp_top_lfr ./lpp_Header ./lpp_sim ./lpp_file 
  opencores_spw: spw_light 
  cypress: ssram 
  work: debug 
make -f make.ghdl ghdl-import
make[1] : on entre dans le répertoire « /tmp/VHD_Lib/tests/lpp_memory/lpp_fifo »
mkdir -p gnu
mkdir -p gnu/grlib
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/stdlib/version.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/stdlib/config_types.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/stdlib/config.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/stdlib/stdlib.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/stdlib/stdio.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/stdlib/testlib.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/util/util.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/sparc/sparc.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/sparc/sparc_disas.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/sparc/cpu_disas.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/modgen/multlib.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/modgen/leaves.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/amba.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/devices.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/defmst.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/apbctrl.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/apbctrlx.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/apbctrldp.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/apbctrlsp.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/ahbctrl.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/dma2ahb_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/dma2ahb.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/ahbmst.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/ahblitm2ahbm.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/dma2ahb_tp.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/amba/amba_tp.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/dftlib/dftlib.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/dftlib/synciotest.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/generic_bm_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/ahb_be.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/axi4_be.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/bmahbmst.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/bm_fre.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/bm_me_rc.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/bm_me_wc.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/fifo_control_rc.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/fifo_control_wc.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/generic_bm_ahb.vhd
ghdl -i --mb-comments --workdir=gnu/grlib --work=grlib -Pgnu -Pgnu/grlib ../../../grlib-gpl/lib/grlib/generic_bm/generic_bm_axi.vhd
mkdir -p gnu/unisim
ghdl -i --mb-comments --workdir=gnu/unisim --work=unisim -Pgnu -Pgnu/grlib -Pgnu/unisim ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VPKG.vhd
ghdl -i --mb-comments --workdir=gnu/unisim --work=unisim -Pgnu -Pgnu/grlib -Pgnu/unisim ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VCOMP.vhd
ghdl -i --mb-comments --workdir=gnu/unisim --work=unisim -Pgnu -Pgnu/grlib -Pgnu/unisim ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd
mkdir -p gnu/techmap
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/gencomp/gencomp.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/gencomp/netcomp.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/memory_inferred.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/ddr_inferred.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/mul_inferred.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/ddr_phy_inferred.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/ddrphy_datapath.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/fifo_inferred.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/sim_pll.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/inferred/lpddr2_phy_inferred.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/memory_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/buffer_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/pads_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/clkgen_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/tap_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/ddr_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/ddr_phy_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/sysmon_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/mul_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/unisim/spictrl_unisim.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/allclkgen.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/techbuf.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/allddr.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/allmem.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/allmul.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/allpads.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/alltap.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/clkgen.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/clkmux.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/clkinv.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/clkand.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/grgates.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/ddr_ireg.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/ddr_oreg.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/clkpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/clkpad_ds.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/inpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/inpad_ds.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/iodpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/iopad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/iopad_ds.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/lvds_combo.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/odpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/outpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/outpad_ds.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/toutpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/toutpad_ds.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/skew_outpad.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/ddrphy.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram64.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram_2p.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram_dp.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncfifo_2p.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/regfile_3p.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/tap.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/nandtree.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/grlfpw_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/grfpw_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/leon3_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/leon4_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/mul_61x61.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/cpu_disas_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/ringosc.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/grpci2_phy_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/system_monitor.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/inpad_ddr.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/outpad_ddr.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/iopad_ddr.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram128bw.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram256bw.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram128.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram156bw.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/techmult.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/spictrl_net.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/scanreg.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncrambw.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncram_2pbw.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/sdram_phy.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/syncreg.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/serdes.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/iopad_tm.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/toutpad_tm.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/memrwcol.vhd
ghdl -i --mb-comments --workdir=gnu/techmap --work=techmap -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap ../../../grlib-gpl/lib/techmap/maps/cdcbus.vhd
mkdir -p gnu/spw
ghdl -i --mb-comments --workdir=gnu/spw --work=spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw ../../../grlib-gpl/lib/spw/comp/spwcomp.vhd
ghdl -i --mb-comments --workdir=gnu/spw --work=spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw ../../../grlib-gpl/lib/spw/wrapper/grspw_gen.vhd
ghdl -i --mb-comments --workdir=gnu/spw --work=spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw ../../../grlib-gpl/lib/spw/wrapper/grspw2_gen.vhd
ghdl -i --mb-comments --workdir=gnu/spw --work=spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw ../../../grlib-gpl/lib/spw/wrapper/grspw_codec_gen.vhd
mkdir -p gnu/eth
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/comp/ethcomp.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/greth_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/eth_rstgen.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/eth_edcl_ahb_mst.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/eth_ahb_mst.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/greth_tx.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/greth_rx.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/core/grethc.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/wrapper/greth_gen.vhd
ghdl -i --mb-comments --workdir=gnu/eth --work=eth -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth ../../../grlib-gpl/lib/eth/wrapper/greth_gbit_gen.vhd
mkdir -p gnu/gaisler
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/arith/arith.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/arith/mul32.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/arith/div32.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/memctrl/memctrl.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/memctrl/sdctrl.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/memctrl/sdctrl64.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/memctrl/sdmctrl.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/memctrl/srctrl.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/leon3/leon3.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/leon3/grfpushwx.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/leon4/leon4.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/irqmp/irqmp.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/irqmp/irqamp.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/irqmp/irqmp_bmode.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/l2cache/pkg/l2cache.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/axi.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/ahbm2axi.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/ahbm2axi3.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/ahbm2axi4.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/axinullslv.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/ahb2axib.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/ahb2axi3b.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/axi/ahb2axi4b.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/misc.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/rstgen.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/gptimer.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbdpram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbtrace_mmb.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbtrace_mb.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbtrace.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/grgpio.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbstat.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/logan.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/apbps2.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/charrom_package.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/charrom.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/apbvga.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/svgactrl.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/grsysmon.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/gracectrl.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/grgpreg.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahb_mst_iface.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/grgprbank.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/grversion.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/apb3cdc.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbsmux.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/misc/ahbmmux.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/ambatest/ahbtbp.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/ambatest/ahbtbm.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/net/net.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/uart/uart.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/uart/libdcom.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/uart/apbuart.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/uart/dcom.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/uart/dcom_uart.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/uart/ahbuart.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/sim.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/sram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/sram16.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/phy.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/ser_phy.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/ahbrep.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/delay_wire.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/pwm_check.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/slavecheck_slv.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/ddrram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/ddr2ram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/ddr3ram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/sdrtestmod.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/ahbram_sim.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/aximem.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/axirep.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/sim/axixmem.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtag.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/libjtagcom.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtagcom.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/bscanregs.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/bscanregsbd.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtagcom2.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/ahbjtag.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/ahbjtag_bsd.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/jtag/jtagtst.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/spacewire/spacewire.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_pads.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_nlw.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/gr1553b_stdlogic.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/gr1553b/simtrans1553.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/grdmac/apbmem.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_ahbmst.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_alignram.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/grdmac/grdmac_1p.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/subsys/subsys.vhd
ghdl -i --mb-comments --workdir=gnu/gaisler --work=gaisler -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler ../../../grlib-gpl/lib/gaisler/subsys/leon_dsu_stat_base.vhd
mkdir -p gnu/esa
ghdl -i --mb-comments --workdir=gnu/esa --work=esa -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa ../../../grlib-gpl/lib/esa/memoryctrl/memoryctrl.vhd
ghdl -i --mb-comments --workdir=gnu/esa --work=esa -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa ../../../grlib-gpl/lib/esa/memoryctrl/mctrl.vhd
mkdir -p gnu/spansion
mkdir -p gnu/lpp
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/data_type_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/general_purpose.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/D_FF.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/ADDRcntr.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/ALU.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Adder.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Clk_Divider2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Clk_divider.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_CONTROLER.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_MUX.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_MUX2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MAC_REG.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MUX2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/MUXN.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Multiplier.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/REG.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/SYNC_FF.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Shifter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/TwoComplementer.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/Clock_Divider.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/lpp_front_to_level.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/lpp_front_detection.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/SYNC_VALID_BIT.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/RR_Arbiter_4.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/general_counter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/ramp_generator.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/TimeGenAdvancedTrigger.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/saturation.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/apb_devices_list.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/lpp_amba.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/APB_ADVANCED_TRIGGER.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/APB_ADVANCED_TRIGGER_v.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/chirp/chirp_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/chirp/chirp.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/iir_filter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/FILTERcfg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v3_DATAFLOW.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v3.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_integrator.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_downsampler.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_comb.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_control.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_add_sub.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_address_gen.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_r2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/cic/cic_lfr_control_r2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/window_function_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/window_function.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/WF_processing.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./dsp/window_function/WF_rom.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_memory.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_4_Shared.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_control.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_4_Shared_headreg_latency_0.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_4_Shared_headreg_latency_1.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lppFIFOxN.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/RHF1401.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401_withFilter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/TestModule_RHF1401.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/top_ad_conv_ADS7886_v2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/ADS7886_drvr_v2.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_ad_Conv/lpp_lfr_hk.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/spectral_matrix_package.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/MS_calculation.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/MS_control.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/spectral_matrix_switch_f0.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_spectral_matrix/spectral_matrix_time_managment.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_demux/DEMUX.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_demux/lpp_demux.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_Header/lpp_Header.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_Header/HeaderBuilder.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/lpp_matrix.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/ALU_Driver.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/Dispatch.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/DriveInputs.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/GetResult.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/MatriceSpectrale.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/Matrix.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/SpectralMatrix.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_matrix/TopSpecMatrix.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/fifo_latency_correction.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_ip.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_singleOrBurst.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem_GestionBuffer.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem_Arbiter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/DMA_SubSystem_MUX.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_dma/lpp_dma_SEND16B_FIFO2DMA.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_burst.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_withoutLatency.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_latencyCorrection.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_ctrl.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_headreg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_snapshot_controler.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_genaddress.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_dma_genvalid.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter_reg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_waveform/lpp_waveform_fsmdma.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_filter_coeff.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg_ms_pointer.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_ms_fsmdma.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr_ms_reg_head.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_top_lfr/lpp_lfr.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lpp_sim_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/sig_reader.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/sig_recorder.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lpp_sim_pkg.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/spw_sender.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/spw_receiver.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lfr_input_gen.vhd
ghdl -i --mb-comments --workdir=gnu/lpp --work=lpp -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp ../../../grlib-gpl/lib/../../lib/lpp/./lpp_file/reader_pkg.vhd
mkdir -p gnu/opencores_spw
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwpkg.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwambapkg.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwlink.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwrecv.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwxmit.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwxmit_fast.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwrecvfront_generic.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwrecvfront_fast.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/syncdff.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwram.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwamba.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwstream.vhd
ghdl -i --mb-comments --workdir=gnu/opencores_spw --work=opencores_spw -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw ../../../grlib-gpl/lib/../../lib/opencores_spw/spw_light/spwahbmst.vhd
mkdir -p gnu/cypress
ghdl -i --mb-comments --workdir=gnu/cypress --work=cypress -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress ../../../grlib-gpl/lib/cypress/ssram/components.vhd
ghdl -i --mb-comments --workdir=gnu/cypress --work=cypress -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress ../../../grlib-gpl/lib/cypress/ssram/package_utility.vhd
ghdl -i --mb-comments --workdir=gnu/cypress --work=cypress -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress ../../../grlib-gpl/lib/cypress/ssram/cy7c1354b.vhd
ghdl -i --mb-comments --workdir=gnu/cypress --work=cypress -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress ../../../grlib-gpl/lib/cypress/ssram/cy7c1380d.vhd
mkdir -p gnu/work
ghdl -i --mb-comments --workdir=gnu/work --work=work -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress -Pgnu/work ../../../grlib-gpl/lib/work/debug/debug.vhd
ghdl -i --mb-comments --workdir=gnu/work --work=work -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress -Pgnu/work ../../../grlib-gpl/lib/work/debug/grtestmod.vhd
ghdl -i --mb-comments --workdir=gnu/work --work=work -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress -Pgnu/work ../../../grlib-gpl/lib/work/debug/cpu_disas.vhd
ghdl -i --mb-comments --workdir=gnu/work --work=work -Pgnu -Pgnu/grlib -Pgnu/unisim -Pgnu/techmap -Pgnu/spw -Pgnu/eth -Pgnu/gaisler -Pgnu/esa -Pgnu/spansion -Pgnu/lpp -Pgnu/opencores_spw -Pgnu/cypress -Pgnu/work tb.vhd
make[1] : on quitte le répertoire « /tmp/VHD_Lib/tests/lpp_memory/lpp_fifo »
ghdl -m -fexplicit --ieee=synopsys --mb-comments --warn-no-binding -O2 --workdir=gnu/work --work=work `cat ghdl.path` testbench
analyze ../../../grlib-gpl/lib/grlib/stdlib/config_types.vhd
analyze ../../../grlib-gpl/lib/grlib/stdlib/config.vhd
analyze ../../../grlib-gpl/lib/techmap/gencomp/gencomp.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/general_purpose.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./general_purpose/data_type_pkg.vhd
analyze ../../../grlib-gpl/lib/grlib/stdlib/version.vhd
analyze ../../../grlib-gpl/lib/grlib/stdlib/stdlib.vhd
analyze ../../../grlib-gpl/lib/grlib/amba/amba.vhd
analyze ../../../grlib-gpl/lib/gaisler/uart/uart.vhd
analyze ../../../grlib-gpl/lib/grlib/amba/devices.vhd
analyze ../../../grlib-gpl/lib/gaisler/misc/misc.vhd
analyze ../../../grlib-gpl/lib/gaisler/uart/libdcom.vhd
analyze ../../../grlib-gpl/lib/grlib/stdlib/stdio.vhd
analyze ../../../grlib-gpl/lib/gaisler/sim/sim.vhd
analyze ../../../grlib-gpl/lib/gaisler/jtag/jtagtst.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./lpp_sim/lpp_sim_pkg.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./lpp_amba/lpp_amba.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/iir_filter.vhd
analyze ../../../grlib-gpl/lib/gaisler/memctrl/memctrl.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_memory.vhd
analyze tb.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO.vhd
analyze ../../../grlib-gpl/lib/techmap/maps/allmem.vhd
analyze ../../../grlib-gpl/lib/techmap/maps/syncram_2p.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CEL.vhd
analyze ../../../grlib-gpl/lib/../../lib/lpp/./lpp_memory/lpp_FIFO_control.vhd
analyze ../../../grlib-gpl/lib/techmap/maps/memrwcol.vhd
analyze ../../../grlib-gpl/lib/techmap/inferred/memory_inferred.vhd
analyze ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VPKG.vhd
analyze ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VCOMP.vhd
analyze ../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:48722:1:warning: redefinition of a library unit in same design file: [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:48722:1:warning: entity "bufhce" defined at line 308:8 is now entity "bufhce" [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:48740:1:warning: redefinition of a library unit in same design file: [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:48740:1:warning: architecture "bufhce_v" of "bufhce" defined at line 321:14 is now architecture "bufhce_v" of "bufhce" [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:271819:1:warning: redefinition of a library unit in same design file: [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:271819:1:warning: entity "bufr" defined at line 48972:8 is now entity "bufr" [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:271844:1:warning: redefinition of a library unit in same design file: [-Wlibrary]
../../../grlib-gpl/lib/tech/unisim/ise/unisim_VITAL.vhd:271844:1:warning: architecture "bufr_v" of "bufr" defined at line 48990:14 is now architecture "bufr_v" of "bufr" [-Wlibrary]
 
analyze ../../../grlib-gpl/lib/techmap/unisim/memory_unisim.vhd
elaborate testbench
./testbench --assert-level=error --ieee-asserts=disable
../../../grlib-gpl/lib/../../lib/lpp/./dsp/iir_filter/RAM_CEL.vhd:85:9:@0ms:(report note): initialysing RAM CEL To 0
tb.vhd:76:5:@20940010ps:(assertion note): end of test
tb.vhd:91:7:@20950010ps:(assertion note): end of test
Test FIFO done

```

# LICENSE

All the programs used by the VHD_Lib are protected by their respective
license. They all are free software and most of them are covered by the
GNU General Public License.

# Feedback

Please send feedbacks to **Alexis Jeandet**  alexis.jeandet@member.fsf.org

