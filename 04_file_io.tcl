#!/usr/bin/env tclsh
# 04_file_io.tcl -- file & log processing, Tcl's classic "glue" role
# Run standalone:  tclsh 04_file_io.tcl

proc section {title} { puts "$title" }

set scriptDir [file dirname [info script]]
set dataDir   [file join $scriptDir data]
file mkdir $dataDir

section "Writing a file"
set logPath [file join $dataDir sample.log]
set f [open $logPath w]
puts $f "INFO: run started"
puts $f "TIMING: path1 slack=0.45"
puts $f "TIMING: path2 slack=-0.12"
puts $f "WARN: unconnected pin U3/A"
puts $f "TIMING: path3 slack=0.02"
close $f
puts "wrote [file size $logPath] bytes to $logPath"

section "Reading a file line by line"
set f [open $logPath r]
set lineNo 0
while {[gets $f line] >= 0} {
    incr lineNo
    puts "  $lineNo: $line"
}
close $f

section "Filtering + extracting data (grep + parse in one pass)"
set f [open $logPath r]
set violations {}
while {[gets $f line] >= 0} {
    if {[regexp {TIMING: (\S+) slack=(-?[\d.]+)} $line -> path slack]} {
        if {$slack < 0} {
            lappend violations [list $path $slack]
        }
    }
}
close $f
puts "negative-slack paths: $violations"

section "Writing structured output (CSV)"
set csvPath [file join $dataDir cells.csv]
set f [open $csvPath w]
puts $f "name,area,delay"
foreach row {
    {INV_X1 0.6 8}
    {AND2_X1 1.2 15}
    {OR2_X1 1.1 14}
} {
    puts $f [join $row ,]
}
close $f

section "Reading the CSV back into a list of dicts"
set f [open $csvPath r]
set header [split [gets $f] ,]
set rows {}
while {[gets $f line] >= 0} {
    if {$line eq ""} { continue }
    set values [split $line ,]
    set row {}
    foreach h $header v $values { lappend row $h $v }
    lappend rows $row
}
close $f
foreach r $rows { puts "  $r" }

section "Cleanup"
file delete $logPath $csvPath
puts "removed temp files under $dataDir"
