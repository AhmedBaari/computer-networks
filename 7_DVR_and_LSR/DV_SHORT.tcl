set ns [new Simulator]
$ns rtproto DV

set tf [open out.tr w]
$ns trace-all $tf

set nf [open out.nam w]
$ns namtrace-all $nf

for {set i 0} {$i < 7} {incr i} {
    set node($i) [$ns node]
}

for {set i 0} {$i < 7} {incr i} {
    set j [expr ($i+1) % 7]
    $ns duplex-link $node($i) $node($j) 1.5Mb 10ms DropTail
}

set tcp2 [new Agent/TCP]
$ns attach-agent $node(0) $tcp2
set sink2 [new Agent/TCPSink]
$ns attach-agent $node(3) $sink2
$ns connect $tcp2 $sink2
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

proc finish {} {
    global ns tf nf
    $ns flush-trace
    close $tf
    close $nf
    exec nam out.nam &
    exit 0
}

$ns at 0.5 "$ftp2 start"
$ns rtmodel-at 2.0 down $node(2) $node(3)
$ns rtmodel-at 3.0 up $node(2) $node(3)
$ns at 4.9 "$ftp2 stop"
$ns at 5.0 "finish"

$ns run
