$cpu_busy = Get-WmiObject -Class win32_processor -ErrorAction Stop | Measure-Object -Property LoadPercentage -Average | Select-Object Average).Average
$hostname = $env:COMPUTERNAME
$timestamp = "$([DateTimeOffset]::Now.ToUnixTimeMilliseconds())000000"
"cpu_percent,host=$hostname,script=cpu_windows_ps1 cpu_busy=$(cpu_busy) $timestamp"