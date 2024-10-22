BEGIN {
    filesize1 = 0
    starttime1 = 0
    endtime1 = 0
    flag1 = 0
}

{
    if ($1 == "r" && $3 == 6) {
        if (flag1 == 0) {
            flag1 = 1
            starttime1 = $2
        }
        filesize1 += $6
        endtime1 = $2
        latency = endtime1 - starttime1
        bandwidth1 = filesize1 / latency
        printf "%f %f\n", endtime1, bandwidth1 >> "file3.xg"
    }
}

END {
    print("\n\nFinal Values..")
    print("\nfilesize: ", filesize1)
    latency = endtime1 - starttime1
    print("\nlatency: ", latency)
    print("\nThroughput (Mbps): ", (filesize1 / latency) / 10^6)
}
