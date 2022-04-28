#!/bin/bash
# (c)2022, alexx sub

cpu_busy=`top -b -n 1 | head -n 3 | tail -n 1 | awk '{print 100-$8}'`

timestamp=$(date +%s%N)
hostname=$(hostname | tr a-z A-Z)
scriptname=${0##*/}

echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"