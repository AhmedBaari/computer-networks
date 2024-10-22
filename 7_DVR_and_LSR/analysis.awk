BEGIN {
    st1 = 0
    ft1 = 0
    throughput1 = 0
    delay1 = 0
    flag1 = 0
    data1 = 0
}

{
    event = $1      # Event type (send/receive/etc.)
    time = $2       # Event time
    flowID = $4     # Flow ID (used to identify HTTP traffic)
    size = $6       # Packet size

    if (event == "r" && flowID == 7) {  # Check for receive event in HTTP flow (flowID 7)
        data1 += size

        if (flag1 == 0) {
            st1 = time
            flag1 = 1
        }
        
        ft1 = time
    }
}

END {
    printf("********** HTTP ***********\n")
    printf("Start Time: %f\n", st1)
    printf("End Time: %f\n", ft1)
    printf("Data: %f bytes\n", data1)
    
    delay1 = ft1 - st1
    throughput1 = data1 / delay1
    
    printf("Throughput: %f bytes/sec\n", throughput1)
    printf("Delay: %f sec\n", delay1)
}
