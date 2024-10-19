# Simulation Configuration
set val(chan) Channel/WirelessChannel           ;# Channel type
set val(prop) Propagation/TwoRayGround          ;# Propagation model
set val(ant) Antenna/OmniAntenna                ;# Antenna type
set val(ll) LL                                  ;# Link layer type
set val(ifq) Queue/DropTail/PriQueue            ;# Interface queue type
set val(ifqlen) 50                              ;# Max packets in interface queue
set val(netif) Phy/WirelessPhy                  ;# Network interface type
set val(mac) Mac/802_11                         ;# MAC type
set val(nn) 15                                  ;# Number of mobilenodes
set val(rp) AODV                                ;# Routing protocol
set val(x) 800                                  ;# X dimension of topography
set val(y) 800                                  ;# Y dimension of topography

# Create Simulation Object
set ns [new Simulator]

# Output trace files
set f [open complexdcf.tr w]
$ns trace-all $f

set namtrace [open complexdcf.nam w]
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

set f0 [open C_DCF_AT.tr w]

# Topography Configuration
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# Create God object for routing information
create-god $val(nn)

# Create wireless channel
set chan_1 [new $val(chan)]

# Node Configuration
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -agentTrace OFF \
                -routerTrace ON \
                -macTrace ON \
                -movementTrace OFF \
                -channel $chan_1

# Finish Procedure
proc finish {} {
    global ns f f0 namtrace
    $ns flush-trace
    close $f0
    exec nam -r 5m complexdcf.nam &
    exit 0
}

# Procedure for calculating throughput
proc record {} {
    global sink1 sink3 sink7 sink10 sink11 f0
    set ns [Simulator instance]
    set time 0.5
    set totalBytes [expr [$sink1 set bytes_] + [$sink3 set bytes_] + \
                         [$sink7 set bytes_] + [$sink10 set bytes_] + [$sink11 set bytes_]]
    set now [$ns now]
    puts $f0 "$now [expr $totalBytes/$time*8/1000000]"
    foreach sink {sink1 sink3 sink7 sink10 sink11} {
        $sink set bytes_ 0
    }
    $ns at [expr $now + $time] "record"
}

# Node creation and initial positioning
for {set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
    $n($i) random-motion 0
    $n($i) set X_ 0.0
    $n($i) set Y_ 0.0
    $n($i) set Z_ 0.0
}

# Set initial destinations for mobile nodes
set dests {
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

foreach dest $dests {
    set i [lindex $dest 0]
    set x [lindex $dest 1]
    set y [lindex $dest 2]
    set speed [lindex $dest 3]
    $ns at 0.0 "$n($i) setdest $x $y $speed"
}

# Movement adjustments
$ns at 2.0 "$n(5) setdest 100.0 400.0 500.0"
$ns at 1.5 "$n(3) setdest 450.0 150.0 500.0"
$ns at 50.0 "$n(7) setdest 300.0 400.0 500.0"
$ns at 2.0 "$n(10) setdest 200.0 400.0 500.0"
$ns at 2.0 "$n(11) setdest 650.0 400.0 500.0"

# Create TCP agents
set tcpNodes {
    {0 tcp0} {2 tcp2} {4 tcp4} {5 tcp5} {9 tcp9} 
    {13 tcp13} {6 tcp6} {14 tcp14} {8 tcp8} {12 tcp12}
}

# Creating sinks with monitoring ability
set sinks {
    {1 sink1} {3 sink3} {7 sink7} {10 sink10} {11 sink11}
}

foreach {node sink} $sinks {
    set $sink [new Agent/LossMonitor]
    $ns attach-agent $n($node) $$sink
}



foreach {node tcp} $tcpNodes {
    set $tcp [new Agent/TCP]
    $ns attach-agent $n($node) $$tcp
}

# FTP Configuration
set ftpNodes {9 13 6 14 8 12}
foreach node $ftpNodes {
    set ftp [new Application/FTP]
    eval $ftp attach-agent \$$tcpNodes($node)
    $ftp set type_ FTP
}

# CBR Traffic Procedure
proc attach-CBR-traffic {node sink size interval} {
    set ns [Simulator instance]
    set cbr [new Agent/CBR]
    $ns attach-agent $node $cbr
    $cbr set packetSize_ $size
    $cbr set interval_ $interval
    $ns connect $cbr $sink
    return $cbr
}

# CBR Traffic Assignment
set cbrs {
    {0 sink3 1000 .015}
    {5 sink3 1000 .015}
    {2 sink1 1000 .015}
    {4 sink1 1000 .015}
}

foreach cbr $cbrs {
    set cbr [attach-CBR-traffic $n([lindex $cbr 0]) [lindex $cbr 1] [lindex $cbr 2] [lindex $cbr 3]]
}

# Schedule Simulation Events
$ns at 0.0 "record"
$ns at 20.0 "$cbr0 start"
$ns at 20.0 "$cbr2 start"
$ns at 800.0 "$cbr0 stop"
$ns at 850.0 "$cbr2 stop"
$ns at 30.0 "$cbr1 start"
$ns at 30.0 "$cbr3 start"
$ns at 850.0 "$cbr1 stop"
$ns at 870.0 "$cbr3 stop"

# FTP Start/Stop Timers
set ftpSchedule {
    {6 25 810}
    {14 25 860}
    {9 35 830}
    {13 35 889}
    {8 40 820}
    {12 40 890}
}

foreach ftpEvent $ftpSchedule {
    set node [lindex $ftpEvent 0]
    set start [lindex $ftpEvent 1]
    set stop [lindex $ftpEvent 2]
    $ns at $start "\$ftp$node start"
    $ns at $stop "\$ftp$node stop"
}

# Finalize Simulation
$ns at 900.0 "finish"

# Start the Simulation
puts "Start of simulation.."
$ns run
