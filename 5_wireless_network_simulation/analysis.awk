BEGIN {
    seqno = -1; 
    droppedPackets = 0;
    receivedPackets = 0;
    totalDelay = 0;
    validPackets = 0;
}

{
    if($4 == "AGT" && $1 == "s") {
        seqno = $6 > seqno ? $6 : seqno;
        start_time[$6] = $2;
    } 
    else if($4 == "AGT" && $1 == "r") {
        receivedPackets++;
        totalDelay += $2 - start_time[$6];
        validPackets++;
    } 
    else if($1 == "D" && $7 == "tcp" && $8 > 512) {
        droppedPackets++;
    }
}

END {
    generatedPackets = seqno + 1;
    packetDeliveryRatio = (receivedPackets / generatedPackets) * 100;
    avgEndToEndDelay = (validPackets > 0) ? (totalDelay / validPackets) * 1000 : 0;

    print "\nGenerated Packets = " generatedPackets;
    print "Received Packets = " receivedPackets;
    print "Packet Delivery Ratio = " packetDeliveryRatio "%";
    print "Total Dropped Packets = " droppedPackets;
    print "Average End-to-End Delay = " avgEndToEndDelay " ms\n";
}
