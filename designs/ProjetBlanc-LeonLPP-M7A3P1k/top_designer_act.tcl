new_design -name "top" -family "PROASIC3" 
set_device -die "PROASIC3" -package "484 FBGA" -speed "Std" -voltage "1.5" -iostd "LVTTL" -jtag "yes" -probe "yes" -trst "yes" -temprange "COM" -voltrange "COM" 
if {[file exist top.pdc]} {
import_source -format "edif" -edif_flavor "GENERIC"  -merge_physical "no" -merge_timing "no" {synplify/top.edf} -format "pdc" -abort_on_error "no" {top.pdc}
} else {
import_source -format "edif" -edif_flavor "GENERIC"  -merge_physical "no" -merge_timing "no" {synplify/top.edf}
}
save_design {top.adb}
