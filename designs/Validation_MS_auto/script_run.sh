#!/bin/sh

for FILE_NAME in "$@"
do
    vsim -c -do "run_nowindow.do" \
	-goutput_file_name_f0=$FILE_NAME"_f0_output.txt" -ginput_file_name_f0=$FILE_NAME"_f0.txt"  \
	-goutput_file_name_f1=$FILE_NAME"_f1_output.txt" -ginput_file_name_f1=$FILE_NAME"_f1.txt"  \
	-goutput_file_name_f2=$FILE_NAME"_f2_output.txt" -ginput_file_name_f2=$FILE_NAME"_f2.txt"

    PATH_FILE=`pwd`

    BASE_NAME_FILE=`basename ${FILE_NAME}_f0.txt`
    echo -e "input_0="$BASE_NAME_FILE  >  $FILE_NAME.conf
    BASE_NAME_FILE=`basename ${FILE_NAME}_f1.txt`
    echo -e "input_1="$BASE_NAME_FILE  >>  $FILE_NAME.conf
    BASE_NAME_FILE=`basename ${FILE_NAME}_f2.txt`
    echo -e "input_2="$BASE_NAME_FILE  >>  $FILE_NAME.conf

    BASE_NAME_FILE=`basename ${FILE_NAME}_f0_output.txt`
    echo -e "output_0="$BASE_NAME_FILE  >>  $FILE_NAME.conf
    BASE_NAME_FILE=`basename ${FILE_NAME}_f1_output.txt`
    echo -e "output_1="$BASE_NAME_FILE  >>  $FILE_NAME.conf
    BASE_NAME_FILE=`basename ${FILE_NAME}_f2_output.txt`
    echo -e "output_2="$BASE_NAME_FILE  >>  $FILE_NAME.conf
done




