# VERIFICATION PENDING
set ns [new Simulator]

# trace and nam
set tf [open TCPcc.tr w]
$ns trace-all $tf
set nf [open TCPcc.nam w]
$ns namtrace-all $nf

# Throughput and bandwidth files 
set ft [open Tahoe_Sender_throughput w]
set fb [open Tahoe_Sender_bandwidth w]

# Finish procedure 
proc finish {} {
    global ns nf ft fb
    $ns flush-trace
    close $nf
    close $ft
    close $fb
    exec xgraph Tahoe_Sender_throughput &
    exec xgraph Tahoe_Sender_bandwidth &
    exec nam TCPcc.nam &
    exit 0
}


# Creating nodes
for {set i 0} {$i < 6} {incr i} {
    set n($i) [$ns node]
}

# Creating duplex links between nodes
$ns duplex-link $n(0) $n(1) 10Kb 10ms DropTail
$ns duplex-link $n(0) $n(3) 100Kb 10ms RED
$ns duplex-link $n(1) $n(2) 50Kb 10ms DropTail
$ns duplex-link $n(2) $n(5) 200Kb 10ms RED
$ns duplex-link $n(3) $n(4) 70Kb 10ms DropTail
$ns duplex-link $n(4) $n(5) 100Kb 10ms DropTail

# Orienting links (not important)
$ns duplex-link-op $n(0) $n(1) orient right


# Congestion control agents setup
# Vegas, Reno, Newreno, Sack
# Tahoe is presented by "Agent/TCP"
set tcp [new Agent/TCP]  ;# "Agent/TCP/Reno", "Agent/TCP/Vegas", etc.
set null [new Agent/TCPSink]
$ns attach-agent $n(3) $tcp
$ns attach-agent $n(5) $null
$ns connect $tcp $null

# App
set http [new Application/Traffic/Exponential]
$http attach-agent $tcp

# record bandwidth and throughput
proc record {} {
    global null ft fb
    set ns [Simulator instance]
    set time 0.1
    set now [$ns now]
    set bw [$null set bytes_]
    puts $ft "$now [expr $bw/$time*8/1000000]"
    puts $fb "$now [expr $bw]"
    $null set bytes_ 0
    $ns at [expr $now + $time] "record"
}

# Schedule events
$ns at 0.5 "record"
$ns at 0.2 "$http start"
$ns at 15.2 "$http stop"
$ns at 16.0 "finish"
$ns run