BEGIN {
    send=0;
    received=0;
    dropped=0;
    start=1.0;
    stop=3.0;
}
{
    if($1=="/+/") {
            send++;
        }
    
    if($5=="tcp") {
        if($1=="r"){
        received++;
        }
    }
    
    if($1=="d") {
        dropped++;
    }

}  
END {
    if(send=="0" && received=="0") {
        print "empty trace file\t"
    }

    print "Number of Packets Received  " received
    print "Throughput =" (received*8)/(start-stop) "bits per second"
    print "Number of Packets Dropped = " dropped
}