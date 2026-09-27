#!/usr/bin/env tclsh
# 10_gui_tk.tcl -- a small GUI with Tk (Tcl's native toolkit).

package require Tk

wm title . "Cell Area Calculator Demo App"

ttk::frame .main -padding 12
pack .main -fill both -expand 1

ttk::label .main.wl -text "Width (um):"
ttk::entry .main.we -textvariable widthVar -width 20
ttk::label .main.hl -text "Height (um):"
ttk::entry .main.he -textvariable heightVar -width 20
ttk::button .main.compute -text "Compute Area" -command compute_area
ttk::label .main.result -textvariable resultVar -font {-weight bold}

grid .main.wl   -row 0 -column 0 -sticky w -pady 4
grid .main.we   -row 0 -column 1 -pady 4
grid .main.hl   -row 1 -column 0 -sticky w -pady 4
grid .main.he   -row 1 -column 1 -pady 4
grid .main.compute -row 2 -column 0 -columnspan 2 -pady 8
grid .main.result  -row 3 -column 0 -columnspan 2

set widthVar ""
set heightVar ""
set resultVar "Area: --"

proc compute_area {} {
    global widthVar heightVar resultVar
    if {![string is double -strict $widthVar] ||
        ![string is double -strict $heightVar]} {
        set resultVar "Enter valid numbers"
        return
    }
    set area [expr {$widthVar * $heightVar}]
    set resultVar [format "Area: %.3f um^2" $area]
}

bind . <Return> compute_area
