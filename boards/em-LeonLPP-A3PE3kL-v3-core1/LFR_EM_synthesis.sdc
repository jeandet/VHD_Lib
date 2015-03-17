# Synplicity, Inc. constraint file
# /home/jiri/ibm/vhdl/grlib/boards/actel-coremp7-1000/default.sdc
# Written on Wed Aug  1 19:29:24 2007
# by Synplify Pro, Synplify Pro 8.8.0.4 Scope Editor

#
# Collections
#

#
# Clocks
#

define_clock  -name {clk100MHz}    -freq 100    -clockgroup default_clkgroup_50 -route 5
define_clock  -name {clk49_152MHz} -freq 49.152 -clockgroup default_clkgroup_49 -route 5

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
# Multicycle Path
#

#
# False Path
#

set_false_path -from reset

#
# Path Delay
#

#
# Attributes
#

define_global_attribute          syn_useioff {1}
define_global_attribute -disable syn_netlist_hierarchy {0}

#
# I/O standards
#

#
# Compile Points
#

#
# Other Constraints
#
