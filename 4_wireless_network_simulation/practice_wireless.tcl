set val(chan) Channel/WirelessChannel;

set val(prop) Propagation/TwoRayGround;

set val(netif) Phy/WirelessPhy;

set val(mac) Mac/802_11;

set val(ifq) Queue/DropTail/PriQueue;

set val(ll) LL;

set val(ant) Antenna/OmniAntenna;

set val(ifqlen) 50;

set val(nn) 6;

set val(rp) AODV;

set val(x) 500;
set val(y) 500;

# Create new simulator 
set ns [new Simulator]

# Tracefile 
set tracefile [open wireless.tr w]
$ns trace-all $tracefile 

# Network Animation File
set namfile [open wireless.nam w]
$ns namtrace-all-wireless $namfile 500 500

# Create topography
set topo [new Topography]
$topo load_flatgrid 500 500


create-god 6

# GOD Creation 
set channel1 [new Channel/WirelessChannel]
set channel2 [new Channel/WirelessChannel]
set channel3 [new Channel/WirelessChannel]

# Configure the node
$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -topoInstance $topo \
  -agentTrace ON \
  -macTrace ON \
  -routerTrace ON \
  -movementTrace ON \
  -channel $channel1 



set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Random Motion False
$n0 random-motion 0
$n1 random-motion 0
$n2 random-motion 0
$n3 random-motion 0
$n4 random-motion 0

# POSITION!?!?!?
$ns initial_node_pos $n0 10
$ns initial_node_pos $n1 20
$ns initial_node_pos $n2 30
$ns initial_node_pos $n3 40
$ns initial_node_pos $n4 50
$ns initial_node_pos $n5 60

# Initial Coordinates
$n0 set X_ 10.0
$n0 set Y_ 20.0
$n0 set Z_ 0.0

$n1 set X_ 210.0
$n1 set Y_ 230.0
$n1 set Z_ 0.0

$n2 set X_ 100.0
$n2 set Y_ 200.0
$n2 set Z_ 0.0

$n3 set X_ 150.0
$n3 set Y_ 230.0
$n3 set Z_ 0.0

$n4 set X_ 430.0
$n4 set Y_ 320.0
$n4 set Z_ 0.0

$n5 set X_ 270.0
$n5 set Y_ 120.0
$n5 set Z_ 0.0


# MOBILITY 
$ns at 1.0 "$n1 setdest 490.0 340.0 25.0"
$ns at 1.0 "$n4 setdest 300.0 130.0 5.0"
$ns at 1.0 "$n5 setdest 190.0 440.0 15.0"
$ns at 20.0 "$n5 setdest 100.0 200.0 30.0"

# AGENT CREATION 
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]

$ns attach-agent $n0 $tcp 
$ns attach-agent $n5 $sink 

# connect them 
$ns connect $tcp $sink 

# FTP 
set ftp [new Application/FTP]
# ftp touches TCP 
$ftp attach-agent $tcp 
$ns at 1.0 "$ftp start"

# UDP 
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n2 $udp 
$ns attach-agent $n3 $null 
$ns connect $udp $null

# cbr 
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp 
$ns at 1.0 "$cbr start"

$ns at 30.0 "finish"

proc finish {} {
global ns tracefile namfile
$ns flush-trace 
close $tracefile
close $namfile 
exit 0


}

puts "Starting Simulation"
$ns run 