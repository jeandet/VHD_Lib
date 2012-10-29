# GRLIB Makefile generated settings
set design top
set pnc 
set device 
set package 
set top_hdl 

### Project Settings
#
# The parameters in this section are for documentation purposes mostly
# and can be changed by the user without affecting synthesis results
# Multi-word strings (e.g. eASIC Corp) must be enwrapped in double
# quotes, so "eASIC Corp."

# project: string; Project name
set project "leon3"

# company: string; Company name
set company "gaisler"

# designer: string; Designer name
set designer ""

# email: string; Designer's email address
set email "${designer}@${company}.com"

# email_notification: enumerated [on,off]
# When 'on' CDB sends an email to the designer's email address
# with the status of the last run and the log file attached
set email_notification off


### Design
#
# The parameters in this section define the eASIC Structured ASIC
# the design will be implemented on 

# pnc: number; Part Number Code, unique project identifier
# provided by eASIC
#set pnc 50123

# design: string; Top Level name
#set design leon3mp

# device: enumerated [NX750,NX1500,NX2500,NX4000,NX5000]
# Device selects the eASIC Structured ASIC platform
#set device NX1500

# package: string; package for selected device
# 
#set package FC480

# device_type: enumerated [sl,vl]
# sl: SRAM configured Lookup table device
# vl: Via configured Lookup table device
set device_type sl

# technology; enumerated [std,hp]
# std: 1.2V standard device
# hp : 1.3V high performance device
set technology std


### Flow
#
# The parameters in this section provide various options
# to guide the synthesis flow

# fsm_optimization: enumerated [on,off]
# fsm_encoding    : enumerated [auto,binary,gray,one_hot]
# These parameters turn on/off Finite State Machine recoding with the
# method defined by 'fsm_encoding'.
# Turning on this option can result in smaller and/or faster FSM
# implementations, but may lead to formal verification errors
set fsm_optimization off
set fsm_encoding auto

# boolean_mapper: enumerated [on,off]
# Turn on/off Magma boolean mapper technology
# Turning on this option generally yields a smaller and faster design
set boolean_mapper on

# use_rtbuf: enumerated [on,off]
# Turn on/off long net buffering using high-drive buffers (rtbuf)
# Setting use_rtbuf to 'off' disables 'fix fj90 rtbuf'
set use_rtbuf on

# effort: enumerated [low,medium,high]; (area) synthesis effort
set effort medium

# timing_effort: enumerated [low,medium,high]; timing effort
set timing_effort medium

# timing_slack: real; initial positive timing slack target
set timing_slack 1n

# clock_effort: enumerated [low,high]
# Should be set to 'low' for 2008 Magma releases, can be set to 'high' for older releases
set clock_effort low

# utilization: real; area utilization
# Maximum area utilization during placement. Typical values range
# from 0.7 to 1.0. Lower values may improve timing or relax placement
# effort, but lead to less area efficient implementations.
set utilization 0.8

# clone_ff: enumerated [on,off]
# Turn on/off replication of flipflops to drive large loads.
# It is recommended to set this parameter to 'on'.
# Set it to 'off' if encountering formal verification issues.
set clone_ff on

# fanout_limit: integer;
# fanout_strict: enumerated [strict,noworse]
# Sets the maximum fanout per cell (fanout_limit) and how the
# synthesis tool resolves the fanout; always buffer if the load is
# higher than the fanout (strict), or only buffer if the load is
# higher than the fanout AND buffering doesn't affect timing (noworse)
set fanout_limit 10
set fanout_strict strict

# timing_paths: integer
# Sets the number of timing paths reported during the various timing
# analysis reports
set timing_paths 10


### Directories
#
# The parameters in this section set multiple directories.
# There should be no need to change any of the following parameters 

# proj_rootdir: string
# Sets the path to the project root, as seen from the 'run' directory
set proj_rootdir ../../..

