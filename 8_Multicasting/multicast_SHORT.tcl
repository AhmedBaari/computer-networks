set ns [new Simulator -multicast on]

set tf [open output.tr w]
$ns trace-all $tf
set fd [open mcast.nam w]
$ns namtrace-all $fd

for {set i 0} {$i < 8} {incr i} {
    set n($i) [$ns node]
}

foreach {src dst} {
    0 2 1 2 2 3 3 4 3 7 4 5 4 6
} {
    $ns duplex-link $n($src) $n($dst) 1.5Mb 10ms DropTail
}

set mproto DM
set mrthandle [$ns mrtproto $mproto {}]

set group1 [Node allocaddr]
set group2 [Node allocaddr]

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

set rcvr1 [new Agent/Null]
$ns attach-agent $n(5) $rcvr1
$ns at 1.0 "$n(5) join-group $rcvr1 $group1"

set rcvr2 [new Agent/Null]
$ns attach-agent $n(6) $rcvr2
$ns at 1.5 "$n(6) join-group $rcvr2 $group1"

set rcvr3 [new Agent/Null]
$ns attach-agent $n(7) $rcvr3
$ns at 2.0 "$n(7) join-group $rcvr3 $group1"

set rcvr4 [new Agent/Null]
$ns attach-agent $n(5) $rcvr4
$ns at 2.5 "$n(5) join-group $rcvr4 $group2"

set rcvr5 [new Agent/Null]
$ns attach-agent $n(6) $rcvr5
$ns at 3.0 "$n(6) join-group $rcvr5 $group2"

set rcvr6 [new Agent/Null]
$ns attach-agent $n(7) $rcvr6
$ns at 3.5 "$n(7) join-group $rcvr6 $group2"

$ns at 4.0 "$n(5) leave-group $rcvr1 $group1"
$ns at 4.5 "$n(6) leave-group $rcvr2 $group1"
$ns at 5.0 "$n(7) leave-group $rcvr3 $group1"
$ns at 5.5 "$n(5) leave-group $rcvr4 $group2"
$ns at 6.0 "$n(6) leave-group $rcvr5 $group2"
$ns at 6.5 "$n(7) leave-group $rcvr6 $group2"

$ns at 0.5 "$cbr1 start"
$ns at 9.5 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 9.5 "$cbr2 stop"

proc finish {} {
    global ns tf
    $ns flush-trace
    close $tf
    exec nam mcast.nam &
    exit 0
}

$ns at 10.0 "finish"
$ns set-animation-rate 3.0ms
$ns run