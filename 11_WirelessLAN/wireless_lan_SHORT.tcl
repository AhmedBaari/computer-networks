Mac/802_11 set dataRate_ 1Mb

set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(ant) Antenna/OmniAntenna
set val(ll) LL
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
#set val(mac) Mac/802_11
#set val(nn) 15
#set val(rp) AODV


set ns [new Simulator]
set f [open trace.tr w]
$ns trace-all $f
set namtrace [open complexdcf.nam w]
$ns namtrace-all-wireless $namtrace 800 800

set topo [new Topography]
$topo load_flatgrid 800 800

create-god 15
set chan_1 [new Channel/WirelessChannel]

$ns node-config -adhocRouting $val(rp) -llType $val(ll) -macType $val(mac) \
-ifqType $val(ifq) -ifqLen $val(ifqlen) -antType $val(ant) -propType $val(prop) \
-phyType $val(netif) -topoInstance $topo -channel $chan_1

proc finish {} {
    global ns f namtrace
    $ns flush-trace
    close $f
    exec nam -r 5m complexdcf.nam &
    exit 0
}



for {set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
    $n($i) random-motion 0
}

for {set i 0} {$i < $val(nn)} {incr i} {
    #$ns initial_node_pos $n($i) 30+i*100
    $n($i) set X_ 0.0
    $n($i) set Y_ 0.0
    $n($i) set Z_ 0.0
}

set destinations {
    {0 100.0 100.0 3000.0}
    {1 200.0 200.0 3000.0}
    {2 300.0 200.0 3000.0}
    {3 400.0 300.0 3000.0}
    {4 500.0 300.0 3000.0}
    {5 600.0 400.0 3000.0}
    {6 600.0 100.0 3000.0}
    {7 600.0 200.0 3000.0}
    {8 600.0 300.0 3000.0}
    {9 600.0 350.0 3000.0}
    {10 700.0 100.0 3000.0}
    {11 700.0 200.0 3000.0}
    {12 700.0 300.0 3000.0}
    {13 700.0 350.0 3000.0}
    {14 700.0 400.0 3000.0}
}

foreach dest $destinations {
    lassign $dest idx x y speed
    $ns at 0.0 "$n($idx) setdest $x $y $speed"
}

set sinkNodes {1 3 7 10 11}
foreach idx $sinkNodes {
    set sink($idx) [new Agent/LossMonitor]
    $ns attach-agent $n($idx) $sink($idx)
}

set tcpNodes {0 2 4 5 9 6 8 12}
foreach idx $tcpNodes {
    set tcp($idx) [new Agent/TCP]
    $ns attach-agent $n($idx) $tcp($idx)
}


proc attach-CBR-traffic {node sink size interval} {
    set ns [Simulator instance]
    set cbr [new Agent/CBR]
    $ns attach-agent $node $cbr
    $cbr set packetSize_ $size
    $cbr set interval_ $interval
    $ns connect $cbr $sink
    return $cbr
}

set cbr0 [attach-CBR-traffic $n(0) $sink(3) 1000 .015]
set cbr1 [attach-CBR-traffic $n(5) $sink(3) 1000 .015]
set cbr2 [attach-CBR-traffic $n(2) $sink(1) 1000 .015]
set cbr3 [attach-CBR-traffic $n(4) $sink(1) 1000 .015]

$ns at 20.0 "$cbr0 start"
$ns at 20.0 "$cbr2 start"
$ns at 800.0 "$cbr0 stop"
$ns at 850.0 "$cbr2 stop"
$ns at 30.0 "$cbr1 start"
$ns at 30.0 "$cbr3 start"
$ns at 850.0 "$cbr1 stop"
$ns at 870.0 "$cbr3 stop"

$ns at 900.0 "finish"
puts "Start of simulation.."
$ns run