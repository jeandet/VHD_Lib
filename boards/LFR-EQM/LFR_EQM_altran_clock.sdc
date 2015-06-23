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