# srcdir: string
# Sets the directory containing user files (e.g. design and constraints)
# This typically points to 'src'
set srcdir $proj_rootdir/src

# rtldir: string
# Sets the directory containing RTL files
# This typically points to 'src/rtl'
set rtldir $srcdir/rtl

# constraintsdir: string
# Sets the directory containing design constraints (.sdc, .pad) files
# This typically points to 'src/constraints'
set constraintsdir $srcdir/constraints

# snap: enumerated [on|off]
# Enables or disabled Magma synthesis snap-shot generation.
# snap must be on if the CDB 'start_at' option is to be used.
set snap on

# volcano_compression: enumerated [none,min,med,max]
# Sets the Magma library volcano compression level
set volcano_compression none


### Constraints
#
# The parameters in this section set/point to synthesis constraints

# pad_file: string
# Points to an eWizard generated file containing pad and macro placement commands
# Typically points to 'src/constraints/<design>.pad
set pad_file $constraintsdir/${design}.pad

# sdc_file: string
# Points to a user generated file containing timing constraints in
# Synopsys Design Constraints (sdc) format.
# Typically points to 'src/constraints/<design>.sdc
set sdc_file $constraintsdir/${design}.sdc

# verilog2k: enumerated [on|off]
# Enables/disabled Verilog2001 support
set verilog2k on

# undriven: enumerated [0,1,X,U,reset]
# Sets the physical synthesis tool's behaviour with regards to undriven
# pins. By default this is set to 'U', meaning leave undriven pins
# floating so they can be detected and fixed in RTL.
set undriven U

# topfile: string
# The name of the file containing the top level RTL module
#set topfile $rtldir/<top file>
#if {[regexp {\.v$} $topfile]} {set top_hdl verilog} else {set top_hdl vhdl}


### Design files
#
set includeList  {}
set defineList   {}
set netlistList  {}
set vhdllibList  {}
set read_netlist {}
set read_rtl     {}
set read_plan    {}

