
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/general_purpose.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/SYNC_FF.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MUXN.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MUX2.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/REG.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MAC.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MAC_CONTROLER.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MAC_REG.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MAC_MUX.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MAC_MUX2.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/Shifter.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/MULTIPLIER.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/ADDER.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/ALU.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/general_purpose/ADDRcntr.vhd

vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/iir_filter.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/FILTERcfg.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/RAM_CEL.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/RAM_CTRLR2.vhd
#vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/IIR_CEL_CTRLR.vhd

vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/RAM_CTRLR_v2.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/IIR_CEL_CTRLR_v2_DATAFLOW.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/IIR_CEL_CTRLR_v2_CONTROL.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/dsp/iir_filter/IIR_CEL_CTRLR_v2.vhd

vcom -quiet -93 -work lpp ../../lib/lpp/lpp_memory/lpp_memory.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_memory/lpp_FIFO.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_memory/lppFIFOxN.vhd

vcom -quiet -93 -work lpp ../../lib/lpp/dsp/lpp_downsampling/Downsampling.vhd

vcom -quiet -93 -work lpp e:/opt/tortoiseHG_vhdlib/lib/lpp/lpp_top_lfr/lpp_top_lfr_pkg.vhd
vcom -quiet -93 -work lpp e:/opt/tortoiseHG_vhdlib/lib/lpp/lpp_top_lfr/lpp_top_acq.vhd

vcom -quiet -93 -work lpp ../../lib/lpp/lpp_ad_Conv/lpp_ad_conv.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_ad_Conv/ADS7886_drvr.vhd
vcom -quiet -93 -work lpp ../../lib/lpp/lpp_ad_Conv/TestModule_ADS7886.vhd

vcom -quiet -93 -work work Top_Data_Acquisition.vhd
vcom -quiet -93 -work work TB_Data_Acquisition.vhd

#vsim work.TB_Data_Acquisition

#log -r *
#do wave_data_acquisition.do
#run 5 ms