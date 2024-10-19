BEGIN {
    drop = 0
    recv = 0
    starttime1 = 0
    endtime1 = 0
    latency1 = 0
    filesize1 = 0
    starttime2 = 0
    endtime2 = 0
    latency2 = 0
    filesize2 = 0
    flag1 = 0
    bandwidth1 = 0
}

{
    if ($1 == "r" && $3 == 6) {
        if (flag1 == 0) {
            flag1 = 1
            starttime1 = $2
        }
        filesize1 += $6
        endtime1 = $2
    }
}

END {
    latency1 = endtime1 - starttime1
    if (latency1 > 0) {
        bandwidth1 = filesize1 / latency1
        printf "%f %f\n", endtime1, bandwidth1 >> "file3.xg"
    }

    print("\n\n\n Final Values..")
    print("\n\nfilesize : ", filesize1)
    print("\nlatency :", latency1)
    print("\nThroughput (Mbps):", bandwidth1 / 1e6)
}
