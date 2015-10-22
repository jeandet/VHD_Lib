################################################################################
#  SDC WRITER VERSION "3.1";
#  DESIGN "LFR_EQM";
#  Timing constraints scenario: "Primary";
#  DATE "Fri Apr 24 16:02:16 2015";
#  VENDOR "Actel";
#  PROGRAM "Actel Designer Software Release v9.1 SP5";
#  VERSION "9.1.5.1"  Copyright (C) 1989-2012 Actel Corp.
################################################################################


set sdc_version 1.7


########  Clock Constraints  ########

create_clock  -name { clk100MHz } -period 10.000 -waveform { 0.000 5.000  }  { clk100MHz  }

create_clock  -name { clk49_152MHz } -period 20.345 -waveform { 0.000 10.172  }  { clk49_152MHz  }

create_clock  -name { clk_25:Q } -period 40.000 -waveform { 0.000 20.000  }  { clk_25:Q  }

create_clock  -name { clk_24:Q } -period 40.690 -waveform { 0.000 20.345  }  { clk_24:Q  }

create_clock  -name { spw_inputloop.1.spw_phy0/rxclki_RNO:Y } -period 100.000 -waveform { 0.000 50.000  }  { spw_inputloop.1.spw_phy0/rxclki_RNO:Y  }

create_clock  -name { spw_inputloop.0.spw_phy0/rxclki_RNO:Y } -period 100.000 -waveform { 0.000 50.000  }  { spw_inputloop.0.spw_phy0/rxclki_RNO:Y  }



########  Generated Clock Constraints  ########



########  Clock Source Latency Constraints #########



########  Input Delay Constraints  ########

set_input_delay 0.000 -clock { clk_25:Q }  [get_ports { SRAM_DQ[0] SRAM_DQ[10] SRAM_DQ[11] SRAM_DQ[12] SRAM_DQ[13] SRAM_DQ[14] SRAM_DQ[15] SRAM_DQ[16] SRAM_DQ[17] SRAM_DQ[18] SRAM_DQ[19] SRAM_DQ[1] SRAM_DQ[20] SRAM_DQ[21] SRAM_DQ[22] SRAM_DQ[23] SRAM_DQ[24] SRAM_DQ[25] SRAM_DQ[26] SRAM_DQ[27] SRAM_DQ[28] SRAM_DQ[29] SRAM_DQ[2] SRAM_DQ[30] SRAM_DQ[31] SRAM_DQ[3] SRAM_DQ[4] SRAM_DQ[5] SRAM_DQ[6] SRAM_DQ[7] SRAM_DQ[8] SRAM_DQ[9] }]
set_max_delay 30.000 -from [get_ports { SRAM_DQ[0] SRAM_DQ[10] SRAM_DQ[11] SRAM_DQ[12] SRAM_DQ[13] SRAM_DQ[14] \
data[15] SRAM_DQ[16] SRAM_DQ[17] SRAM_DQ[18] SRAM_DQ[19] SRAM_DQ[1] SRAM_DQ[20] SRAM_DQ[21] SRAM_DQ[22] SRAM_DQ[23] \
data[24] SRAM_DQ[25] SRAM_DQ[26] SRAM_DQ[27] SRAM_DQ[28] SRAM_DQ[29] SRAM_DQ[2] SRAM_DQ[30] SRAM_DQ[31] SRAM_DQ[3] \
data[4] SRAM_DQ[5] SRAM_DQ[6] SRAM_DQ[7] SRAM_DQ[8] SRAM_DQ[9] }]  -to [get_clocks {clk_25:Q}]
set_min_delay 0.000 -from [get_ports { SRAM_DQ[0] SRAM_DQ[10] SRAM_DQ[11] SRAM_DQ[12] SRAM_DQ[13] SRAM_DQ[14] \
data[15] SRAM_DQ[16] SRAM_DQ[17] SRAM_DQ[18] SRAM_DQ[19] SRAM_DQ[1] SRAM_DQ[20] SRAM_DQ[21] SRAM_DQ[22] SRAM_DQ[23] \
data[24] SRAM_DQ[25] SRAM_DQ[26] SRAM_DQ[27] SRAM_DQ[28] SRAM_DQ[29] SRAM_DQ[2] SRAM_DQ[30] SRAM_DQ[31] SRAM_DQ[3] \
data[4] SRAM_DQ[5] SRAM_DQ[6] SRAM_DQ[7] SRAM_DQ[8] SRAM_DQ[9] }]  -to [get_clocks {clk_25:Q}]

#set_input_delay 0.000 -clock { clk_25:Q }  [get_ports { nSRAM_BUSY }]
#set_max_delay 10.000 -from [get_ports { nSRAM_BUSY }]  -to [get_clocks {clk_25:Q}]
#set_min_delay 0.000 -from [get_ports { nSRAM_BUSY }]  -to [get_clocks {clk_25:Q}]



########  Output Delay Constraints  ########

