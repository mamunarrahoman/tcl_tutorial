#!/usr/bin/env tclsh
# 02_data_structures.tcl -- lists, arrays, dicts
# Run standalone:  tclsh 02_data_structures.tcl

proc section {title} { puts "$title" }

section "Lists"
set fruits {apple banana cherry date}
puts "list: $fruits"
puts "length: [llength $fruits]"
puts "element 1: [lindex $fruits 1]"
lappend fruits "elderberry"
puts "after lappend: $fruits"
puts "sorted: [lsort $fruits]"
puts "filtered (contains 'e'): [lsearch -all -inline $fruits *e*]"

set nested [list [list 1 2 3] [list 4 5 6]]
puts "nested: $nested, first row: [lindex $nested 0]"

section "Arrays (classic Tcl associative arrays)"
array set person {
	name Mamunar 
	field VLSI 
	goal PhD
}

foreach key [lsort [array names person]] {
    puts "person($key) = $person($key)"
}

section "Dicts (modern key-value structure, ordered)"
set device [dict create name inv1 type INV drive x2 delay_ps 12.5]
dict set device delay_ps 11.8
puts "device dict: $device"
dict for {k v} $device {
    puts "  $k -> $v"
}
puts "has key 'type'? [dict exists $device type]"

section "List of dicts -- a common 'table' pattern"
set cells {}
lappend cells [dict create name AND2_X1 area 1.2 delay 15]
lappend cells [dict create name OR2_X1  area 1.1 delay 14]
lappend cells [dict create name INV_X1  area 0.6 delay 8]

set totalArea 0.0
foreach cell $cells {
    set totalArea [expr {$totalArea + [dict get $cell area]}]
}
puts "cells: $cells"
puts "total area = $totalArea"

set sorted [lsort -real -index 1 -decreasing \
    [lmap c $cells { list [dict get $c name] [dict get $c delay] }]]
puts "cells sorted by delay (desc): $sorted"
