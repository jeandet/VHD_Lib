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
{grlib  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/version.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/config.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/stdlib/stdlib.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/sparc/sparc.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/sparc/sparc_disas.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/sparc/cpu_disas.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/modgen/multlib.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/modgen/leaves.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/amba.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/devices.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/defmst.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/apbctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/ahbctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb_pkg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/grlib/amba/dma2ahb.vhd}
{techmap  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/gencomp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/gencomp/netcomp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/memory_inferred.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_inferred.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/mul_inferred.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/inferred/ddr_phy_inferred.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/dware/mul_dware.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allclkgen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allddr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmem.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allmul.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/allpads.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/alltap.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkgen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkmux.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkand.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_ireg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddr_oreg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ddrphy.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram64.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_2p.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram_dp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncfifo.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/regfile_3p.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/tap.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/techbuf.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/nandtree.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/clkpad_ds.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ds.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iodpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ds.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/lvds_combo.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/odpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ds.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/toutpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/skew_outpad.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grspwc2_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grlfpw_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grfpw_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/leon4_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/mul_61x61.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/cpu_disas_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grusbhc_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ringosc.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/ssrctrl_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/system_monitor.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/grgates.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/inpad_ddr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/outpad_ddr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/iopad_ddr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128bw.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram128.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/syncram156bw.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/techmult.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/spictrl_net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/techmap/maps/scanreg.vhd}
{spw  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/comp/spwcomp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw_gen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/spw/wrapper/grspw2_gen.vhd}
{eth  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/comp/ethcomp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_pkg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_rstgen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_edcl_ahb_mst.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/eth_ahb_mst.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_tx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/greth_rx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/core/grethc.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/eth/wrapper/greth_gbit_gen.vhd}
{opencores  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/occomp/occomp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/can/cancomp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/opencores/can/can_top.vhd}
{gaisler  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/arith.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/mul32.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/arith/div32.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/memctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdctrl64.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/sdmctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/srctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/memctrl/spimctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuconfig.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmuiface.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libmmu.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libiu.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libcache.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/libproc3.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cachemem.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_icache.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_dcache.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_acache.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlbcam.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulrue.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmulru.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutlb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmutw.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mmu_cache.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/cpu_disasx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/iu3.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/mfpwx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grlfpwx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/tbufmem.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3x.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/dsu3.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/proc3.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3s.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3cg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/irqmp.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpwxsh.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/grfpushwx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3/leon3sh.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/leon3ft/leon3ft.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mod.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_oc.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_mc.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/canmux.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/can/can_rd.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/misc.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/rstgen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gptimer.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbram.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbdpram.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbtrace_mmb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpio.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbstat.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/logan.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbps2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom_package.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/charrom.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/apbvga.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/svgactrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cmst_gen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrlx.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/spictrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/i2cslv.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/wild2ahb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grsysmon.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/gracectrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/grgpreg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahbmst2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/misc/ahb_mst_iface.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/net/net.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/uart.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/libdcom.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/apbuart.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/dcom_uart.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/uart/ahbuart.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtag.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/libjtagcom.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/jtagcom.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/ahbjtag_bsd.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregs.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/jtag/bscanregsbd.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/ethernet_mac.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_mb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/greth_gbit_mb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/greth/grethm.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/spacewire.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspw2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/spacewire/grspwm.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/gaisler/gr1553b/gr1553b_pkg.vhd}
{esa  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/memoryctrl.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/esa/memoryctrl/mctrl.vhd}
{lpp  ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/FRAME_CLK.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_CFG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_DRVR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_ENGINE.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_2x16_DRIVER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_CLK_GENERATOR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/Top_LCD.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/amba_lcd_16x2_ctrlr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./amba_lcd_16x2_ctrlr/apb_lcd_ctrlr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/APB_IIR_CEL.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/FILTER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/FILTER_RAM_CTRLR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/FILTERcfg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/FilterCTRLR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/IIR_CEL_FILTER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/RAM.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/RAM_CTRLR2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/Top_Filtre_IIR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/iir_filter/iir_filter.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/lpp_fft/APB_FFT.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/ADDRcntr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/ALU.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/Adder.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/Clk_divider.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/MAC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/MAC_CONTROLER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/MAC_MUX.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/MAC_MUX2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/MAC_REG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/MUX2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/Multiplier.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/REG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/Shifter.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./general_purpose/general_purpose.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_ad_Conv/AD7688_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_ad_Conv/AD7688_spi_if.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_ad_Conv/ADS7886_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_ad_Conv/lpp_apb_ad_conv.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_amba/APB_MULTI_DIODE.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_amba/APB_SIMPLE_DIODE.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_amba/apb_devices_list.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_amba/lpp_amba.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/APB_CNA.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/CNA_TabloC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/Convertisseur_config.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/Gene_SYNC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/Serialize.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/Systeme_Clock.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_cna/lpp_cna.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/APB_FIFO.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/APB_FifoRead.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/APB_FifoWrite.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/ApbDriver.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/Fifo_Read.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/Fifo_Write.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/Link_Reg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/Top_FIFO.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/Top_FifoRead.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/Top_FifoWrite.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_memory/lpp_memory.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_uart/APB_UART.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_uart/BaudGen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_uart/Shift_REG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_uart/UART.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/lpp/./lpp_uart/lpp_uart.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/FRAME_CLK.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_CFG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_DRVR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_16x2_ENGINE.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_2x16_DRIVER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/LCD_CLK_GENERATOR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/Top_LCD.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/amba_lcd_16x2_ctrlr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./amba_lcd_16x2_ctrlr/apb_lcd_ctrlr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_CEL.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/APB_IIR_Filter.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTER_RAM_CTRLR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FILTERcfg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/FilterCTRLR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/IIR_CEL_FILTER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CEL.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/RAM_CTRLR_v2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_Filtre_IIR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/Top_IIR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/iir_filter/iir_filter.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_downsampling/Downsampling.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/APB_FFT_half.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Driver_FFT.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTamont.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFTaval.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Flag_Extremum.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ADDRcntr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/ALU.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Adder.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_Divider2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Clk_divider.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_CONTROLER.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_MUX2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MAC_REG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUX2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/MUXN.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Multiplier.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/REG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/SYNC_FF.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/Shifter.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/general_purpose.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/APB_AMR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Clock_multi.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Dephaseur.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/Gene_Rz.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/bclk_reg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_AMR/lpp_AMR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/APB_Balise.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_balise/lpp_balise.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/APB_Delay.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/TimerDelay.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./general_purpose/lpp_delay/lpp_delay.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/AD7688_spi_if.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1274_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS1278_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/ADS7886_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/WriteGen_ADC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/dual_ADS1278_drvr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_ad_Conv.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/lpp_apb_ad_conv.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_MULTI_DIODE.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/APB_SIMPLE_DIODE.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/apb_devices_list.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_amba/lpp_amba.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/bootrom.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_bootloader/lpp_bootloader_pkg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/APB_CNA.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/CNA_TabloC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Convertisseur_config.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Gene_SYNC.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Serialize.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/Systeme_Clock.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_cna/lpp_cna.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/DEMUX.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/WatchFlag.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_demux/lpp_demux.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/fifo_latency_correction.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_apbreg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_fsm.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_ip.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_pkg.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_16word.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_dma/lpp_dma_send_1word.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_v2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/APB_Matrix.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Dispatch.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/DriveInputs.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/GetResult.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MAC_v2.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Matrix.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Starter.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopMatrix_PDR.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopSpecMatrix.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Top_MatrixSpec.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TwoComplementer.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_matrix/lpp_matrix.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/APB_FIFO.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/Bridge.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/SSRAM_plugin.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOx5.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lppFIFOxN.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_FIFO.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_memory/lpp_memory.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/APB_UART.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/BaudGen.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/Shift_REG.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/UART.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_uart/lpp_uart.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/APB_USB.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/RWbuf.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./lpp_usb/lpp_usb.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/MinF_Cntr.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Rocket_PCM_Encoder.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Serial_Driver_Multiplexor.vhd ../../../../C:/opt/grlib-gpl-1.1.0-b4108/lib/../../VHD_Lib/lib/lpp/./Rocket_PCM_Encoder/Word_Cntr.vhd}
{work  ../../../../config.vhd ../../../../ahbrom.vhd ../../../../leon3mp.vhd}
}
set verilogList {
}
