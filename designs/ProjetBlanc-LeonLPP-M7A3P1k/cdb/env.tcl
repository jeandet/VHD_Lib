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
{grlib  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/version.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/config.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/stdlib.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/sparc/sparc.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/sparc/sparc_disas.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/sparc/cpu_disas.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/modgen/multlib.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/modgen/leaves.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/amba.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/devices.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/defmst.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/apbctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/ahbctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb.vhd}
{techmap  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/gencomp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/netcomp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/inferred/memory_inferred.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_inferred.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/inferred/mul_inferred.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_phy_inferred.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/dware/mul_dware.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/allclkgen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/allddr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmem.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmul.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/allpads.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/alltap.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkgen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkmux.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkand.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_ireg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_oreg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddrphy.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram64.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_2p.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_dp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncfifo.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/regfile_3p.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/tap.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/techbuf.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/nandtree.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad_ds.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ds.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/iodpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ds.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/lvds_combo.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/odpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ds.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/toutpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/skew_outpad.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc2_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/grlfpw_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/grfpw_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/leon4_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/mul_61x61.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/cpu_disas_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/grusbhc_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/ringosc.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/ssrctrl_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/system_monitor.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/grgates.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ddr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ddr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ddr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128bw.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram156bw.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/techmult.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/spictrl_net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/techmap/maps/scanreg.vhd}
{spw  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/spw/comp/spwcomp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw_gen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw2_gen.vhd}
{eth  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/comp/ethcomp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/greth_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/eth_rstgen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/eth_edcl_ahb_mst.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/eth_ahb_mst.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/greth_tx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/greth_rx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/core/grethc.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gbit_gen.vhd}
{opencores  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/opencores/occomp/occomp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/opencores/can/cancomp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/opencores/can/can_top.vhd}
{gaisler  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/arith/arith.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/arith/mul32.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/arith/div32.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/memctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl64.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdmctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/srctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/spimctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuconfig.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuiface.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libmmu.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libiu.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libcache.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libproc3.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cachemem.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_icache.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_dcache.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_acache.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlbcam.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulrue.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulru.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutw.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_cache.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cpu_disasx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/iu3.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mfpwx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grlfpwx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/tbufmem.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3x.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/proc3.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3s.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3cg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/irqmp.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwxsh.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpushwx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3sh.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/leon3ft/leon3ft.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/can/can.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mod.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_oc.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mc.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/can/canmux.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_rd.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/misc.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/rstgen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gptimer.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbram.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbdpram.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mmb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpio.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbstat.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/logan.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbps2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom_package.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbvga.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/svgactrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cmst_gen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrlx.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cslv.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild2ahb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grsysmon.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gracectrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpreg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahb_mst_iface.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/net/net.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/uart/uart.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/uart/libdcom.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/uart/apbuart.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom_uart.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/uart/ahbuart.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtag.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/libjtagcom.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtagcom.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag_bsd.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregs.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregsbd.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/greth/ethernet_mac.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_mb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit_mb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/greth/grethm.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/spacewire.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspwm.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/gaisler/gr1553b/gr1553b_pkg.vhd}
{esa  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/memoryctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/mctrl.vhd}
{lpp  ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/FRAME_CLK.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_CFG.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_DRVR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_ENGINE.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_2x16_DRIVER.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_CLK_GENERATOR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/Top_LCD.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/amba_lcd_16x2_ctrlr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/apb_lcd_ctrlr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_CEL.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_Filter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER_RAM_CTRLR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTERcfg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FilterCTRLR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_FILTER.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL_N.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_Filtre_IIR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_IIR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/iir_filter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT_half.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Driver_FFT.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTamont.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTaval.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ADDRcntr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ALU.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Adder.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_Divider2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_divider.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_CONTROLER.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_REG.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUX2.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUXN.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Multiplier.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/REG.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/SYNC_FF.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Shifter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/TwoComplementer.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/general_purpose.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/APB_AMR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Clock_multi.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Dephaseur.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Gene_Rz.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/bclk_reg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/lpp_AMR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/APB_Balise.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/lpp_balise.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/APB_Delay.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/TimerDelay.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/lpp_delay.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/apb_lfr_time_management.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/lfr_time_management.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lfr_time_management/lpp_lfr_time_management.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr_sync.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_spi_if.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1274_drvr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1278_drvr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS7886_drvr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/RHF1401.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/WriteGen_ADC.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/dual_ADS1278_drvr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_apb_ad_conv.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/top_ad_conv.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/top_ad_conv_RHF1401.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_MULTI_DIODE.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_SIMPLE_DIODE.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/apb_devices_list.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/lpp_amba.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/bootrom.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/APB_CNA.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/CNA_TabloC.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Convertisseur_config.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Gene_SYNC.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Serialize.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Systeme_Clock.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/lpp_cna.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/DEMUX.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/lpp_demux.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/fifo_latency_correction.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_apbreg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_fsm.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_ip.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_Header/HeaderBuilder.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_Header/lpp_Header.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/APB_Matrix.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Dispatch.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/DriveInputs.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/GetResult.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Matrix.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Starter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopMatrix_PDR.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopSpecMatrix.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Top_MatrixSpec.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/lpp_matrix.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/FIFO_pipeline.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/FillFifo.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin_vsim.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_FIFO.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_apbreg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_filter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_ms.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_lfr_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_acq.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_acq.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_apbreg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_pkg.vhd.bak ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker_ip.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/lpp_top_lfr_wf_picker_ip_whitout_filter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_top_lfr/top_wf_picker.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/APB_UART.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/BaudGen.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/Shift_REG.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/UART.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/lpp_uart.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/APB_USB.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/FX2_Driver.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/FX2_WithFIFO.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/RWbuf.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/lpp_usb.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_burst.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_genvalid.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_selectaddress.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_dma_send_Nword.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo_arbiter.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_fifo_ctrl.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_pkg.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_snapshot_controler.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_waveform/lpp_waveform_valid_ack.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/MinF_Cntr.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Rocket_PCM_Encoder.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver_Multiplexor.vhd ../../../../../../../grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Word_Cntr.vhd}
{work  ../../../../config.vhd ../../../../ahbrom.vhd ../../../../leon3mp.vhd}
}
set verilogList {
}
