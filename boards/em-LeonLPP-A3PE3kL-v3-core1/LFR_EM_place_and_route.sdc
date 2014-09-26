# Top Level Design Parameters

# Clocks

create_clock -period 10.000000 -waveform {0.000000 5.000000}  clk100MHz
create_clock -period 20.344999 -waveform {0.000000 10.172500} clk49_152MHz
create_clock -period 20.000000 -waveform {0.000000 10.000000} clk_50_s:Q
create_clock -period 40.000000 -waveform {0.000000 20.000000} clk_25:Q
create_clock -period 40.690000 -waveform {0.000000 20.345100} clk_24:Q
create_clock -name SPW_CLOCK -period 100.000000 -waveform {0.000000 50.000000} {SPW1_DIN SPW1_SIN SPW2_DIN SPW2_SIN}


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
