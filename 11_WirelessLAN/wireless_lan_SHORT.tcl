set val(chan) Channel/WirelessChannel
set val(prop) Propagation/TwoRayGround
set val(netif) Phy/WirelessPhy
set val(ant) Antenna/OmniAntenna
set val(ll) LL
set val(ifq) Queue/DropTail/PriQueue
set val(ifqlen) 50
set val(mac) Mac/802_11
set val(nn) 5
#set val(rp) AODV

set ns [new Simulator]
set f [open trace.tr w]
$ns trace-all $f
set namtrace [open complexdcf.nam w]
$ns namtrace-all-wireless $namtrace 800 800

set topo [new Topography]
$topo load_flatgrid 800 800

create-god $val(nn)
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

# Create 5 nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
    $n($i) random-motion 0
}

# Set node positions
for {set i 0} {$i < $val(nn)} {incr i} {
    $n($i) set X_ 0.0
    $n($i) set Y_ 0.0
    $n($i) set Z_ 0.0
}

# Define destinations for the nodes
set destinations {
    {0 100.0 100.0 3000.0}
    {1 200.0 200.0 3000.0}
    {2 300.0 200.0 3000.0}
    {3 400.0 300.0 3000.0}
    {4 500.0 300.0 3000.0}
}

foreach dest $destinations {
    lassign $dest idx x y speed
    $ns at 0.0 "$n($idx) setdest $x $y $speed"
}

# Hardcoded sink nodes
set sink(1) [new Agent/LossMonitor]
$ns attach-agent $n(1) $sink(1)

set sink(3) [new Agent/LossMonitor]
$ns attach-agent $n(3) $sink(3)

# Hardcoded TCP agents
set tcp(0) [new Agent/TCP]
$ns attach-agent $n(0) $tcp(0)

set tcp(2) [new Agent/TCP]
$ns attach-agent $n(2) $tcp(2)

set tcp(4) [new Agent/TCP]
$ns attach-agent $n(4) $tcp(4)

# Attach CBR traffic directly in the main code
set cbr0 [new Agent/CBR]
$ns attach-agent $n(0) $cbr0
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.015
$ns connect $cbr0 $sink(3)

set cbr1 [new Agent/CBR]
$ns attach-agent $n(2) $cbr1
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.015
$ns connect $cbr1 $sink(1)

# Start and stop CBR traffic
$ns at 20.0 "$cbr0 start"
$ns at 20.0 "$cbr1 start"
$ns at 800.0 "$cbr0 stop"
$ns at 850.0 "$cbr1 stop"

$ns at 900.0 "finish"
$ns run