# GRLIB Makefile generated HDL list
set vhdlList {
{grlib  ../../../../../../lib/grlib/stdlib/version.vhd ../../../../../../lib/grlib/stdlib/config.vhd ../../../../../../lib/grlib/stdlib/stdlib.vhd ../../../../../../lib/grlib/sparc/sparc.vhd ../../../../../../lib/grlib/sparc/sparc_disas.vhd ../../../../../../lib/grlib/sparc/cpu_disas.vhd ../../../../../../lib/grlib/modgen/multlib.vhd ../../../../../../lib/grlib/modgen/leaves.vhd ../../../../../../lib/grlib/amba/amba.vhd ../../../../../../lib/grlib/amba/devices.vhd ../../../../../../lib/grlib/amba/defmst.vhd ../../../../../../lib/grlib/amba/apbctrl.vhd ../../../../../../lib/grlib/amba/ahbctrl.vhd ../../../../../../lib/grlib/amba/dma2ahb_pkg.vhd ../../../../../../lib/grlib/amba/dma2ahb.vhd}
{techmap  ../../../../../../lib/techmap/gencomp/gencomp.vhd ../../../../../../lib/techmap/gencomp/netcomp.vhd ../../../../../../lib/techmap/inferred/memory_inferred.vhd ../../../../../../lib/techmap/inferred/ddr_inferred.vhd ../../../../../../lib/techmap/inferred/mul_inferred.vhd ../../../../../../lib/techmap/inferred/ddr_phy_inferred.vhd ../../../../../../lib/techmap/dware/mul_dware.vhd ../../../../../../lib/techmap/maps/allclkgen.vhd ../../../../../../lib/techmap/maps/allddr.vhd ../../../../../../lib/techmap/maps/allmem.vhd ../../../../../../lib/techmap/maps/allmul.vhd ../../../../../../lib/techmap/maps/allpads.vhd ../../../../../../lib/techmap/maps/alltap.vhd ../../../../../../lib/techmap/maps/clkgen.vhd ../../../../../../lib/techmap/maps/clkmux.vhd ../../../../../../lib/techmap/maps/clkand.vhd ../../../../../../lib/techmap/maps/ddr_ireg.vhd ../../../../../../lib/techmap/maps/ddr_oreg.vhd ../../../../../../lib/techmap/maps/ddrphy.vhd ../../../../../../lib/techmap/maps/syncram.vhd ../../../../../../lib/techmap/maps/syncram64.vhd ../../../../../../lib/techmap/maps/syncram_2p.vhd ../../../../../../lib/techmap/maps/syncram_dp.vhd ../../../../../../lib/techmap/maps/syncfifo.vhd ../../../../../../lib/techmap/maps/regfile_3p.vhd ../../../../../../lib/techmap/maps/tap.vhd ../../../../../../lib/techmap/maps/techbuf.vhd ../../../../../../lib/techmap/maps/nandtree.vhd ../../../../../../lib/techmap/maps/clkpad.vhd ../../../../../../lib/techmap/maps/clkpad_ds.vhd ../../../../../../lib/techmap/maps/inpad.vhd ../../../../../../lib/techmap/maps/inpad_ds.vhd ../../../../../../lib/techmap/maps/iodpad.vhd ../../../../../../lib/techmap/maps/iopad.vhd ../../../../../../lib/techmap/maps/iopad_ds.vhd ../../../../../../lib/techmap/maps/lvds_combo.vhd ../../../../../../lib/techmap/maps/odpad.vhd ../../../../../../lib/techmap/maps/outpad.vhd ../../../../../../lib/techmap/maps/outpad_ds.vhd ../../../../../../lib/techmap/maps/toutpad.vhd ../../../../../../lib/techmap/maps/skew_outpad.vhd ../../../../../../lib/techmap/maps/grspwc_net.vhd ../../../../../../lib/techmap/maps/grspwc2_net.vhd ../../../../../../lib/techmap/maps/grlfpw_net.vhd ../../../../../../lib/techmap/maps/grfpw_net.vhd ../../../../../../lib/techmap/maps/leon4_net.vhd ../../../../../../lib/techmap/maps/mul_61x61.vhd ../../../../../../lib/techmap/maps/cpu_disas_net.vhd ../../../../../../lib/techmap/maps/grusbhc_net.vhd ../../../../../../lib/techmap/maps/ringosc.vhd ../../../../../../lib/techmap/maps/ssrctrl_net.vhd ../../../../../../lib/techmap/maps/system_monitor.vhd ../../../../../../lib/techmap/maps/grgates.vhd ../../../../../../lib/techmap/maps/inpad_ddr.vhd ../../../../../../lib/techmap/maps/outpad_ddr.vhd ../../../../../../lib/techmap/maps/iopad_ddr.vhd ../../../../../../lib/techmap/maps/syncram128bw.vhd ../../../../../../lib/techmap/maps/syncram128.vhd ../../../../../../lib/techmap/maps/syncram156bw.vhd ../../../../../../lib/techmap/maps/techmult.vhd ../../../../../../lib/techmap/maps/spictrl_net.vhd ../../../../../../lib/techmap/maps/scanreg.vhd}
{spw  ../../../../../../lib/spw/comp/spwcomp.vhd ../../../../../../lib/spw/wrapper/grspw_gen.vhd ../../../../../../lib/spw/wrapper/grspw2_gen.vhd}
{eth  ../../../../../../lib/eth/comp/ethcomp.vhd ../../../../../../lib/eth/core/greth_pkg.vhd ../../../../../../lib/eth/core/eth_rstgen.vhd ../../../../../../lib/eth/core/eth_edcl_ahb_mst.vhd ../../../../../../lib/eth/core/eth_ahb_mst.vhd ../../../../../../lib/eth/core/greth_tx.vhd ../../../../../../lib/eth/core/greth_rx.vhd ../../../../../../lib/eth/core/grethc.vhd ../../../../../../lib/eth/wrapper/greth_gen.vhd ../../../../../../lib/eth/wrapper/greth_gbit_gen.vhd}
{opencores  ../../../../../../lib/opencores/occomp/occomp.vhd ../../../../../../lib/opencores/can/cancomp.vhd ../../../../../../lib/opencores/can/can_top.vhd}
{gaisler  ../../../../../../lib/gaisler/arith/arith.vhd ../../../../../../lib/gaisler/arith/mul32.vhd ../../../../../../lib/gaisler/arith/div32.vhd ../../../../../../lib/gaisler/memctrl/memctrl.vhd ../../../../../../lib/gaisler/memctrl/sdctrl.vhd ../../../../../../lib/gaisler/memctrl/sdctrl64.vhd ../../../../../../lib/gaisler/memctrl/sdmctrl.vhd ../../../../../../lib/gaisler/memctrl/srctrl.vhd ../../../../../../lib/gaisler/memctrl/spimctrl.vhd ../../../../../../lib/gaisler/leon3/leon3.vhd ../../../../../../lib/gaisler/leon3/mmuconfig.vhd ../../../../../../lib/gaisler/leon3/mmuiface.vhd ../../../../../../lib/gaisler/leon3/libmmu.vhd ../../../../../../lib/gaisler/leon3/libiu.vhd ../../../../../../lib/gaisler/leon3/libcache.vhd ../../../../../../lib/gaisler/leon3/libproc3.vhd ../../../../../../lib/gaisler/leon3/cachemem.vhd ../../../../../../lib/gaisler/leon3/mmu_icache.vhd ../../../../../../lib/gaisler/leon3/mmu_dcache.vhd ../../../../../../lib/gaisler/leon3/mmu_acache.vhd ../../../../../../lib/gaisler/leon3/mmutlbcam.vhd ../../../../../../lib/gaisler/leon3/mmulrue.vhd ../../../../../../lib/gaisler/leon3/mmulru.vhd ../../../../../../lib/gaisler/leon3/mmutlb.vhd ../../../../../../lib/gaisler/leon3/mmutw.vhd ../../../../../../lib/gaisler/leon3/mmu.vhd ../../../../../../lib/gaisler/leon3/mmu_cache.vhd ../../../../../../lib/gaisler/leon3/cpu_disasx.vhd ../../../../../../lib/gaisler/leon3/iu3.vhd ../../../../../../lib/gaisler/leon3/grfpwx.vhd ../../../../../../lib/gaisler/leon3/mfpwx.vhd ../../../../../../lib/gaisler/leon3/grlfpwx.vhd ../../../../../../lib/gaisler/leon3/tbufmem.vhd ../../../../../../lib/gaisler/leon3/dsu3x.vhd ../../../../../../lib/gaisler/leon3/dsu3.vhd ../../../../../../lib/gaisler/leon3/proc3.vhd ../../../../../../lib/gaisler/leon3/leon3s.vhd ../../../../../../lib/gaisler/leon3/leon3cg.vhd ../../../../../../lib/gaisler/leon3/irqmp.vhd ../../../../../../lib/gaisler/leon3/grfpwxsh.vhd ../../../../../../lib/gaisler/leon3/grfpushwx.vhd ../../../../../../lib/gaisler/leon3/leon3sh.vhd ../../../../../../lib/gaisler/leon3ft/leon3ft.vhd ../../../../../../lib/gaisler/can/can.vhd ../../../../../../lib/gaisler/can/can_mod.vhd ../../../../../../lib/gaisler/can/can_oc.vhd ../../../../../../lib/gaisler/can/can_mc.vhd ../../../../../../lib/gaisler/can/canmux.vhd ../../../../../../lib/gaisler/can/can_rd.vhd ../../../../../../lib/gaisler/misc/misc.vhd ../../../../../../lib/gaisler/misc/rstgen.vhd ../../../../../../lib/gaisler/misc/gptimer.vhd ../../../../../../lib/gaisler/misc/ahbram.vhd ../../../../../../lib/gaisler/misc/ahbdpram.vhd ../../../../../../lib/gaisler/misc/ahbtrace.vhd ../../../../../../lib/gaisler/misc/ahbtrace_mb.vhd ../../../../../../lib/gaisler/misc/ahbtrace_mmb.vhd ../../../../../../lib/gaisler/misc/ahbmst.vhd ../../../../../../lib/gaisler/misc/grgpio.vhd ../../../../../../lib/gaisler/misc/ahbstat.vhd ../../../../../../lib/gaisler/misc/logan.vhd ../../../../../../lib/gaisler/misc/apbps2.vhd ../../../../../../lib/gaisler/misc/charrom_package.vhd ../../../../../../lib/gaisler/misc/charrom.vhd ../../../../../../lib/gaisler/misc/apbvga.vhd ../../../../../../lib/gaisler/misc/svgactrl.vhd ../../../../../../lib/gaisler/misc/i2cmst_gen.vhd ../../../../../../lib/gaisler/misc/spictrlx.vhd ../../../../../../lib/gaisler/misc/spictrl.vhd ../../../../../../lib/gaisler/misc/i2cslv.vhd ../../../../../../lib/gaisler/misc/wild.vhd ../../../../../../lib/gaisler/misc/wild2ahb.vhd ../../../../../../lib/gaisler/misc/grsysmon.vhd ../../../../../../lib/gaisler/misc/gracectrl.vhd ../../../../../../lib/gaisler/misc/grgpreg.vhd ../../../../../../lib/gaisler/misc/ahbmst2.vhd ../../../../../../lib/gaisler/misc/ahb_mst_iface.vhd ../../../../../../lib/gaisler/net/net.vhd ../../../../../../lib/gaisler/uart/uart.vhd ../../../../../../lib/gaisler/uart/libdcom.vhd ../../../../../../lib/gaisler/uart/apbuart.vhd ../../../../../../lib/gaisler/uart/dcom.vhd ../../../../../../lib/gaisler/uart/dcom_uart.vhd ../../../../../../lib/gaisler/uart/ahbuart.vhd ../../../../../../lib/gaisler/jtag/jtag.vhd ../../../../../../lib/gaisler/jtag/libjtagcom.vhd ../../../../../../lib/gaisler/jtag/jtagcom.vhd ../../../../../../lib/gaisler/jtag/ahbjtag.vhd ../../../../../../lib/gaisler/jtag/ahbjtag_bsd.vhd ../../../../../../lib/gaisler/jtag/bscanregs.vhd ../../../../../../lib/gaisler/jtag/bscanregsbd.vhd ../../../../../../lib/gaisler/greth/ethernet_mac.vhd ../../../../../../lib/gaisler/greth/greth.vhd ../../../../../../lib/gaisler/greth/greth_mb.vhd ../../../../../../lib/gaisler/greth/greth_gbit.vhd ../../../../../../lib/gaisler/greth/greth_gbit_mb.vhd ../../../../../../lib/gaisler/greth/grethm.vhd ../../../../../../lib/gaisler/spacewire/spacewire.vhd ../../../../../../lib/gaisler/spacewire/grspw.vhd ../../../../../../lib/gaisler/spacewire/grspw2.vhd ../../../../../../lib/gaisler/spacewire/grspwm.vhd ../../../../../../lib/gaisler/gr1553b/gr1553b_pkg.vhd}
{esa  ../../../../../../lib/esa/memoryctrl/memoryctrl.vhd ../../../../../../lib/esa/memoryctrl/mctrl.vhd}
{lpp  ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/FRAME_CLK.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_CFG.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_DRVR.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_ENGINE.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/LCD_2x16_DRIVER.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/LCD_CLK_GENERATOR.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/Top_LCD.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/amba_lcd_16x2_ctrlr.vhd ../../../../../../lib/lpp/./amba_lcd_16x2_ctrlr/apb_lcd_ctrlr.vhd ../../../../../../lib/lpp/./dsp/iir_filter/APB_IIR_CEL.vhd ../../../../../../lib/lpp/./dsp/iir_filter/APB_IIR_Filter.vhd ../../../../../../lib/lpp/./dsp/iir_filter/FILTER.vhd ../../../../../../lib/lpp/./dsp/iir_filter/FILTER_RAM_CTRLR.vhd ../../../../../../lib/lpp/./dsp/iir_filter/FILTERcfg.vhd ../../../../../../lib/lpp/./dsp/iir_filter/FilterCTRLR.vhd ../../../../../../lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR.vhd ../../../../../../lib/lpp/./dsp/iir_filter/IIR_CEL_FILTER.vhd ../../../../../../lib/lpp/./dsp/iir_filter/RAM.vhd ../../../../../../lib/lpp/./dsp/iir_filter/RAM_CEL.vhd ../../../../../../lib/lpp/./dsp/iir_filter/RAM_CTRLR2.vhd ../../../../../../lib/lpp/./dsp/iir_filter/Top_Filtre_IIR.vhd ../../../../../../lib/lpp/./dsp/iir_filter/Top_IIR.vhd ../../../../../../lib/lpp/./dsp/iir_filter/iir_filter.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/APB_FFT.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/APB_FFT_half.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/CoreFFT.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/Driver_FFT.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/actar.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/actram.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/fftDp.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/fftSm.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/fft_components.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/lpp_fft.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/primitives.vhd ../../../../../../lib/lpp/./dsp/lpp_fft/twiddle.vhd ../../../../../../lib/lpp/./general_purpose/ADDRcntr.vhd ../../../../../../lib/lpp/./general_purpose/ALU.vhd ../../../../../../lib/lpp/./general_purpose/Adder.vhd ../../../../../../lib/lpp/./general_purpose/Clk_divider.vhd ../../../../../../lib/lpp/./general_purpose/MAC.vhd ../../../../../../lib/lpp/./general_purpose/MAC_CONTROLER.vhd ../../../../../../lib/lpp/./general_purpose/MAC_MUX.vhd ../../../../../../lib/lpp/./general_purpose/MAC_MUX2.vhd ../../../../../../lib/lpp/./general_purpose/MAC_REG.vhd ../../../../../../lib/lpp/./general_purpose/MUX2.vhd ../../../../../../lib/lpp/./general_purpose/Multiplier.vhd ../../../../../../lib/lpp/./general_purpose/REG.vhd ../../../../../../lib/lpp/./general_purpose/Shifter.vhd ../../../../../../lib/lpp/./general_purpose/general_purpose.vhd ../../../../../../lib/lpp/./general_purpose/lpp_AMR/APB_AMR.vhd ../../../../../../lib/lpp/./general_purpose/lpp_AMR/Clock_multi.vhd ../../../../../../lib/lpp/./general_purpose/lpp_AMR/Dephaseur.vhd ../../../../../../lib/lpp/./general_purpose/lpp_AMR/Gene_Rz.vhd ../../../../../../lib/lpp/./general_purpose/lpp_AMR/bclk_reg.vhd ../../../../../../lib/lpp/./general_purpose/lpp_AMR/lpp_AMR.vhd ../../../../../../lib/lpp/./general_purpose/lpp_balise/APB_Balise.vhd ../../../../../../lib/lpp/./general_purpose/lpp_balise/lpp_balise.vhd ../../../../../../lib/lpp/./general_purpose/lpp_delay/APB_Delay.vhd ../../../../../../lib/lpp/./general_purpose/lpp_delay/TimerDelay.vhd ../../../../../../lib/lpp/./general_purpose/lpp_delay/lpp_delay.vhd ../../../../../../lib/lpp/./lpp_ad_Conv/AD7688_drvr.vhd ../../../../../../lib/lpp/./lpp_ad_Conv/AD7688_spi_if.vhd ../../../../../../lib/lpp/./lpp_ad_Conv/ADS7886_drvr.vhd ../../../../../../lib/lpp/./lpp_ad_Conv/WriteGen_ADC.vhd ../../../../../../lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd ../../../../../../lib/lpp/./lpp_ad_Conv/lpp_apb_ad_conv.vhd ../../../../../../lib/lpp/./lpp_amba/APB_MULTI_DIODE.vhd ../../../../../../lib/lpp/./lpp_amba/APB_SIMPLE_DIODE.vhd ../../../../../../lib/lpp/./lpp_amba/apb_devices_list.vhd ../../../../../../lib/lpp/./lpp_amba/lpp_amba.vhd ../../../../../../lib/lpp/./lpp_cna/APB_CNA.vhd ../../../../../../lib/lpp/./lpp_cna/CNA_TabloC.vhd ../../../../../../lib/lpp/./lpp_cna/Convertisseur_config.vhd ../../../../../../lib/lpp/./lpp_cna/Gene_SYNC.vhd ../../../../../../lib/lpp/./lpp_cna/Serialize.vhd ../../../../../../lib/lpp/./lpp_cna/Systeme_Clock.vhd ../../../../../../lib/lpp/./lpp_cna/lpp_cna.vhd ../../../../../../lib/lpp/./lpp_matrix/ALU_Driver.vhd ../../../../../../lib/lpp/./lpp_matrix/ALU_v2.vhd ../../../../../../lib/lpp/./lpp_matrix/APB_Matrix.vhd ../../../../../../lib/lpp/./lpp_matrix/DriveInputs.vhd ../../../../../../lib/lpp/./lpp_matrix/GetResult.vhd ../../../../../../lib/lpp/./lpp_matrix/MAC_v2.vhd ../../../../../../lib/lpp/./lpp_matrix/Matrix.vhd ../../../../../../lib/lpp/./lpp_matrix/SpectralMatrix.vhd ../../../../../../lib/lpp/./lpp_matrix/Starter.vhd ../../../../../../lib/lpp/./lpp_matrix/TopMatrix_PDR.vhd ../../../../../../lib/lpp/./lpp_matrix/Top_MatrixSpec.vhd ../../../../../../lib/lpp/./lpp_matrix/TwoComplementer.vhd ../../../../../../lib/lpp/./lpp_matrix/lpp_matrix.vhd ../../../../../../lib/lpp/./lpp_memory/APB_FIFO.vhd ../../../../../../lib/lpp/./lpp_memory/SSRAM_plugin.vhd ../../../../../../lib/lpp/./lpp_memory/lppFIFOxN.vhd ../../../../../../lib/lpp/./lpp_memory/lpp_FIFO.vhd ../../../../../../lib/lpp/./lpp_memory/lpp_memory.vhd ../../../../../../lib/lpp/./lpp_uart/APB_UART.vhd ../../../../../../lib/lpp/./lpp_uart/BaudGen.vhd ../../../../../../lib/lpp/./lpp_uart/Shift_REG.vhd ../../../../../../lib/lpp/./lpp_uart/UART.vhd ../../../../../../lib/lpp/./lpp_uart/lpp_uart.vhd ../../../../../../lib/lpp/./lpp_usb/APB_USB.vhd ../../../../../../lib/lpp/./lpp_usb/RWbuf.vhd ../../../../../../lib/lpp/./lpp_usb/lpp_usb.vhd}
{work  ../../../../config.vhd ../../../../ahbrom.vhd ../../../../leon3mp.vhd}
}
set verilogList {
}
