
#!/usr/bin/env python3
import sys,time,os

def cpu_calc():

    '''
        https://www.linuxhowtos.org/manpages/5/proc.htm
        Данные тут отображают количество времени, которое CPU тратит на выполнение 
        различных задач. Эти данные (time units),
        предоставлены как USER_HZ – сотые доли секунды.

        2– user: обычные процессы, которые выполняются в user mode
        3– nice: процессы с nice (приоритезация) в user mode (unix) Включает guest_nice (Linux)
        4– system: процессы в kernel mode
        5– idle: время в простое(ЦПУ простаивает)
        6– iowait: ожидание операций I/O (ввода/вывода) не входит в idle  https://github.com/torvalds/linux/blob/447976ef4fd09b1be88b316d1a81553f1aa7cd07/kernel/sched/cputime.c#L244
        7– irq: обработка аппаратных прерываний
        8– softirq: обработка программных прирываний многозадачности
        9– steal: “украденное” время, потраченное другими операционными системами при использовании виртуализации(Linux 2.6.11+)
        10– guest: обработка “гостевых” (виртуальных) процессоров(Linux 2.6.14+)
        11- guest_nice: обработка “гостевых” (виртуальных) nice процессоров (Linux 3.2+)
        
        cpu  19753860 2050 94864 179785312 13010 0 267715 0 0 0
        cpu  19753860 2050 94866 179786112 13010 0 267716 0 0 0
        
        '''
# читаем /proc/stat  файл, если есть.
    try:
        filestat = '/proc/stat'
        with open(filestat, 'r') as procfile:
            cputimes = procfile.readline()
            uptime = 0
            cpus=cputimes.split(' ')
            idle=int(cpus[5])
            for t in cpus[2:]:
                uptime += int(t)
            return([uptime,uptime-idle])
    except IOError as e:
        print('ERROR: %s' % e)
        sys.exit(3)
#Вычисляем разницу значений с интервалом        
def cpu_percent(interval=None):
    cpu1=cpu_calc()
    time.sleep(interval)
    cpu2=cpu_calc()
#дельта занят к дельте аптайм
    return(round(((cpu2[1]-cpu1[1])/(cpu2[0]-cpu1[0]))*100,2))
    
def main():
    cpu_busy = cpu_percent(interval=1)    
    hostname = os.uname()[1].upper()
    timestamp = time.time_ns()
    scriptname=os.path.basename(sys.argv[0])
    print(f"cpu_percent,host={hostname},script={scriptname} cpu_busy={cpu_busy} {timestamp}")


if __name__ == "__main__":
    main()
