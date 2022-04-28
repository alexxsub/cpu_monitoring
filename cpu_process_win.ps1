#Set-ExecutionPolicy Unrestricted

function Get-CPUPercent {
    $CPUPercent = @{
        Name = 'CPUPercent';Expression = {
            $TotalSec = (New-TimeSpan -Start $_.StartTime).TotalSeconds
            [Math]::Round( ($_.CPU * 100 / $TotalSec), 2)
        }
    }
Get-Process | Select-Object -Property ID, Name, $CPUPercent, Description | Sort-Object -Property CPUPercent -Descending | Select-Object -First 20
}
 
Get-CPUPercent