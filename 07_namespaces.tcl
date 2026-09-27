#!/usr/bin/env tclsh
# 07_namespaces.tcl -- namespaces for building reusable "packages"
# Run standalone:  tclsh 07_namespaces.tcl

proc section {title} { puts "$title" }

namespace eval ::sta {
    variable clockPeriod 1000.0 ;# ps
    namespace export report_slack set_clock_period

    proc set_clock_period {ps} {
        variable clockPeriod
        set clockPeriod $ps
    }

    proc report_slack {arrival} {
        variable clockPeriod
        set slack [expr {$clockPeriod - $arrival}]
        return [format "arrival=%.1fps required=%.1fps slack=%.1fps" \
            $arrival $clockPeriod $slack]
    }
}

namespace eval ::power {
    namespace export estimate

    proc estimate {switchingActivity capacitance voltage frequency} {
        # P = alpha * C * V^2 * f  (dynamic power, simplified)
        return [expr {$switchingActivity * $capacitance * pow($voltage, 2) * $frequency}]
    }
}

section "Calling namespaced procs with full paths"
::sta::set_clock_period 800.0
puts [::sta::report_slack 650.0]
puts "dynamic power estimate: [::power::estimate 0.15 2.0e-12 0.8 1.0e9] W"

section "Importing into the current namespace"
namespace import ::sta::*
puts [report_slack 900.0] ;# now callable unqualified

section "Namespace-scoped state is isolated"
puts "sta::clockPeriod   = $::sta::clockPeriod"
namespace eval ::sta { variable clockPeriod }
puts "changing it only affects the sta namespace, not globals"

section "Ensemble command (a mini CLI dispatcher)"
namespace eval ::tool {
    namespace ensemble create
    namespace export run version

    proc run {args} { puts "tool run: $args" }
    proc version {} { return "1.0.0" }
}
tool run --flow synth
puts "tool version: [tool version]"
