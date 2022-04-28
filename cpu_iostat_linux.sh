#!/bin/bash

timestamp=$(date +%s%N)
hostname=$(hostname | tr a-z A-Z)
scriptname=${0##*/}

cpu_busy=$(iostat | head -n 4|tail -n 1| awk '{print 100-$6}')
echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$(printf "%.2f" $cpu_busy) $timestamp"