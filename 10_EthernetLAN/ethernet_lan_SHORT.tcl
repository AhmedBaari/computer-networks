set ns [new Simulator]

set tr [open "LAN.tr" w]
$ns trace-all $tr

set nam [open "LAN.nam" w]
$ns namtrace-all $nam

set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

$ns make-lan "$n1 $n2 $n3 $n4 $n5 $n6" 0.2Mb 20ms LL Queue/DropTail Mac/802_3

set tcpsendagent1 [new Agent/TCP]
set tcpsendagent2 [new Agent/TCP]

set tcprecvagent1 [new Agent/TCPSink]
set tcprecvagent2 [new Agent/TCPSink]

$ns attach-agent $n1 $tcpsendagent1
$ns attach-agent $n2 $tcpsendagent2

$ns attach-agent $n6 $tcprecvagent1
$ns attach-agent $n6 $tcprecvagent2

set app1 [new Application/FTP]
set app2 [new Application/FTP]

$app1 attach-agent $tcpsendagent1
$app2 attach-agent $tcpsendagent2

#As soon as you create agents make sure i connect them

$ns connect $tcpsendagent1 $tcprecvagent1
$ns connect $tcpsendagent2 $tcprecvagent2

$ns at 0.1 "$app1 start"
$ns at 0.4 "$app2 start"




proc finish { } {
global ns tr nam
$ns flush-trace
close $tr
close $nam
#exec nam namfile_tcp_ls.nam &
exec gawk -f anal.awk LAN.tr &
exit 0
}

$ns at 10 "finish"

$ns run



