# Synopsys, Inc. constraint file
# E:/opt/tortoiseHG_vhdlib/designs/LFR-EQM-TEST/LFR-EQM-WFP_MS-RTAX_5/../../../boards/LFR-EQM/LFR_EQM_altran_syn_fanout.sdc
# Written on Fri Jun 26 12:55:35 2015
# by Synplify Pro, E-2010.09A-1 Scope Editor

#
# Collections
#

#
# Clocks
#
define_clock   {clk50MHz} -name {clk50MHz}  -freq 50 -clockgroup default_clkgroup_0
define_clock   {n:clk_25} -name {n:clk_25}  -freq 25 -clockgroup default_clkgroup_1
define_clock   {n:clk_24} -name {n:clk_24}  -freq 24.576 -clockgroup default_clkgroup_2
define_clock   {n:spw_inputloop\.0\.spw_phy0.rxclki_1} -name {n:spw_inputloop\.0\.spw_phy0.rxclki_1}  -freq 10 -clockgroup default_clkgroup_3
define_clock   {n:spw_inputloop\.1\.spw_phy0.rxclki_1} -name {n:spw_inputloop\.1\.spw_phy0.rxclki_1}  -freq 10 -clockgroup default_clkgroup_4
define_clock   {clk49_152MHz} -name {clk49_152MHz}  -freq 49.152 -clockgroup default_clkgroup_5

#
# Clock to Clock
#

#
# Inputs/Outputs
#

#
# Registers
#

#
# Delay Paths
#

#
# Attributes
#
define_global_attribute  {syn_useioff} {1}
define_attribute {n:leon3_soc_1\.l3\.cpu.0.leon3_radhard_i.cpu.holdn} {syn_maxfan} {10000}
define_attribute {n:spw_inputloop\.0\.spw_phy0.rxclki_1} {syn_maxfan} {10000}
define_attribute {n:spw_inputloop\.1\.spw_phy0.rxclki_1} {syn_maxfan} {10000}
define_attribute {n:leon3_soc_1\.l3\.cpu.0.leon3_radhard_i.cpu} {syn_hier} {flatten}
define_global_attribute -disable  {syn_netlist_hierarchy} {1}

#
# I/O Standards
#

#
# Compile Points
#

#
# Other
#