set_output_delay 0.000 -clock { clk_25:Q }  [get_ports { SRAM_DQ[0] SRAM_DQ[10] SRAM_DQ[11] SRAM_DQ[12] SRAM_DQ[13] SRAM_DQ[14] SRAM_DQ[15] SRAM_DQ[16] SRAM_DQ[17] SRAM_DQ[18] SRAM_DQ[19] SRAM_DQ[1] SRAM_DQ[20] SRAM_DQ[21] SRAM_DQ[22] SRAM_DQ[23] SRAM_DQ[24] SRAM_DQ[25] SRAM_DQ[26] SRAM_DQ[27] SRAM_DQ[28] SRAM_DQ[29] SRAM_DQ[2] SRAM_DQ[30] SRAM_DQ[31] SRAM_DQ[3] SRAM_DQ[4] SRAM_DQ[5] SRAM_DQ[6] SRAM_DQ[7] SRAM_DQ[8] SRAM_DQ[9] }]
set_max_delay 18.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { SRAM_DQ[0] SRAM_DQ[10] SRAM_DQ[11] \
data[12] SRAM_DQ[13] SRAM_DQ[14] SRAM_DQ[15] SRAM_DQ[16] SRAM_DQ[17] SRAM_DQ[18] SRAM_DQ[19] SRAM_DQ[1] SRAM_DQ[20] \
data[21] SRAM_DQ[22] SRAM_DQ[23] SRAM_DQ[24] SRAM_DQ[25] SRAM_DQ[26] SRAM_DQ[27] SRAM_DQ[28] SRAM_DQ[29] SRAM_DQ[2] \
data[30] SRAM_DQ[31] SRAM_DQ[3] SRAM_DQ[4] SRAM_DQ[5] SRAM_DQ[6] SRAM_DQ[7] SRAM_DQ[8] SRAM_DQ[9] }]
set_min_delay 0.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { SRAM_DQ[0] SRAM_DQ[10] SRAM_DQ[11] \
data[12] SRAM_DQ[13] SRAM_DQ[14] SRAM_DQ[15] SRAM_DQ[16] SRAM_DQ[17] SRAM_DQ[18] SRAM_DQ[19] SRAM_DQ[1] SRAM_DQ[20] \
data[21] SRAM_DQ[22] SRAM_DQ[23] SRAM_DQ[24] SRAM_DQ[25] SRAM_DQ[26] SRAM_DQ[27] SRAM_DQ[28] SRAM_DQ[29] SRAM_DQ[2] \
data[30] SRAM_DQ[31] SRAM_DQ[3] SRAM_DQ[4] SRAM_DQ[5] SRAM_DQ[6] SRAM_DQ[7] SRAM_DQ[8] SRAM_DQ[9] }]

set_output_delay 0.000 -clock { clk_25:Q }  [get_ports { SRAM_A[0] SRAM_A[10] SRAM_A[11] SRAM_A[12] SRAM_A[13] SRAM_A[14] SRAM_A[15] SRAM_A[16] SRAM_A[17] SRAM_A[18] SRAM_A[19] SRAM_A[1] SRAM_A[2] SRAM_A[3] SRAM_A[4] SRAM_A[5] SRAM_A[6] SRAM_A[7] SRAM_A[8] SRAM_A[9] }]
set_max_delay 20.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { SRAM_A[0] SRAM_A[10] \
address[11] SRAM_A[12] SRAM_A[13] SRAM_A[14] SRAM_A[15] SRAM_A[16] SRAM_A[17] \
address[18] SRAM_A[19] SRAM_A[1] SRAM_A[2] SRAM_A[3] SRAM_A[4] SRAM_A[5] SRAM_A[6] \
address[7] SRAM_A[8] SRAM_A[9] }]
set_min_delay 0.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { SRAM_A[0] SRAM_A[10] \
address[11] SRAM_A[12] SRAM_A[13] SRAM_A[14] SRAM_A[15] SRAM_A[16] SRAM_A[17] \
address[18] SRAM_A[19] SRAM_A[1] SRAM_A[2] SRAM_A[3] SRAM_A[4] SRAM_A[5] SRAM_A[6] \
address[7] SRAM_A[8] SRAM_A[9] }]

set_output_delay 0.000 -clock { clk_25:Q }  [get_ports { nSRAM_BE[0] nSRAM_BE[1] nSRAM_BE[2] nSRAM_BE[3] nSRAM_WE nSRAM_CE nSRAM_OE }]
set_max_delay 20.000 -from [get_clocks {clk_25:Q}]  -to [get_ports { nSRAM_BE[0] nSRAM_BE[1] nSRAM_BE[2] nSRAM_BE[3] nSRAM_WE nSRAM_CE nSRAM_OE }]
set_min_delay 0.000  -from [get_clocks {clk_25:Q}]  -to [get_ports { nSRAM_BE[0] nSRAM_BE[1] nSRAM_BE[2] nSRAM_BE[3] nSRAM_WE nSRAM_CE nSRAM_OE }]


########   Delay Constraints  ########

set_max_delay 4.000 -from [get_ports { SPW_RED_SIN SPW_RED_DIN SPW_NOM_SIN SPW_NOM_DIN reset }]  -to [get_clocks { spw_inputloop.1.spw_phy0/ntstrxclk.rx_clkbuf/pa3e.pae30/buf1.buf_RNO:Y}]

set_max_delay 4.000 -from [get_ports { SPW_RED_SIN SPW_RED_DIN SPW_NOM_SIN SPW_NOM_DIN reset }]  -to [get_clocks {spw_inputloop.0.spw_phy0/ntstrxclk.rx_clkbuf/pa3e.pae30/buf1.buf_RNO:Y}]


########   Delay Constraints  ########



########   Multicycle Constraints  ########



########   False Path Constraints  ########



########   Output load Constraints  ########



########  Disable Timing Constraints #########



########  Clock Uncertainty Constraints #########



