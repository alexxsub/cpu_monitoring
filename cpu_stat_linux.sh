#!/bin/bash

# RS - переменная разделитель записей
# 2– user: обычные процессы, которые выполняются в user mode
# 3– nice: процессы с nice (приоритезация) в user mode
# 4– system: процессы в kernel mode
# 5– idle: время в простое(ЦПУ простаивает)
# 6– iowait: ожидание операций I/O (ввода/вывода)
# 7– irq: обработка аппаратных прерываний
# 8– softirq: обработка программных прирываний многозадачности
# 9– steal: “украденное” время, потраченное другими операционными системами при использовании виртуализации; 
# 10– guest: обработка “гостевых” (виртуальных) процессоров
# 11- guest_nice: обработка “гостевых” (виртуальных) nice процессоров

# cpu  19753860 2050 94864 179785312 13010 0 267715 0 0 0
# cpu  19753860 2050 94866 179786112 13010 0 267716 0 0 0

timestamp=$(date +%s%N) #метка времени в наносекундах
hostname=$(hostname | tr a-z A-Z) # переводим в верхний регистра
scriptname=${0##*/} # имя скрипта ${0} - убираем лишнее ##*/, например ./ и путь

cpu_busy=$(cat <(grep 'cpu ' /proc/stat | \
    awk '{ split($0,cpus," ");\
    i = 2; \
    do { total+=cpus[i]; i+=1; } \
    while(i < length(cpus));\
    idle=$5} \
    END {print total,total-idle}')\
    <(sleep 1 && 
    grep 'cpu ' /proc/stat | \
    awk '{ split($0,cpus," ");\
    i = 2; \
    do { total+=cpus[i]; i+=1; } \
    while(i < length(cpus));\
    idle=$5} \
    END {print total,total-idle}')\
    | awk -v RS="" '{printf "%.2f\n", 100*($4-$2)/($3-$1)}') 
  
    echo "cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"