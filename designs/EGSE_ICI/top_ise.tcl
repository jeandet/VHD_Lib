project new top.ise
project set family "PROASIC3"
project set device A3PE1500
project set speed Std
project set package ""
puts "Adding files to project"
lib_vhdl new grlib
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/version.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/version.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/config.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/config.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/stdlib.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/stdlib.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/sparc/sparc.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/sparc/sparc.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/modgen/multlib.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/modgen/multlib.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/modgen/leaves.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/modgen/leaves.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/amba.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/amba.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/devices.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/devices.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/defmst.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/defmst.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/apbctrl.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/apbctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/ahbctrl.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/ahbctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb_pkg.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb.vhd" -lib_vhdl grlib
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb.vhd"
lib_vhdl new synplify
lib_vhdl new techmap
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/gencomp.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/gencomp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/netcomp.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/netcomp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/memory_inferred.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/memory_inferred.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_inferred.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_inferred.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/mul_inferred.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/mul_inferred.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_phy_inferred.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_phy_inferred.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allclkgen.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allclkgen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allddr.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allddr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmem.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmem.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmul.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmul.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allpads.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allpads.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/alltap.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/alltap.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkgen.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkgen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkmux.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkmux.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkand.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkand.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_ireg.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_ireg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_oreg.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_oreg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddrphy.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddrphy.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram64.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram64.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_2p.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_2p.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_dp.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_dp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncfifo.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncfifo.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/regfile_3p.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/regfile_3p.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/tap.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/tap.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/techbuf.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/techbuf.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/nandtree.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/nandtree.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad_ds.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad_ds.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ds.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ds.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iodpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iodpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ds.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ds.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/lvds_combo.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/lvds_combo.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/odpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/odpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ds.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ds.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/toutpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/toutpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/skew_outpad.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/skew_outpad.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc2_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc2_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grlfpw_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grlfpw_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grfpw_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grfpw_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/leon4_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/leon4_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/mul_61x61.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/mul_61x61.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/cpu_disas_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/cpu_disas_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grusbhc_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grusbhc_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ringosc.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ringosc.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ssrctrl_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ssrctrl_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/system_monitor.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/system_monitor.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grgates.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grgates.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ddr.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ddr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ddr.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ddr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ddr.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ddr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128bw.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128bw.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram156bw.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram156bw.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/techmult.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/techmult.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/spictrl_net.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/spictrl_net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/scanreg.vhd" -lib_vhdl techmap
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/scanreg.vhd"
lib_vhdl new spw
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/comp/spwcomp.vhd" -lib_vhdl spw
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/comp/spwcomp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw_gen.vhd" -lib_vhdl spw
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw_gen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw2_gen.vhd" -lib_vhdl spw
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw2_gen.vhd"
lib_vhdl new eth
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/comp/ethcomp.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/comp/ethcomp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_pkg.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_rstgen.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_rstgen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_edcl_ahb_mst.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_edcl_ahb_mst.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_ahb_mst.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_ahb_mst.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_tx.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_tx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_rx.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_rx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/grethc.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/grethc.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gen.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gbit_gen.vhd" -lib_vhdl eth
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gbit_gen.vhd"
lib_vhdl new opencores
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/occomp/occomp.vhd" -lib_vhdl opencores
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/occomp/occomp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/can/cancomp.vhd" -lib_vhdl opencores
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/can/cancomp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/can/can_top.vhd" -lib_vhdl opencores
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/can/can_top.vhd"
lib_vhdl new gaisler
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/arith.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/arith.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/mul32.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/mul32.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/div32.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/div32.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/memctrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/memctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl64.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl64.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdmctrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdmctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/srctrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/srctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/spimctrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/spimctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuconfig.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuconfig.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuiface.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuiface.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libmmu.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libmmu.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libiu.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libiu.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libcache.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libcache.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libproc3.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libproc3.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cachemem.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cachemem.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_icache.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_icache.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_dcache.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_dcache.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_acache.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_acache.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlbcam.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlbcam.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulrue.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulrue.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulru.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulru.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlb.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutw.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutw.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_cache.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_cache.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cpu_disasx.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cpu_disasx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/iu3.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/iu3.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwx.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mfpwx.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mfpwx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grlfpwx.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grlfpwx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/tbufmem.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/tbufmem.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3x.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3x.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/proc3.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/proc3.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3s.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3s.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3cg.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3cg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/irqmp.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/irqmp.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwxsh.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwxsh.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpushwx.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpushwx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3sh.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3sh.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3ft/leon3ft.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3ft/leon3ft.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mod.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mod.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_oc.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_oc.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mc.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mc.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/canmux.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/canmux.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_rd.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_rd.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/misc.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/misc.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/rstgen.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/rstgen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gptimer.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gptimer.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbram.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbram.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbdpram.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbdpram.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mb.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mmb.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mmb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpio.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpio.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbstat.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbstat.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/logan.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/logan.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbps2.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbps2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom_package.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom_package.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbvga.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbvga.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/svgactrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/svgactrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cmst_gen.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cmst_gen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrlx.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrlx.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cslv.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cslv.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild2ahb.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild2ahb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grsysmon.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grsysmon.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gracectrl.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gracectrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpreg.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpreg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst2.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahb_mst_iface.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahb_mst_iface.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/net/net.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/net/net.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/uart.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/uart.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/libdcom.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/libdcom.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/apbuart.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/apbuart.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom_uart.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom_uart.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/ahbuart.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/ahbuart.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtag.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtag.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/libjtagcom.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/libjtagcom.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtagcom.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtagcom.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag_bsd.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag_bsd.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregs.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregs.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregsbd.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregsbd.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/ethernet_mac.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/ethernet_mac.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_mb.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_mb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit_mb.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit_mb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/grethm.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/grethm.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/spacewire.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/spacewire.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw2.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspwm.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspwm.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/gr1553b/gr1553b_pkg.vhd" -lib_vhdl gaisler
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/gr1553b/gr1553b_pkg.vhd"
lib_vhdl new esa
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/memoryctrl.vhd" -lib_vhdl esa
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/memoryctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/mctrl.vhd" -lib_vhdl esa
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/mctrl.vhd"
lib_vhdl new fmf
lib_vhdl new spansion
lib_vhdl new gsi
lib_vhdl new lpp
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/FRAME_CLK.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/FRAME_CLK.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_CFG.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_CFG.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_DRVR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_DRVR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_ENGINE.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_ENGINE.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_2x16_DRIVER.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_2x16_DRIVER.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_CLK_GENERATOR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_CLK_GENERATOR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/Top_LCD.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/Top_LCD.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/amba_lcd_16x2_ctrlr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/amba_lcd_16x2_ctrlr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/apb_lcd_ctrlr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/apb_lcd_ctrlr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_CEL.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_CEL.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_Filter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_Filter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER_RAM_CTRLR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER_RAM_CTRLR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTERcfg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTERcfg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FilterCTRLR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FilterCTRLR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_FILTER.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_FILTER.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL_N.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL_N.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR2.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_Filtre_IIR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_Filtre_IIR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_IIR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_IIR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/iir_filter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/iir_filter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT_half.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT_half.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Driver_FFT.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Driver_FFT.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTamont.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTamont.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTaval.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTaval.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ADDRcntr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ADDRcntr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ALU.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ALU.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Adder.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Adder.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_Divider2.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_Divider2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_divider.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_divider.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_CONTROLER.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_CONTROLER.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX2.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_REG.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_REG.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUX2.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUX2.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUXN.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUXN.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Multiplier.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Multiplier.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/REG.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/REG.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/SYNC_FF.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/SYNC_FF.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Shifter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Shifter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/TwoComplementer.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/TwoComplementer.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/general_purpose.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/general_purpose.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/APB_AMR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/APB_AMR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Clock_multi.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Clock_multi.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Dephaseur.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Dephaseur.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Gene_Rz.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Gene_Rz.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/bclk_reg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/bclk_reg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/lpp_AMR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/lpp_AMR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/APB_Balise.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/APB_Balise.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/lpp_balise.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/lpp_balise.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/APB_Delay.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/APB_Delay.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/TimerDelay.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/TimerDelay.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/lpp_delay.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/lpp_delay.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/apb_lfr_time_management.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/apb_lfr_time_management.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/lfr_time_management.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/lfr_time_management.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/lpp_lfr_time_management.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/lpp_lfr_time_management.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr_sync.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr_sync.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_spi_if.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_spi_if.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1274_drvr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1274_drvr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1278_drvr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1278_drvr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS7886_drvr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS7886_drvr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/RHF1401.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/RHF1401.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/WriteGen_ADC.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/WriteGen_ADC.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/dual_ADS1278_drvr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/dual_ADS1278_drvr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_apb_ad_conv.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_apb_ad_conv.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/top_ad_conv.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/top_ad_conv.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_MULTI_DIODE.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_MULTI_DIODE.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_SIMPLE_DIODE.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_SIMPLE_DIODE.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/apb_devices_list.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/apb_devices_list.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/lpp_amba.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/lpp_amba.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/bootrom.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/bootrom.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader_pkg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/APB_CNA.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/APB_CNA.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/CNA_TabloC.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/CNA_TabloC.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Convertisseur_config.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Convertisseur_config.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Gene_SYNC.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Gene_SYNC.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Serialize.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Serialize.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Systeme_Clock.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Systeme_Clock.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/lpp_cna.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/lpp_cna.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/DEMUX.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/DEMUX.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/lpp_demux.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/lpp_demux.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/fifo_latency_correction.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/fifo_latency_correction.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_apbreg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_apbreg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_fsm.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_fsm.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_ip.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_ip.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_pkg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_Header/HeaderBuilder.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_Header/HeaderBuilder.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_Header/lpp_Header.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_Header/lpp_Header.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/APB_Matrix.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/APB_Matrix.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Dispatch.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Dispatch.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/DriveInputs.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/DriveInputs.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/GetResult.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/GetResult.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Matrix.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Matrix.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Starter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Starter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopMatrix_PDR.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopMatrix_PDR.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopSpecMatrix.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopSpecMatrix.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Top_MatrixSpec.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Top_MatrixSpec.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/lpp_matrix.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/lpp_matrix.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/FillFifo.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/FillFifo.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin_vsim.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin_vsim.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_FIFO.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_FIFO.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_ms.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_ms.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_pkg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_acq.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_acq.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_acq.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_acq.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_apbreg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_apbreg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd.bak" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd.bak"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker_ip.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker_ip.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker_ip_whitout_filter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker_ip_whitout_filter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/top_wf_picker.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/top_wf_picker.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/APB_UART.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/APB_UART.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/BaudGen.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/BaudGen.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/Shift_REG.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/Shift_REG.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/UART.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/UART.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/lpp_uart.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/lpp_uart.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/APB_USB.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/APB_USB.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/FX2_Driver.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/FX2_Driver.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/RWbuf.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/RWbuf.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/lpp_usb.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/lpp_usb.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_burst.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_burst.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_genvalid.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_genvalid.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_selectaddress.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_selectaddress.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_send_Nword.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_send_Nword.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo_ctrl.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo_ctrl.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_pkg.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_pkg.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot_controler.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot_controler.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_valid_ack.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_valid_ack.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/MinF_Cntr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/MinF_Cntr.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Rocket_PCM_Encoder.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Rocket_PCM_Encoder.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver_Multiplexor.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver_Multiplexor.vhd"
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Word_Cntr.vhd" -lib_vhdl lpp
puts "C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Word_Cntr.vhd"
lib_vhdl new work
xfile add "C:/opt/grlib-gpl-1.1.0-b4108/boards/GSE_ICI/top.ucf"
xfile add "config.vhd" -lib_vhdl work
puts "config.vhd"
xfile add "ahbrom.vhd" -lib_vhdl work
puts "ahbrom.vhd"
xfile add "leon3mp.vhd" -lib_vhdl work
puts "leon3mp.vhd"
project set top "rtl" "top"
project set "Bus Delimiter" ()
project set "FSM Encoding Algorithm" None
project set "Pack I/O Registers into IOBs" yes
project set "Verilog Macros" ""
project set "Other XST Command Line Options" "" -process "Synthesize - XST"
project set "Allow Unmatched LOC Constraints" true -process "Translate"
project set "Macro Search Path" "C:/opt/grlib-gpl-1.1.0-b4108/netlists/xilinx/PROASIC3" -process "Translate"
project set "Pack I/O Registers/Latches into IOBs" {For Inputs and Outputs}
project set "Other MAP Command Line Options" "" -process Map
project set "Drive Done Pin High" true -process "Generate Programming File"
project set "Create ReadBack Data Files" true -process "Generate Programming File"
project set "Create Mask File" true -process "Generate Programming File"
project set "Run Design Rules Checker (DRC)" false -process "Generate Programming File"
project close
exit
