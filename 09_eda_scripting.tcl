#!/usr/bin/env tclsh
# 09_eda_scripting.tcl -- Tcl as an EDA/VLSI tool-command language.
# Run standalone:  tclsh 09_eda_scripting.tcl

proc section {title} { puts "$title" }

# ---- A toy design database (normally this comes from a netlist reader) ---
array set ::design {}
set ::design(pins) {clk in1 in2 out1 out2}
set ::design(paths) {
    {in1 out1 550}
    {in2 out1 720}
    {in1 out2 300}
    {in2 out2 1050}
}
;# each path: {startpoint endpoint arrival_ps}

# ---- A tiny "SDC-like" constraint interface -------------------------------
# Real tool commands: create_clock, set_input_delay, set_max_delay, ...
array set ::constraints {}

proc create_clock {args} {
    array set opts {-name clk -period 1000}
    array set opts $args
    set ::constraints(clock_name)   $opts(-name)
    set ::constraints(clock_period) $opts(-period)
    puts "  (constraint) create_clock -name $opts(-name) -period $opts(-period)"
}

proc set_max_delay {delay_ps args} {
    set ::constraints(max_delay) $delay_ps
    puts "  (constraint) set_max_delay $delay_ps $args"
}

# ---- Load constraints exactly like sourcing a .sdc file -------------------
section "Sourcing constraints (SDC-style Tcl commands)"
create_clock -name core_clk -period 900
set_max_delay 950 -from in2

# ---- Timing check, the same shape as a real STA report --------------------
section "Timing analysis"
proc report_timing {} {
    set period $::constraints(clock_period)
    set worst  {}
    set worstSlack 1e12

    foreach path $::design(paths) {
        lassign $path startp endp arrival
        set slack [expr {$period - $arrival}]
        set status [expr {$slack >= 0 ? "MET" : "VIOLATED"}]
        puts [format {  %-6s -> %-6s  arrival=%5dps  slack=%6.1fps  [%s]} \
            $startp $endp $arrival $slack $status]
        if {$slack < $worstSlack} {
            set worstSlack $slack
            set worst [list $startp $endp]
        }
    }
    puts "  ---"
    puts [format "  worst path: %s -> %s, slack=%.1fps" \
        [lindex $worst 0] [lindex $worst 1] $worstSlack]
    return $worstSlack
}
set wns [report_timing]

section "Sign-off decision (like a real flow's exit check)"
if {$wns < 0} {
    puts "TIMING NOT MET -- worst negative slack (WNS) = ${wns}ps"
    puts "-> would normally trigger another optimization/ECO pass"
} else {
    puts "TIMING MET -- all paths have positive slack"
}

section "Why this matters"
puts "This is the exact shape of a PrimeTime/OpenSTA sign-off script:"
puts "  1. source design + constraints (Tcl procs standing in for real commands)"
puts "  2. walk timing paths and compute slack"
puts "  3. branch the flow based on the numeric result"
puts "Swap the toy arrays for a real netlist/SDC reader and the control"
puts "flow above is unchanged -- that's why Tcl has stayed the EDA"
puts "industry's scripting layer for decades."
