BEGIN {
    seqno = -1;

    droppedPackets = 0;
    receivedPackets = 0;
    validPackets = 0;

    totalDelay = 0;
}

{
    if ($4 == "AGT" && $1 == "s") {
        seqno = $6 > seqno ? $6 : seqno;
        start_time[$6] = $2;
    }
    else if ($4 == "AGT" && $1 == "r") {
        receivedPackets++;

        totalDelay += $2 - start_time[$6];
        validPackets++;
    }
    else if ($1 == "D" && $7 == "") {
        
    }
}

