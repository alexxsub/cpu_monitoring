import wmi,time,socket
def get_cpu():
    a = wmi.WMI()
    cpuArr = a.Win32_Processor()
    hostname = socket.gethostname()
    ts=time.time_ns()
    i=0
    cpus=''
    for cpu in cpuArr:
        i+=1
        if i>1:cpus=f'{cpus},'
        cpus=f'{cpus}Cpu{i}={cpu.loadPercentage}'
    fluxline = 	f'cpu_usage,host={hostname} {cpus} {ts}'
    return fluxline

if __name__ == "__main__":
    print(get_cpu())