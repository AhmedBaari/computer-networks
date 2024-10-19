#creating a simulator object
set ns [ new Simulator ]
$ns color 3 Green

#creating trace file
set tf [open TCPcc.tr w]
$ns trace-all $tf

#creating nam file
set nf [open TCPcc.nam w]
$ns namtrace-all $nf

#creating throughput files
set ft1 [open vegas_Sender_throughput w]
set ft2 [open Reno_Sender_throughput w]
set ft3 [open Newreno_Sender_throughput w]
set ft4 [open Sack1_Sender_throughput w]
set ft5 [open Tahoe_Sender_throughput w]

#creating bandwidth files
set fb1 [open vegas_Sender_bandwidth w]
set fb2 [open Reno_Sender_bandwidth w]
set fb3 [open Newreno_Sender_bandwidth w]
set fb4 [open Sack1_Sender_bandwidth w]
set fb5 [open Tahoe_Sender_bandwidth w]

#finish procedure to call nam and xgraph
proc finish {} {
 global ns nf ft1 ft2 ft3 ft4 ft5 fb1 fb2 fb3 fb4 fb5
 $ns flush-trace
 #closing all files
 close $nf
 close $ft1
 close $ft2
 close $ft3
 close $ft4
 close $ft5
 close $fb1
 close $fb2
 close $fb3
 close $fb4
 close $fb5
#executing graphs
 exec xgraph vegas_Sender_throughput Reno_Sender_throughput Newreno_Sender_throughput Sack1_Sender_throughput Tahoe_Sender_throughput &
 exec xgraph vegas_Sender_bandwidth Reno_Sender_bandwidth Newreno_Sender_bandwidth Sack1_Sender_bandwidth Tahoe_Sender_bandwidth &
 puts "running nam..."
 exec nam TCPcc.nam &
#exec awk -f analysis.awk trace1.tr &
 exit 0
}

#record procedure to calculate total bandwidth and throughput
proc record {} {
 global null1 null2 null3 null4 null5 ft1 ft2 ft3 ft4 ft5 fb1 fb2 fb3 fb4 fb5
 global http1 http2 http3 http4 http5
 set ns [Simulator instance]
 set time 0.1
 set now [$ns now]
 set bw1 [$null1 set bytes_]
 set bw2 [$null2 set bytes_]
 set bw3 [$null3 set bytes_]
 set bw4 [$null4 set bytes_]
 set bw5 [$null5 set bytes_]
 puts $ft1 "$now [expr $bw1/$time*8/1000000]"
 puts $ft2 "$now [expr $bw2/$time*8/1000000]"
 puts $ft3 "$now [expr $bw3/$time*8/1000000]"
 puts $ft4 "$now [expr $bw4/$time*8/1000000]"
 puts $ft5 "$now [expr $bw5/$time*8/1000000]"
 puts $fb1 "$now [expr $bw1]"
 puts $fb2 "$now [expr $bw2]"
 puts $fb3 "$now [expr $bw3]"
 puts $fb4 "$now [expr $bw4]"
 puts $fb5 "$now [expr $bw5]"
 $null1 set bytes_ 0
 $null2 set bytes_ 0
 $null3 set bytes_ 0
 $null4 set bytes_ 0
 $null5 set bytes_ 0
 $ns at [expr $now+$time] "record"
 }
#creating 10 nodes
for {set i 0} {$i < 6} {incr i} {
 set n($i) [$ns node]
}

#creating duplex links
$ns duplex-link $n(0) $n(1) 10Kb 10ms DropTail
$ns duplex-link $n(0) $n(3) 100Kb 10ms RED
$ns duplex-link $n(1) $n(2) 50Kb 10ms DropTail
$ns duplex-link $n(2) $n(5) 200Kb 10ms RED
$ns duplex-link $n(3) $n(4) 70Kb 10ms DropTail
$ns duplex-link $n(4) $n(5) 100Kb 10ms DropTail

#orienting links
$ns duplex-link-op $n(0) $n(1) orient right
$ns duplex-link-op $n(1) $n(2) orient right-down
$ns duplex-link-op $n(0) $n(3) orient left-down
$ns duplex-link-op $n(3) $n(4) orient right-down
$ns duplex-link-op $n(4) $n(5) orient right
$ns duplex-link-op $n(2) $n(5) orient left-down

set tcp1 [new Agent/TCP/Vegas]
set null1 [new Agent/TCPSink]
$ns attach-agent $n(0) $tcp1
$ns attach-agent $n(5) $null1
$ns connect $tcp1 $null1
set http1 [new Application/Traffic/Exponential]
$http1 attach-agent $tcp1

set tcp2 [new Agent/TCP/Reno]
set null2 [new Agent/TCPSink]
$ns attach-agent $n(1) $tcp2
$ns attach-agent $n(5) $null2
$ns connect $tcp2 $null2
set http2 [new Application/Traffic/Exponential]
$http2 attach-agent $tcp2

set tcp3 [new Agent/TCP/Newreno]
set null3 [new Agent/TCPSink]
$ns attach-agent $n(2) $tcp3
$ns attach-agent $n(5) $null3
$ns connect $tcp3 $null3
set http3 [new Application/Traffic/Exponential]
$http3 attach-agent $tcp3

set tcp4 [new Agent/TCP/Sack1]
set null4 [new Agent/TCPSink]
$ns attach-agent $n(3) $tcp4
$ns attach-agent $n(4) $null4
$ns connect $tcp4 $null4
set http4 [new Application/Traffic/Exponential]
$http4 attach-agent $tcp4

set tcp5 [new Agent/TCP]
set null5 [new Agent/TCPSink]
$ns attach-agent $n(3) $tcp5
$ns attach-agent $n(5) $null5
$ns connect $tcp5 $null5
set http5 [new Application/Traffic/Exponential]
$http5 attach-agent $tcp5  

#scheduling events
$ns at 0.5 "record"
$ns at 0.2 "$ns trace-annotate \"Starting HTTP from 0 to 5\""

$ns at 0.2 "$n(0) color \"green\""
$ns at 0.2 "$n(5) color \"green\""
$ns at 0.2 "$http1 start"
$ns at 3.2 "$http1 stop"

$ns at 3.2 "$n(1) color \"green\""
$ns at 3.2 "$n(5) color \"green\""
$ns at 3.2 "$http2 start"
$ns at 6.2 "$http2 stop"

$ns at 6.2 "$n(2) color \"green\""
$ns at 6.2 "$n(5) color \"green\""
$ns at 6.2 "$http3 start"
$ns at 9.2 "$http3 stop"

$ns at 9.2 "$n(3) color \"green\""
$ns at 9.2 "$n(4) color \"green\""
$ns at 9.2 "$http4 start"
$ns at 12.2 "$http4 stop"

$ns at 12.2 "$n(3) color \"green\""
$ns at 12.2 "$n(5) color \"green\""
$ns at 12.2 "$http5 start"
$ns at 15.2 "$http5 stop"
 
$ns at 16.0 "finish"
$ns run