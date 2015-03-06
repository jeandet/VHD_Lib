#vsim -c -do "run_nowindow.do" -goutput_file_name="output_data.txt" -ginput_file_name="input_data.txt"

quietly set args [ split $argv {\ } ]
set argc [ llength $args ]

set outputfile_f0 "output\_data\_f0\.txt"
set inputfile_f0  "input\_data\_f0\.txt"
set outputfile_f1 "output\_data\_f1\.txt"
set inputfile_f1  "input\_data\_f1\.txt"
set outputfile_f2 "output\_data\_f2\.txt"
set inputfile_f2  "input\_data\_f2\.txt"

#puts "there are $argc arguments to this script"
#puts "The name of this script is $argv0"

#foreach arg $::argv {puts $arg} 

#puts [ lindex $args 4 ]

for { set i 0 } { $i < $argc } { incr i 1 } {
    puts "$i : [ lindex $args $i ]"

    if { [ string match -goutput_file_name_f0=* [ lindex $args $i ] ] } { 
       set outputfile_f0 [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       puts "OUTPUT_FILE_f0 : $outputfile_f0"
    }
    if { [ string match -goutput_file_name_f1=* [ lindex $args $i ] ] } { 
       set outputfile_f1 [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       puts "OUTPUT_FILE_f1 : $outputfile_f1"
    }
    if { [ string match -goutput_file_name_f2=* [ lindex $args $i ] ] } { 
       set outputfile_f2 [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       puts "OUTPUT_FILE_f2 : $outputfile_f2"
    }

    if { [ string match -ginput_file_name_f0=* [ lindex $args $i ] ] } { 
       set inputfile_f0 [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       puts "INPUT_FILE_F0 : $inputfile_f0"
    }
    if { [ string match -ginput_file_name_f1=* [ lindex $args $i ] ] } { 
       set inputfile_f1 [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       puts "INPUT_FILE_F1 : $inputfile_f1"
    }
    if { [ string match -ginput_file_name_f2=* [ lindex $args $i ] ] } { 
       set inputfile_f2 [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       puts "INPUT_FILE_F2 : $inputfile_f2"
    }
}

vsim work.testbench \
-goutput_file_name_f0=$outputfile_f0 -ginput_file_name_f0=$inputfile_f0  \
-goutput_file_name_f1=$outputfile_f1 -ginput_file_name_f1=$inputfile_f1  \
-goutput_file_name_f2=$outputfile_f2 -ginput_file_name_f2=$inputfile_f2 
when -label end_of_simulation {end_of_sim == '1'} {echo "End of simulation"; exit ;}

run -all
exit
