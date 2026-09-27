#!/usr/bin/env tclsh
# 01_basics.tcl -- variables, control flow, procs, scoping
# Run standalone:  tclsh 01_basics.tcl

proc section {title} {
    puts "$title"
}

section "Variables & Expressions"

# Input method from consol
puts "Enter Your Name : "
set name [gets stdin]
#set name  "Mamunar"
set count 3
puts "Hello, $name! count=$count, count*2=[expr {$count * 2}]"

section "Control flow: if / for / while / switch"
foreach n {1 2 3 4 5} {
    if {$n % 2 == 0} {
        puts "$n is even"
    } else {
        puts "$n is odd"
    }
}

set numbers {1 2 3 4 5}
foreach in $numbers {
	puts $in
}

set i 0
while {$i < 3} {
    puts "while loop i=$i"
    incr i
}

foreach grade {A B C F} {
    switch -- $grade {
        A - B { puts "$grade -> pass with distinction" }
        C     { puts "$grade -> pass" }
        F     { puts "$grade -> fail" }
        default { puts "$grade -> unknown" }
    }
}

section "Procedures, default args, variadic args"
proc greet {who {greeting "Hello"}} {
    return "$greeting, $who!"
}
puts [greet "World"]
puts [greet "World" "Hi"]

proc sum {args} {
    set total 0
    foreach v $args { set total [expr {$total + $v}] }
    return $total
}
puts "sum 1 2 3 4 = [sum 1 2 3 4]"

section "Scoping: global vs local"
set counter 0
proc bump {} {
    global counter
    incr counter
}
bump; bump; bump
puts "counter after 3 bumps = $counter"

section "Recursion"
proc fact {n} {
    if {$n <= 1} { return 1 }
    return [expr {$n * [fact [expr {$n - 1}]]}]
}
puts "5! = [fact 5]"
