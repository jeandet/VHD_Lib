#vsim -c -do "run_nowindow.do" -goutput_file_name="output_data.txt" -ginput_file_name="input_data.txt"

quietly set args [ split $argv {\ } ]
set argc [ llength $args ]

set outputfile "output\_data\.txt"
set inputfile  "input\_data\.txt"

#puts "there are $argc arguments to this script"
#puts "The name of this script is $argv0"

#foreach arg $::argv {puts $arg} 

#puts [ lindex $args 4 ]

for { set i 0 } { $i < $argc } { incr i 1 } {
    puts "$i : [ lindex $args $i ]"
    if { [ string match -goutput_file_name=* [ lindex $args $i ] ] } { 
       set outputfile [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       #set outputfile [ lindex [ split $argv {=} ] 1 ]
       puts "OUTPUT_FILE : $outputfile"
    }
    if { [ string match -ginput_file_name=* [ lindex $args $i ] ] } { 
       set inputfile [ lindex [ split [ lindex $args $i ] {=} ] 1 ]
       #set inputfile [ lindex [ split $argv {=} ] 1 ]
       puts "INPUT_FILE : $inputfile"
    }
}

vsim work.testbench -goutput_file_name=$outputfile -ginput_file_name=$inputfile 
when -label end_of_simulation {end_of_sim == '1'} {echo "End of simulation"; exit ;}
run -all
exit
