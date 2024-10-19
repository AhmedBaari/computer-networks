BEGIN{
st1=0
ft1=0
throughput1=0
delay1=0
flag1=0
data1=0
}
 
{
if($1=="r" && $4==5)#http
{
data1+=$6
if(flag1==0)
{
st1=$2
flag1=1
}
if(flag1==1)
{
ft1=$2
}
}
}

END{
printf("**********HTTP***********\n")
printf("Start time %f\n",st1)
printf("End time %f\n",ft1)
printf("Data %f\n",data1)
delay1=ft1-st1
throughput1=data1/delay1
printf("Throughput %f\n",throughput1)
printf("Delay %f\n",delay1)
}
