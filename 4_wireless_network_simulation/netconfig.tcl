set val(chan)           Channel/WirelessChannel   ;
set val(prop)           Propagation/TwoRayGround ;
set val(netif)          Phy/WirelessPhy        ;
set val(mac)            Mac/802_11         ;
set val(ifq)            Queue/DropTail/PriQueue ;
set val(ll)             LL                       ;
set val(ant)            Antenna/OmniAntenna    ;
set val(ifqlen)         50                     ;
set val(nn)             6                   ;
set val(rp)             AODV                   ;
set val(x)  		500 			  ;
set val(y) 		500  			  ;

$ns node-config \
  -adhocRouting $val(rp) \
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