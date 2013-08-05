

#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/CoreFFT.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Driver_FFT.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/Linker_FFT.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/actar.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/actram.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/fftDp.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/fftSm.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/fft_components.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/lpp_fft.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/primitives.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/twiddle.vhd
#	vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./dsp/lpp_fft/FFT.vhd
 
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ALU_Driver.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Dispatch.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/DriveInputs.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/GetResult.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Matrix.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/SpectralMatrix.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/Starter.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/TopSpecMatrix.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/MatriceSpectrale.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/ReUse_CTRLR.vhd
#        vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_matrix/lpp_matrix.vhd

    vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_Header/HeaderBuilder.vhd

vcom -quiet  -93  -work lpp ../../lib/../../VHD_Lib/lib/lpp/./lpp_ad_Conv/TestModule_ADS7886.vhd
vcom -quiet  -93  -work work TestBench.vhd

vsim work.testbench