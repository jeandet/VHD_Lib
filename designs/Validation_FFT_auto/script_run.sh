#!/bin/sh

for FILE_NAME in "$@"
do
    vsim -c -do "run_nowindow.do" -goutput_file_name=$FILE_NAME".FFT_output" -ginput_file_name=$FILE_NAME
done




