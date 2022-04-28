#!/bin/bash

timestamp=$(date +%s%N)
hostname=$(hostname | tr a-z A-Z)
scriptname=${0##*/}

cpu_busy=$(top -bn 2 -d 0.01 | grep '^%Cpu' | tail -n 1 | awk '{print 100-$8}')
echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"