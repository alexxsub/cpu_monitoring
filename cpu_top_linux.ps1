#!/bin/pwsh
$idle = ((top -n 1 -b)[2] | Select-String -Pattern ".*\s(\d+[,.]\d+).*id").Matches[0].Groups[1].Value -replace (',','.')
$cpu_busy = 100 - $idle

$timestamp = (date +%s%N) #nanosec like bash
$scriptname = $MyInvocation.MyCommand.Name
$hostname = [System.Net.Dns]::GetHostName()

"cpu_percent,host=$hostname,script=$scriptname cpu_busy=$cpu_busy $timestamp"
