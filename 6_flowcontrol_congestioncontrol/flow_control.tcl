#creating a simulator object
set ns [ new Simulator ]
#creating trace file
set tf [open trace1.tr w]
$ns trace-all $tf
#creating nam file
set nf [open opnam.nam w]
$ns namtrace-all $nf

#creating variables for throughput files
set ft1 [open "Sender1_throughput" "w"]
set ft2 [open "Sender2_throughput" "w"]
set ft3 [open "Sender3_throughput" "w"]
set ft4 [open "Total_throughput" "w"]

#creating variables for bandwidth files
set fb1 [open "Bandwidth1" "w"] 
set fb2 [open "Bandwidth2" "w"]
set fb3 [open "Bandwidth3" "w"]
set fb4 [open "TotalBandwidth" "w"]

#finish procedure to call nam and xgraph
proc finish {} {
 global ns nf ft1 ft2 ft3 ft4 fb1 fb2 fb3 fb4 
 $ns flush-trace
 #closing all files
 close $nf
 close $ft1 
 close $ft2
 close $ft3
 close $ft4 
 close $fb1 
 close $fb2 
 close $fb3 
 close $fb4 
 #executing graphs
 exec xgraph Sender1_throughput Sender2_throughput Sender3_throughput Total_throughput &
 exec xgraph Bandwidth1 Bandwidth2 Bandwidth3 TotalBandwidth &
 puts "running nam..." 
 exec nam opnam.nam &
 #exec awk -f analysis.awk trace1.tr
 exit 0
}

#record procedure to calculate total bandwidth and throughput
proc record {} {
 global null1 null2 null3 ft1 ft2 ft3 ft4 fb1 fb2 fb3 fb4 
 global ftp1 smtp1 http1

 set ns [Simulator instance]
 set time 0.1
 set now [$ns now]
 
 set bw0 [$null1 set bytes_]
 set bw1 [$null2 set bytes_]
 set bw2 [$null3 set bytes_]

 set totbw [expr $bw0 + $bw1 + $bw2]
 puts $ft4 "$now [expr $totbw/$time*8/1000000]"

 puts $ft1 "$now [expr $bw0/$time*8/1000000]"
 puts $ft2 "$now [expr $bw1/$time*8/1000000]"
 puts $ft3 "$now [expr $bw2/$time*8/1000000]"

 puts $fb1 "$now [expr $bw0]"
 puts $fb2 "$now [expr $bw1]"
 puts $fb3 "$now [expr $bw2]"
 puts $fb4 "$now [expr $totbw]"

 $null1 set bytes_ 0
 $null2 set bytes_ 0
 $null3 set bytes_ 0

 $ns at [expr $now+$time] "record"
 }
 
#creating 10 nodes
for {set i 0} {$i < 10} {incr i} {
 set n($i) [$ns node]
}

#creating duplex links
$ns duplex-link $n(0) $n(1) 1Mb 10ms DropTail
$ns duplex-link $n(0) $n(3) 1.5Mb 10ms RED
$ns duplex-link $n(1) $n(2) 1Mb 10ms DropTail
$ns duplex-link $n(2) $n(7) 2Mb 10ms RED
$ns duplex-link $n(7) $n(8) 2Mb 10ms DropTail
$ns duplex-link $n(8) $n(9) 2Mb 10ms RED
$ns duplex-link $n(3) $n(5) 1Mb 10ms DropTail
$ns duplex-link $n(5) $n(6) 1Mb 10ms RED
$ns duplex-link $n(6) $n(4) 1Mb 10ms DropTail
$ns duplex-link $n(4) $n(7) 1Mb 10ms RED

#orienting links
$ns duplex-link-op $n(0) $n(1) orient right-up
$ns duplex-link-op $n(1) $n(2) orient right
$ns duplex-link-op $n(0) $n(3) orient right-down
$ns duplex-link-op $n(2) $n(7) orient right-down
$ns duplex-link-op $n(7) $n(8) orient right-up
$ns duplex-link-op $n(5) $n(6) orient right
$ns duplex-link-op $n(6) $n(4) orient left-up
$ns duplex-link-op $n(3) $n(5) orient right-down
$ns duplex-link-op $n(4) $n(7) orient right-up
$ns duplex-link-op $n(8) $n(9) orient right-down

proc ftp_traffic {node0 node9 } { 
 global ns null1 tcp1 ftp1
 set tcp1 [new Agent/TCP] 
 set null1 [new Agent/TCPSink] 
 $ns attach-agent $node0 $tcp1
 $ns attach-agent $node9 $null1
 $ns connect $tcp1 $null1
 set ftp1 [new Application/FTP] 
 $ftp1 attach-agent $tcp1  
 $ns at 1.0 "$ftp1 start" 
 $ns at 3.2 "$ftp1 stop"  
 }  
ftp_traffic $n(0) $n(8)

proc smtp_traffic {node0 node3 } { 
 global ns null2 tcp2 smtp1
 set tcp2 [new Agent/TCP] 
 set null2 [new Agent/TCPSink] 
 $ns attach-agent $node0 $tcp2
 $ns attach-agent $node3 $null2
 $ns connect $tcp2 $null2
 set smtp1 [new Application/Traffic/Exponential] 
 $smtp1 attach-agent $tcp2 
 $ns at 2.0 "$smtp1 start" 
 $ns at 3.8 "$smtp1 stop"  
 }  
smtp_traffic $n(3) $n(6)
 
proc http_traffic {node1 node7 } {  
 global ns null3 tcp3 http1
 set tcp3 [new Agent/TCP] 
 set null3 [new Agent/TCPSink] 
 $ns attach-agent $node1 $tcp3
 $ns attach-agent $node7 $null3
 $ns connect $tcp3 $null3
 set http1 [new Application/Traffic/Exponential] 
 $http1 attach-agent $tcp3  
 $ns at 0.2 "$http1 start" 
 $ns at 3.2 "$http1 stop"  }  
http_traffic $n(0) $n(7)
 
#scheduling events
$ns at 0.5 "record"
$ns at 0.2 "$ns trace-annotate \"Starting HTTP from 0 to 7\""
$ns at 1.0 "$ns trace-annotate \"Starting FTP from 0 to 8\""
$ns at 2.0 "$ns trace-annotate \"Starting SMTP from 3 to 6\""
$ns at 5.0 "finish"
$ns run

