#!/bin/pwsh
$stat1=$(Get-Content /proc/stat -First 1).Split(" ")
$fullcpu1=0
for ($i=2; $i -le $stat1.count; $i++){
    $fullcpu1=$fullcpu1+ [int]$stat1[$i]
}
Start-Sleep 1
$stat2=$(Get-Content /proc/stat -First 1).Split(" ")

$fullcpu2=0
for ($j=2; $j -le $stat2.count; $j++){
    $fullcpu2=$fullcpu2+ [int]$stat2[$j]
}
$delta=$fullcpu2-$fullcpu1
$idle=[int]$stat2[5]-[int]$stat1[5]

$cpu_busy=(1-($idle/$delta))*100
$cpu_busy=[math]::Round($cpu_busy, 2)
$timestamp = (date +%s%N) 
$scriptname = $MyInvocation.MyCommand.Name
$hostname = [System.Net.Dns]::GetHostName()

"cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"