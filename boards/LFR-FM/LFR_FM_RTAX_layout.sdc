################################################################################
#  SDC WRITER VERSION "3.1";
#  DESIGN "LFR_EQM";
#  Timing constraints scenario: "Primary";
#  DATE "Fri Jul 24 14:50:40 2015";
#  VENDOR "Actel";
#  PROGRAM "Actel Designer Software Release v9.1 SP5";
#  VERSION "9.1.5.1"  Copyright (C) 1989-2012 Actel Corp. 
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name { clk50MHz } -period 20.000 -waveform { 0.000 10.000  }  { clk50MHz  } 

create_clock  -name { clk49_152MHz } -period 20.345 -waveform { 0.000 10.172  }  { clk49_152MHz  } 

create_clock  -name { clk_25:Q } -period 40.000 -waveform { 0.000 20.000  }  { clk_pad_25/U0:Y  } 

create_clock  -name { clk_24:Q } -period 40.690 -waveform { 0.000 20.345  }  { clk_24:Q  } 

create_clock  -name { spw_inputloop.1.spw_phy0/rxclki_1_0:Y } -period 100.000 -waveform { 0.000 50.000  }  { spw_inputloop.1.spw_phy0/rxclki_1:Y  } 

create_clock  -name { spw_inputloop.0.spw_phy0/rxclki_1_0:Y } -period 100.000 -waveform { 0.000 50.000  }  { spw_inputloop.0.spw_phy0/rxclki_1:Y  } 



########  Generated Clock Constraints  ########



########  Clock Source Latency Constraints #########



########  Input Delay Constraints  ########



########  Output Delay Constraints  ########
set_max_delay 10.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { address }] 

set_min_delay 10.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { nSRAM_E1 nSRAM_E2 }] 



########   Delay Constraints  ########



########   Delay Constraints  ########



########   Multicycle Constraints  ########



########   False Path Constraints  ########



########   Output load Constraints  ########



########  Disable Timing Constraints #########



########  Clock Uncertainty Constraints #########



