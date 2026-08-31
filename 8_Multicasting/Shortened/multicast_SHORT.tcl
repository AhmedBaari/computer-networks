set ns [new Simulator -multicast on] ; # IMPORTANT

# Trace and NAM files
set tf [open output.tr w]
$ns trace-all $tf
set fd [open mcast.nam w]
$ns namtrace-all $fd

# Creating 5 nodes instead of 8
for {set i 0} {$i < 5} {incr i} {
    set n($i) [$ns node]
}

# Duplex links
foreach {src dst} {
    0 1 1 2 2 3 2 4
} {
    $ns duplex-link $n($src) $n($dst) 1.5Mb 10ms DropTail
}

# Multicast routing protocol
set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

# Allocating multicast groups
set group1 [Node allocaddr]
set group2 [Node allocaddr]

# Setting up UDP agents and CBR traffic for each group
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
$udp0 set dst_addr_ $group1
$udp0 set dst_port_ 0
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
$udp1 set dst_addr_ $group2
$udp1 set dst_port_ 0
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp1

# Null agents for receiving traffic
set rcvr1 [new Agent/Null]
$ns attach-agent $n(3) $rcvr1
$ns at 1.0 "$n(3) join-group $rcvr1 $group1"

set rcvr2 [new Agent/Null]
$ns attach-agent $n(4) $rcvr2
$ns at 1.5 "$n(4) join-group $rcvr2 $group1"

set rcvr3 [new Agent/Null]
$ns attach-agent $n(3) $rcvr3
$ns at 2.0 "$n(3) join-group $rcvr3 $group2"

set rcvr4 [new Agent/Null]
$ns attach-agent $n(4) $rcvr4
$ns at 2.5 "$n(4) join-group $rcvr4 $group2"

# Leave group events
$ns at 4.0 "$n(3) leave-group $rcvr1 $group1"
$ns at 4.5 "$n(4) leave-group $rcvr2 $group1"
$ns at 5.0 "$n(3) leave-group $rcvr3 $group2"
$ns at 5.5 "$n(4) leave-group $rcvr4 $group2"

# CBR traffic schedule
$ns at 0.5 "$cbr1 start"
$ns at 9.5 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 9.5 "$cbr2 stop"

# Finish procedure
proc finish {} {
    global ns tf
    $ns flush-trace
    close $tf
    exec nam mcast.nam &
    exit 0
}

# Simulation end
$ns at 10.0 "finish"
$ns set-animation-rate 3.0ms
$ns run
