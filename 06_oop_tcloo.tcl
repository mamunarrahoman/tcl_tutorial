#!/usr/bin/env tclsh
# 06_oop_tcloo.tcl -- object orientation with the built-in TclOO package
# Run standalone:  tclsh 06_oop_tcloo.tcl

package require TclOO

proc section {title} { puts "$title" }

section "A basic class"
oo::class create Cell {
    variable Name Area Delay

    constructor {name area delay} {
        set Name  $name
        set Area  $area
        set Delay $delay
    }

    method name  {} { return $Name }
    method area  {} { return $Area }
    method delay {} { return $Delay }

    method describe {} {
        return [format "%-10s area=%.2f delay=%.1fps" $Name $Area $Delay]
    }
}

set inv [Cell new INV_X1 0.6 8.0]
set nand [Cell new NAND2_X1 0.9 11.5]
puts [$inv describe]
puts [$nand describe]

section "Inheritance"
oo::class create SequentialCell {
    superclass Cell
    variable ClockPin

    constructor {name area delay clockPin} {
        next $name $area $delay
        set ClockPin $clockPin
    }

    method describe {} {
        return "[next] clk=$ClockPin"
    }
}

set dff [SequentialCell new DFF_X1 2.4 25.0 CK]
puts [$dff describe]

section "Polymorphism over a list of objects"
set cells [list $inv $nand $dff]
set totalArea 0.0
foreach c $cells {
    puts [$c describe]
    set totalArea [expr {$totalArea + [$c area]}]
}
puts "total area = $totalArea"

section "Destroying objects"
$inv destroy
if {[catch {$inv area}]} {
    puts "inv object destroyed successfully (call now fails as expected)"
}
