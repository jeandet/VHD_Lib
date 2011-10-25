new_design -name "leon3mp" -family "PROASIC3" 
set_device -die "PROASIC3" -package "484 FBGA" -speed "Std" -voltage "1.5" -iostd "LVTTL" -jtag "yes" -probe "yes" -trst "yes" -temprange "COM" -voltrange "COM" 
if {[file exist leon3mp.pdc]} {
import_source -format "edif" -edif_flavor "GENERIC"  -merge_physical "no" -merge_timing "no" {synplify/leon3mp.edf} -format "pdc" -abort_on_error "no" {leon3mp.pdc}
} else {
import_source -format "edif" -edif_flavor "GENERIC"  -merge_physical "no" -merge_timing "no" {synplify/leon3mp.edf}
}
compile -combine_register 1
if {[file exist ../../boards/Projet-Blanc-LPP-M7A3P1000/Projet-Blanc-LPP-M7A3P1000.pdc]} {
   import_aux -format "pdc" -abort_on_error "no" {../../boards/Projet-Blanc-LPP-M7A3P1000/Projet-Blanc-LPP-M7A3P1000.pdc}
   pin_commit
} else {
   puts "WARNING: No PDC file imported."
}
if {[file exist ../../boards/Projet-Blanc-LPP-M7A3P1000/leon3mp.sdc]} {
   import_aux -format "sdc" -merge_timing "no" {../../boards/Projet-Blanc-LPP-M7A3P1000/leon3mp.sdc}
} else {
   puts "WARNING: No SDC file imported."
}
save_design {leon3mp.adb}
report -type status {./actel/report_status_pre.log}
layout -timing_driven -incremental "OFF"
save_design {leon3mp.adb}
backannotate -dir {./actel} -name "leon3mp" -format "SDF" -language "VHDL93" -netlist
report -type "timer" -analysis "max" -print_summary "yes" -use_slack_threshold "no" -print_paths "yes" -max_paths 100 -max_expanded_paths 5 -include_user_sets "yes" -include_pin_to_pin "yes" -select_clock_domains "no"  {./actel/report_timer_max.txt}
report -type "timer" -analysis "min" -print_summary "yes" -use_slack_threshold "no" -print_paths "yes" -max_paths 100 -max_expanded_paths 5 -include_user_sets "yes" -include_pin_to_pin "yes" -select_clock_domains "no"  {./actel/report_timer_min.txt}
report -type "pin" -listby "name" {./actel/report_pin_name.log}
report -type "pin" -listby "number" {./actel/report_pin_number.log}
report -type "datasheet" {./actel/report_datasheet.txt}
export -format "pdb" -feature "prog_fpga" -io_state "Tri-State" {./actel/leon3mp.pdb}
export -format log -diagnostic {./actel/report_log.log}
report -type status {./actel/report_status_post.log}
save_design {leon3mp.adb}
