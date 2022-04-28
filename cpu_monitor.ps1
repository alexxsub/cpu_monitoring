
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

while (1) {
    Write-Progress -Activity "CPU busy" -Status "$(cpu_busy)%" -PercentComplete $(cpu_busy)
    Start-Sleep -s 1
}
