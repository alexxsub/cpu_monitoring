#!/usr/bin/env python3
# python3 -m pip install --user --upgrade pip
# python3 -m pip install --user virtualenv
#
# windows 
# python3 -m venv env_win
# .\env_win\Scripts\activate
# deactivate 
# linux
# python3 -m venv env 
# source env/bin/activate
# deactivate 
import psutil,time,sys,os


def cpu_calc():

    return psutil.cpu_percent(interval=1)


def main():
    if os.name == 'nt':
        hostname= os.environ['COMPUTERNAME'].upper() # для windows
    elif os.name == 'posix':
        hostname = os.uname()[1].upper()  # для linux
    
    cpu_busy = cpu_calc()
    timestamp = time.time_ns()
    scriptname=os.path.basename(sys.argv[0])
    print(f"cpu_percent,host={hostname},script={scriptname} cpu_busy={cpu_busy} {timestamp}")



if __name__ == "__main__":
    main()
