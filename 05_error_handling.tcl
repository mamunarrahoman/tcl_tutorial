#!/usr/bin/env tclsh
# 05_error_handling.tcl -- catch, try/on/finally, custom errors
# Run standalone:  tclsh 05_error_handling.tcl

proc section {title} { puts "$title" }

section "Basic catch"
set status [catch {expr {1 / 0}} result]
if {$status} {
    puts "caught error: $result"
}

section "try / on / finally (Tcl 8.6+)"
proc divide {a b} {
    try {
        return [expr {$a / double($b)}]
    } on error {msg} {
        puts "  division failed: $msg"
        return 0
    } finally {
        puts "  (divide $a $b attempted)"
    }
}
puts "10/2 = [divide 10 2]"
puts "10/0 = [divide 10 0]"

section "Custom error codes"
proc checkArea {area} {
    if {$area < 0} {
        return -code error -errorcode {DESIGN NEGATIVE_AREA} \
            "area cannot be negative: $area"
    }
    return "area OK: $area"
}

foreach a {1.2 -0.5} {
    try {
        puts [checkArea $a]
    } trap {DESIGN NEGATIVE_AREA} {msg opts} {
        puts "design rule violation: $msg (code=[dict get $opts -errorcode])"
    }
}

section "Validating input before doing work"
proc safeSqrt {x} {
    if {![string is double -strict $x]} {
        error "not a number: '$x'"
    }
    if {$x < 0} {
        error "cannot take sqrt of negative number: $x"
    }
    return [expr {sqrt($x)}]
}

foreach v {16 -4 "abc"} {
    if {[catch {safeSqrt $v} res]} {
        puts "safeSqrt($v) failed: $res"
    } else {
        puts "safeSqrt($v) = $res"
    }
}
