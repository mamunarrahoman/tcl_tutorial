#!/usr/bin/env tclsh
# 03_string_regex.tcl -- string manipulation & regular expressions
# Tcl's original design center; still one of its strongest areas.
# Run standalone:  tclsh 03_string_regex.tcl

proc section {title} { puts "$title" }

section "Basic string ops"
set s "  Hello, Tcl World!  "
puts "trimmed: '[string trim $s]'"
puts "upper: [string toupper $s]"
puts "length: [string length $s]"
puts "range 2-6: [string range $s 2 6]"
puts "replace 'Tcl' with 'TCL': [string map {Tcl TCL} $s]"

section "Splitting & joining"
set csvLine "cell,area,delay,power"
set fields [split $csvLine ,]
puts "fields: $fields"
puts "rejoined with ' | ': [join $fields " | "]"

section "Regular expressions -- regexp"
set line "WARNING: cell INV_X2 violates max_transition at pin A (0.42ns > 0.35ns)"
if {[regexp {WARNING: cell (\S+) violates (\S+) at pin (\S+) \(([\d.]+)ns > ([\d.]+)ns\)} \
        $line -> cell rule pin actual limit]} {
    puts "parsed violation:"
    puts "  cell   = $cell"
    puts "  rule   = $rule"
    puts "  pin    = $pin"
    puts "  actual = ${actual}ns"
    puts "  limit  = ${limit}ns"
}

section "Regular expressions -- regexp -all"
set text "net1: 3.2ns, net2: 1.1ns, net3: 5.6ns"
set delays [regexp -all -inline {[\d.]+ns} $text]
puts "all delay tokens: $delays"

section "Regular expressions -- regsub (substitution)"
set path {C:\designs\top\netlist.v}
set unixPath [regsub -all {\\} $path {/}]
puts "windows path -> unix-style: $unixPath"

set noisy "This    has   irregular     spacing"
set clean [regsub -all {\s+} $noisy " "]
puts "normalized spacing: '$clean'"

section "Format & scan (printf/scanf style)"
puts [format "%-10s %8.3f %5d" "INV_X1" 0.612 4]
scan "cell=AND2 area=1.20 fanout=3" "cell=%s area=%f fanout=%d" cname carea cfanout
puts "scanned -> name=$cname area=$carea fanout=$cfanout"
