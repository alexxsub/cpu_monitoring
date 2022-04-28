#!/bin/bash


hostname=$(hostname | tr a-z A-Z) 
scriptname=${0##*/} 


STAT=$(cat /proc/stat | grep "cpu " | tr -d cpu)
STAT=($STAT)
sleep 1
timestamp=$(date +%s%N) 
STAT1=$(cat /proc/stat | grep "cpu " | tr -d cpu)
STAT1=($STAT1)

STATD=( )
for ((i = 0; i < ${#STAT[*]}; i++))
    {
        ST=$(echo "${STAT1[i]}-${STAT[i]}"|bc)
        STATD+=($ST)
    }

for i in "${STATD[@]}"
do
    let "TOTAL += $i"
done

cpu_busy=$(printf '%.2f\n' "$(echo "scale=2; ($TOTAL-${STATD[3]}-${STATD[4]})*100/$TOTAL"| bc)")


echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"