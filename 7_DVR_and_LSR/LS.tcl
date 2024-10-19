set ns [new Simulator]
$ns rtproto LS
$ns color 1 green

set node0 [$ns node]
set node1 [$ns node]
set node2 [$ns node]
set node3 [$ns node]
set node4 [$ns node]
set node5 [$ns node]
set node6 [$ns node]

set tf [open out_ls.tr w]
$ns trace-all $tf
set nf [open out_ls.nam w]
$ns namtrace-all $nf
set ft [open "lsr_th" "w"]

$node0 label "node 0"
$node1 label "node 1"
$node2 label "node 2"
$node3 label "node 3"
$node4 label "node 4"
$node5 label "node 5"
$node6 label "node 6"

$ns duplex-link $node0 $node1 1.5Mb 10ms DropTail
$ns duplex-link $node1 $node2 1.5Mb 10ms DropTail
$ns duplex-link $node2 $node3 1.5Mb 10ms DropTail
$ns duplex-link $node3 $node4 1.5Mb 10ms DropTail
$ns duplex-link $node4 $node5 1.5Mb 10ms DropTail
$ns duplex-link $node5 $node6 1.5Mb 10ms DropTail
$ns duplex-link $node6 $node0 1.5Mb 10ms DropTail

$ns duplex-link-op $node0 $node1 orient left-down
$ns duplex-link-op $node1 $node2 orient left-down
$ns duplex-link-op $node2 $node3 orient right-down
$ns duplex-link-op $node3 $node4 orient right
$ns duplex-link-op $node4 $node5 orient right-up
$ns duplex-link-op $node5 $node6 orient left-up
$ns duplex-link-op $node6 $node0 orient left-up

set tcp2 [new Agent/TCP]
$tcp2 set class_ 1
$ns attach-agent $node0 $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $node3 $sink2
$ns connect $tcp2 $sink2

set traffic_ftp2 [new Application/FTP]
$traffic_ftp2 attach-agent $tcp2
proc record {} {
global sink2 tf ft
global ftp

set ns [Simulator instance]
set time 0.1
set now [$ns now]
set bw0 [$sink2 set bytes_]
puts $ft "$now [expr $bw0/$time*8/1000000]"
$sink2 set bytes_ 0
$ns at [expr $now+$time] "record"
}

proc finish {} {
global ns nf
$ns flush-trace
close $nf

exec nam out_ls.nam &
exec xgraph lsr_th &
exit 0
}

$ns at 0.55 "record"
#Schedule events for the CBR agents
$ns at 0.5 "$node0 color \"Green\""
$ns at 0.5 "$node3 color \"Green\""
$ns at 0.5 "$ns trace-annotate \"Starting FTP node0 to node3\""
$ns at 0.5 "$node0 label-color green"
$ns at 0.5 "$node3 label-color green"

$ns at 0.5 "$traffic_ftp2 start"
$ns at 0.5 "$node1 label-color green"
$ns at 0.5 "$node2 label-color green"
$ns at 0.5 "$node4 label-color blue"
$ns at 0.5 "$node5 label-color blue"
$ns at 0.5 "$node6 label-color blue"
$ns rtmodel-at 2.0 down $node2 $node3
$ns at 2.0 "$node4 label-color green"
$ns at 2.0 "$node5 label-color green"
$ns at 2.0 "$node6 label-color green"
$ns at 2.0 "$node1 label-color blue"
$ns at 2.0 "$node2 label-color blue"
$ns rtmodel-at 3.0 up $node2 $node3
$ns at 3.0 "$traffic_ftp2 start"
$ns at 4.9 "$traffic_ftp2 stop"
$ns at 5.0 "finish"
$ns run


