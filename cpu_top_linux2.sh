#!/bin/bash

#us — (User CPU time) время, затраченное на работу программ пользователей
#sy — (System CPU time) время, затраченное на работу процессов ядра
#ni — (Nice CPU time) время, затраченное на работу программ с измененным приоритетом
#id — простой процессора
#wa — (iowait) время, затраченное на завершение ввода-вывода
#hi — (Hardware IRQ) время, затраченное на обработку hardware-прерываний
#si — (Software Interrupts) время, затраченное на работу обработку software-прерываний (network)
#st — (Steal Time) время, «украденное» гипервизором у этой виртуальной машины для других задач (например работа другой виртуальной машины)или# top -SIt

timestamp=$(date +%s%N)
hostname=$(hostname | tr a-z A-Z)
scriptname=${0##*/}

cpu_busy=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$(printf "%.2f" $cpu_busy) $timestamp"