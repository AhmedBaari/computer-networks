# Creating a simulator object
set ns [new Simulator]

# Creating trace and nam files
set tf [open trace1.tr w]
$ns trace-all $tf
set nf [open opnam.nam w]
$ns namtrace-all $nf

# Creating variables for throughput and bandwidth files
set ft [open "Throughput" "w"]
set fb [open "Bandwidth" "w"]

# Creating fewer nodes
for {set i 0} {$i < 3} {incr i} {
    set n($i) [$ns node]
}

# Creating duplex links
$ns duplex-link $n(0) $n(1) 1Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 1Mb 10ms RED

# HTTP traffic setup in main program
set tcp [new Agent/TCP]
set null [new Agent/TCPSink]
$ns attach-agent $n(0) $tcp
$ns attach-agent $n(2) $null
$ns connect $tcp $null

set http [new Application/Traffic/Exponential]
$http attach-agent $tcp

# Start and stop HTTP traffic
$ns at 0.2 "$http start"
$ns at 3.2 "$http stop"

# Finish procedure to call nam and xgraph
proc finish {} {
    global ns nf ft fb
    $ns flush-trace
    close $nf
    close $ft
    close $fb
    exec xgraph Throughput &
    exec xgraph Bandwidth &
    puts "running nam..."
    exec nam opnam.nam &
    exit 0
}

# Record procedure for calculating bandwidth and throughput
proc record {} {
    global ft fb null
    set ns [Simulator instance]
    set time 0.1
    set now [$ns now]
    set bw [$null set bytes_]
    puts $ft "$now [expr $bw/$time*8/1000000]"
    puts $fb "$now [expr $bw]"
    $null set bytes_ 0
    $ns at [expr $now+$time] "record"
}

# Scheduling events
$ns at 0.5 "record"
$ns at 5.0 "finish"
$ns run
