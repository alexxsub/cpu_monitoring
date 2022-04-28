#!/bin/bash

timestamp=$(date +%s%N) #метка времени в наносекундах
hostname=$(hostname | tr a-z A-Z) # переводим в верхний регистра
scriptname=${0##*/} # имя скрипта ${0} - убираем лишнее ##*/, например ./ и путь

stat1=($(head -n 1 /proc/stat))
fullcpu1="${stat1[@]:1}"
fullcpu1=$((${fullcpu1// /+}))

sleep 1

stat2=($(head -n 1 /proc/stat))
fullcpu2="${stat2[@]:1}"
fullcpu2=$((${fullcpu2// /+}))
fullcpu_delta=$((fullcpu2 - fullcpu1))
idle=$((stat2[4]- stat1[4]))
cpu_busy=$(bc<<<"scale=5;(1-$idle/$fullcpu_delta)*100")
cpu_busy=$(printf '%3.2f\n' $cpu_busy)

echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"
