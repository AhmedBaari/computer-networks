#create a simulator object 
set ns [new Simulator]

#create a trace file, this file is for logging purpose 
set tracefile [open wired.tr w]
$ns trace-all $tracefile

#create a animation infomration or NAM file creation
set namfile [open wired.nam w]
$ns namtrace-all $namfile

#create nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#creation of link between nodes with DropTail Queue
#Droptail means Dropping the tail.
$ns duplex-link $n0 $n1 5Mb 2ms DropTail
$ns duplex-link $n2 $n1 10Mb 5ms DropTail
$ns duplex-link $n1 $n4 3Mb 10ms DropTail
$ns duplex-link $n4 $n3 100Mb 2ms DropTail
$ns duplex-link $n4 $n5 4Mb 10ms DropTail

#creation of Agents
#node 0 to Node 3
set udp [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $n0 $udp
$ns attach-agent $n3 $null
$ns connect $udp $null

#creation of TCP Agent
set tcp [new Agent/TCP]
set sink [new Agent/TCPSink]
$ns attach-agent $n2 $tcp
$ns attach-agent $n5 $sink
$ns connect $tcp $sink

#creation of Application CBR, FTP
#CBR - Constant Bit Rate (Example nmp3 files that have a CBR or 192kbps, 320kbps, etc.)
#FTP - File Transfer Protocol (Ex: To download a file from a network)
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $udp

set ftp [new Application/FTP]
$ftp attach-agent $tcp

#Start the traffic 
$ns at 1.0 "$cbr start"
$ns at 2.0 "$ftp start"

$ns at 10.0 "finish"

#the following procedure will be called at 10.0 seconds 
proc finish {} {
 global ns tracefile namfile
 $ns flush-trace
 close $tracefile
 close $namfile
 exit 0
}

puts "Simulation is starting..."
$ns run