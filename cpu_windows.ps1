#Функция конвертации кодировки
function Convert ([string]$From, [string]$To){
    Begin
    {
        $encFrom = [System.Text.Encoding]::GetEncoding($from)
        $encTo = [System.Text.Encoding]::GetEncoding($to)
    }
    Process
    {
        $encFrom.GetString($encTo.GetBytes($_))
    }
}
#функция вычисления % использования процессора
function cpu_busy {
    $lang = ([CultureInfo]::InstalleduICulture).Name
    if ($lang -match "ru-") {
        $cpucounter = "\процессор(_total)\% загруженности процессора" | Convert "UTF-8" "windows-1251"
    }
    else {
        $cpucounter = "\processor(_total)\% processor time"
    }
    [Math]::Round($((Get-Counter $cpucounter -SampleInterval 1 -ErrorAction SilentlyContinue).CounterSamples.CookedValue),2) 
}


$hostname = $env:COMPUTERNAME
#Варианты перевода в наносекунды
#$timestamp=[int64](([datetime]::UtcNow)-(get-date "1/1/1970")).TotalMilliseconds*1000000
#$timestamp="$([int64](Get-Date -UFormat %s))000000"
$timestamp = "$([DateTimeOffset]::Now.ToUnixTimeMilliseconds())000000"
"cpu_percent,host=$hostname,script=cpu_windows_ps1 cpu_busy=$(cpu_busy) $timestamp"