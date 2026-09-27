#!/usr/bin/env tclsh
# 08_networking.tcl -- sockets & Tcl's event-driven I/O model
# Runs an echo server and a client against it, both in one process,
# using the event loop (vwait) instead of threads.
# Run standalone:  tclsh 08_networking.tcl

proc section {title} { puts "$title" }

set ::done 0
set ::received {}

proc accept_conn {sock addr port} {
    puts "  server: client connected from $addr:$port"
    fconfigure $sock -buffering line
    fileevent $sock readable [list on_readable $sock]
}

proc on_readable {sock} {
    if {[eof $sock]} {
        close $sock
        return
    }
    set line [gets $sock]
    puts "  server: got '$line', echoing back"
    puts $sock "ECHO: $line"
}

proc on_client_readable {sock} {
    if {[eof $sock]} {
        close $sock
        set ::done 1
        return
    }
    set line [gets $sock]
    lappend ::received $line
    puts "  client: received '$line'"
    close $sock
    set ::done 1
}

section "Starting a TCP echo server on localhost"
set server [socket -server accept_conn -myaddr 127.0.0.1 0]
set port [lindex [fconfigure $server -sockname] 2]
puts "server listening on port $port"

section "Connecting a client and exchanging one message"
set client [socket 127.0.0.1 $port]
fconfigure $client -buffering line
fileevent $client readable [list on_client_readable $client]
puts $client "hello from the client"

vwait ::done
close $server
puts "final received: $::received"

puts "\n(A real Tcl network app would keep the event loop running with"
puts " 'vwait forever' instead of exiting after one message.)"
