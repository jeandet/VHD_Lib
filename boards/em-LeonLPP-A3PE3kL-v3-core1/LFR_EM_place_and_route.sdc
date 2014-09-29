# Top Level Design Parameters

# Clocks

create_clock -period 10.000000 -waveform {0.000000 5.000000}  clk100MHz
create_clock -period 20.344999 -waveform {0.000000 10.172500} clk49_152MHz
create_clock -period 20.000000 -waveform {0.000000 10.000000} clk_50_s:Q
create_clock -period 40.000000 -waveform {0.000000 20.000000} clk_25:Q
create_clock -period 40.690000 -waveform {0.000000 20.345100} clk_24:Q
create_clock -name SPW_CLOCK -period 100.000000 -waveform {0.000000 50.000000} {spw1_din spw1_sin spw2_din spw2_sin}


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
