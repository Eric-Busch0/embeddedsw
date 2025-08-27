# Usage:
#   xsct make_bsp.tcl -xsa <path/to/design.xsa> \
#        [-proc psu_cortexa53_0|psu_cortexr5_0|ps7_cortexa9_0] \
#        [-name <platform_name>] \
#        [-os standalone] \
#        [-ws ./ws]
#
# Examples:
#   xsct make_bsp.tcl -xsa ./hw/ps_only_zynqmp.xsa -proc psu_cortexa53_0 -name plat_a53
#   xsct make_bsp.tcl -xsa ./hw/ps_only_zynqmp.xsa -proc psu_cortexr5_0 -ws ./ws_r5
#   xsct make_bsp.tcl -xsa ./hw/zynq7_ps_only.xsa   -proc ps7_cortexa9_0

# ---------- defaults ----------
set XSA   ""
set PROC  "psu_cortexa53_0"     ;# ZynqMP A53 default. Use psu_cortexr5_0 for R5, ps7_cortexa9_0 for Zynq-7000.
set OS    "standalone"
set WS    "./ws"
set NAME  ""

proc usage {} {
  puts "Usage: xsct make_bsp.tcl -xsa <file.xsa> [-proc <proc>] [-name <plat>] [-os <os>] [-ws <dir>]"
  exit 1
}

# ---------- parse args ----------
set argcnt [llength $argv]
for {set i 0} {$i < $argcnt} {incr i} {
  set a [lindex $argv $i]
  switch -- $a {
    -xsa  { incr i; set XSA  [lindex $argv $i] }
    -proc { incr i; set PROC [lindex $argv $i] }
    -name { incr i; set NAME [lindex $argv $i] }
    -os   { incr i; set OS   [lindex $argv $i] }
    -ws   { incr i; set WS   [lindex $argv $i] }
    default {
      puts "Unknown arg: $a"
      usage
    }
  }
}

if {$XSA eq ""} { puts "ERROR: -xsa is required"; usage }
if {![file exists $XSA]} { puts "ERROR: XSA not found: $XSA"; exit 1 }

# Default platform name from XSA basename (no extension)
if {$NAME eq ""} {
  set NAME [file rootname [file tail $XSA]]
}

# Normalize paths
set XSA [file normalize $XSA]
set WS  [file normalize $WS]

puts "==> Workspace : $WS"
puts "==> XSA       : $XSA"
puts "==> Platform  : $NAME"
puts "==> Proc      : $PROC"
puts "==> OS        : $OS"

# ---------- build ----------
setws $WS
platform create -name $NAME -hw $XSA -os $OS -proc $PROC
platform build   -name $NAME

# Print the likely output directory for convenience
set dom "${OS}_${PROC}"
set outdir [file join $WS $NAME export $NAME sw $NAME $dom]
puts "==> BSP output: $outdir"
puts "    - include/ (xparameters*.h)"
puts "    - lib/libxil.a"
puts "    - lscript.ld"

exit
