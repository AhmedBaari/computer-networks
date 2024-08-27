BEGIN {
    sent = 0;
    received = 0;
    dropped = 0;

    start = 1.0;
    stop = 3.0;
}

{
    if ($1 == "/+/") {
        sent++;
    }

    if ($5 == "tcp") {
        if ($1 == "r") {
            received++;
        }
    }

    if ($1 == "d") {
        dropped++;
    }
}

END {
    if(sent=="0" && received=="0") {
        print "Empty trace file\t"
    }

    print "Number of packets R: " received
    print "Throughput: " (received*8)/(start-stop) "bps"
    print "Dropped: " dropped
}