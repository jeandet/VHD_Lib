# Top Level Design Parameters

# Clocks

create_clock -period 10.000000 -waveform {0.000000 5.000000}  clk_50
create_clock -period 20.344999 -waveform {0.000000 10.172500} clk_49
create_clock -period 20.000000 -waveform {0.000000 10.000000} clk_50_s:Q
create_clock -period 40.000000 -waveform {0.000000 20.000000} clk_25:Q
create_clock -period 40.690000 -waveform {0.000000 20.345100} clk_24:Q
create_clock -name SPW_CLOCK -period 100.000000 -waveform {0.000000 50.000000} {SPW_NOM_DIN SPW_NOM_SIN SPW_RED_DIN SPW_RED_SIN}


# False Paths Between Clocks


# False Path Constraints


# Maximum Delay Constraints


# Multicycle Constraints


# Virtual Clocks
# Output Load Constraints
# Driving Cell Constraints
# Wire Loads
# set_wire_load_mode top

# Other Constraints

set_max_delay 4.000 -from [get_ports { SPW_NOM_DIN SPW_NOM_SIN SPW_RED_DIN SPW_RED_SIN reset }]  -to [get_clocks {spw_inputloop.0.spw_phy0/rxclki_RNO:Y}] 

set_max_delay 4.000 -from [get_ports { SPW_NOM_DIN SPW_NOM_SIN SPW_RED_DIN SPW_RED_SIN reset }]  -to [get_clocks {spw_inputloop.1.spw_phy0/rxclki_RNO:Y}] 
