#!/usr/bin/env tclsh
# main.tcl -- menu-driven runner for the "Tcl Tour" project.
#
# Usage:
#   tclsh main.tcl          interactive menu
#   tclsh main.tcl all      run every runnable module in sequence
#   tclsh main.tcl 3        run module 3 directly
#   tclsh main.tcl basics   run by short name

set scriptDir [file dirname [info script]]

set modules {
    1  01_basics.tcl          "Core language: vars, control flow, procs"
    2  02_data_structures.tcl "Lists, arrays, dicts"
    3  03_string_regex.tcl    "String processing & regular expressions"
    4  04_file_io.tcl         "File I/O & log/CSV processing"
    5  05_error_handling.tcl  "catch / try-on / custom errors"
    6  06_oop_tcloo.tcl       "Object orientation with TclOO"
    7  07_namespaces.tcl      "Namespaces & ensemble commands"
    8  08_networking.tcl      "Sockets & the event loop"
    9  09_eda_scripting.tcl   "EDA/VLSI tool scripting (SDC-style)"
    10 10_gui_tk.tcl          "Tk GUI (needs a display -- not auto-run)"
}

proc run_module {num} {
    global scriptDir modules
    foreach {n file desc} $modules {
        if {$n == $num} {
            if {$n == 10} {
                puts "\n(module 10 needs a graphical display; open"
                puts " $file yourself with 'wish' to try it)"
                return
            }
            puts "\n-------------------------------------------------------"
            puts " Module $n: $desc"
            puts "-------------------------------------------------------\n"
            set path [file join $scriptDir $file]
            # run each module in its own interpreter so demos don't
            # collide (namespaces/vars/procs stay isolated)
            set child [interp create]
            $child eval [list set argv0 $path]
            if {[catch {$child eval [list source $path]} err]} {
                puts "!! module $n error: $err"
            }
            interp delete $child
            return
        }
    }
    puts "no such module: $num"
}

proc print_menu {} {
    global modules
    puts "\nTcl Tour -- major applications of Tcl"
    foreach {n file desc} $modules {
        puts [format "  %2d) %-24s %s" $n $file $desc]
    }
    puts "   a) run all (1-9, skips GUI)"
    puts "   q) quit"
}

# ---- entry point -----------------------------------------------------
set argv0given [lindex $::argv 0]

if {$argv0given eq "all"} {
    for {set n 1} {$n <= 9} {incr n} { run_module $n }
    exit 0
} elseif {$argv0given ne ""} {
    run_module $argv0given
    exit 0
}

# interactive loop
while {1} {
    print_menu
    puts -nonewline "\nchoice: "
    flush stdout
    if {[eof stdin]} { break }
    set choice [gets stdin]
    if {$choice eq "q"} { break }
    if {$choice eq "a"} {
        for {set n 1} {$n <= 9} {incr n} { run_module $n }
        continue
    }
    run_module $choice
}
puts "bye"
