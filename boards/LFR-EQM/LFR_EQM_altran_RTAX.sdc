################################################################################
#  SDC WRITER VERSION "3.1";
#  DESIGN "LFR_EQM";
#  Timing constraints scenario: "Primary";
#  DATE "Thu Jun 04 11:49:44 2015";
#  VENDOR "Actel";
#  PROGRAM "Actel Designer Software Release v9.1 SP5";
#  VERSION "9.1.5.1"  Copyright (C) 1989-2012 Actel Corp. 
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name { clk50MHz } -period 20.000 -waveform { 0.000 10.000  }  { clk50MHz  } 

create_clock  -name { clk49_152MHz } -period 20.345 -waveform { 0.000 10.172  }  { clk49_152MHz  } 

create_clock  -name { clk_25:Q } -period 40.000 -waveform { 0.000 20.000  }  { clk_25:Q  } 

create_clock  -name { clk_24:Q } -period 40.690 -waveform { 0.000 20.345  }  { clk_24:Q  } 

create_clock  -name { spw_inputloop.1.spw_phy0/rxclki_1_0:Y } -period 100.000 -waveform { 0.000 50.000  }  { spw_inputloop.1.spw_phy0/rxclki_1_0:Y  } 

create_clock  -name { spw_inputloop.0.spw_phy0/rxclki_1_0:Y } -period 100.000 -waveform { 0.000 50.000  }  { spw_inputloop.0.spw_phy0/rxclki_1_0:Y  } 


########  Generated Clock Constraints  ########



########  Clock Source Latency Constraints #########



########  Input Delay Constraints  ########

set_input_delay  -max 35.000 -clock { clk_25:Q }  [get_ports { data[0] data[10] data[11] data[12] data[13] data[14] data[15] data[16] data[17] data[18] data[19] data[1] data[20] data[21] data[22] data[23] data[24] data[25] data[26] data[27] data[28] data[29] data[2] data[30] data[31] data[3] data[4] data[5] data[6] data[7] data[8] data[9] }] 

set_input_delay  -max 35.000 -clock { clk_25:Q }  [get_ports { ADC_data }] 



########  Output Delay Constraints  ########

set_max_delay 30.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { data[0] data[10] data[11] \
data[12] data[13] data[14] data[15] data[16] data[17] data[18] data[19] data[1] data[20] \
data[21] data[22] data[23] data[24] data[25] data[26] data[27] data[28] data[29] data[2] \
data[30] data[31] data[3] data[4] data[5] data[6] data[7] data[8] data[9] }] 

set_max_delay 10.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { address[0] address[10] \
address[11] address[12] address[13] address[14] address[15] address[16] address[17] \
address[18] address[1] address[2] address[3] address[4] address[5] address[6] \
address[7] address[8] address[9] }] 

set_max_delay 10.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { nSRAM_E1 nSRAM_E2 nSRAM_W nSRAM_G nSRAM_MBE}] 
 
set_max_delay 10.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { ADC_OEB_bar_CH ADC_OEB_bar_HK }] 

set_max_delay 10.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { DAC_SCK DAC_SDO DAC_SYNC }] 


########   Delay Constraints  ########

set_max_delay 4.000 -from [get_ports { spw2_sin spw2_din spw1_sin spw1_din reset }]  -to \
[get_clocks {spw_inputloop.0.spw_phy0/rxclki_1_0:Y}] 

set_max_delay 4.000 -from [get_ports { spw2_sin spw2_din spw1_sin spw1_din reset }]  -to \
[get_clocks {spw_inputloop.1.spw_phy0/rxclki_1_0:Y}] 


########   Delay Constraints  ########



########   Multicycle Constraints  ########



########   False Path Constraints  ########



########   Output load Constraints  ########



########  Disable Timing Constraints #########



########  Clock Uncertainty Constraints #########



