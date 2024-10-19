BEGIN{
    drop=0
    recv=0
    starttime1=0
    endtime1=0
    latency1=0
    filesize1=0
    starttime2=0
    endtime2=0
    latency2=0
    filesize2=0
    flag0=0
    flag1=0
    bandwidth1=0
    bandwidth2=0
}

{

if($1=="r" && $3==6)
{
if(flag1=0)
{
flag1=1
starttime1=$2
}
filesize1+=$6
endtime1=$2
latency=endtime1-starttime1
bandwidth1=filesize1/latency
printf "%f %f\n", endtime1, bandwidth1 >> "file3.xg"

}

}
END{
print("\n\n\n Final Values..")
print("\n\nfilesize : ",filesize1)
latency=endtime1-starttime1
print("\nlatency :",latency)
bandwidth1=filesize1/latency
print("\n Throughput (Mbps):",bandwidth1/10^6)
}
