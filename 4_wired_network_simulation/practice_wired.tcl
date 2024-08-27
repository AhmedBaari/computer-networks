set ns [new Simulator]

# tracefile 
set tracefile [open wired.tr w]
$ns trace-all $tracefile 

# animator file
set namfile [open wired.nam w]
$ns namtrace-all $namfile 

# Create the nodes 
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

# Create the links  
$ns duplex-link $n0 $n1 5Mb 10ms Droptail 
$ns duplex-link $n1 $n2 6Mb 9ms Droptail 
$ns duplex-link $n1 $n4 7Mb 8ms Droptail 
$ns duplex-link $n4 $n3 8Mb 7ms Droptail 
$ns duplex-link $n4 $n5 9Mb 6ms Droptail 

# Agents 
# UDP 
set udp [new Agent/UDP]
set null [new Agent/Null]

$ns attach-agent $n0 $udp 
$ns attach-agent $n3 $null 

# IMPORTANT ---
$ns connect $udp $null

# TCP
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $TCP 
$ns attach-agent $n5 $sink 

$ns connect $tcp $sink

# Create Traffic 
#CBR ---
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set ftp [new Application/FTP]
$ftp attach-agent $tcp 

# Start the traffic 
$ns at 1.0 "$cbr start"
$ns at 5.0 "$ftp start"
$ns at 10.0 "finish"

proc finish {} {
global ns namfile tracefile
$ns flush-trace
close $tracefile
close $namfile
exit 0
}

puts "Simulation starting
$ns run