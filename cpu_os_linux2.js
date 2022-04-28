const os = require('os');
const path = require('path');
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));



class Metric {
    constructor() {
        this.cpuUsageMSDefault = 1000; // Период загрузки ЦП по умолчанию
        this.percentageDefault = true; // Считать в % по умолчанию
    }
  

  /*
    * Получить информацию о процессоре
    * @Returns {Object} информацию о процессоре
   */
   _getCPUInfo() {
    const cpus = os.cpus();
    let user = 0, nice = 0, sys = 0, idle = 0, irq = 0, total = 0;
 
    for (let cpu in cpus) { 
      const times = cpus[cpu].times;
      user += times.user;
      nice += times.nice;
      sys += times.sys;
      idle += times.idle;
      irq += times.irq;
    }
 
    total += user + nice + sys + idle + irq;
 
    return {
      idle,
      total
    }
  }
 
  /**
   * Получите загрузку ЦП за определенный период времени
   * @Param {Number} Options.ms [Период времени, по умолчанию 1000 мс, то есть 1 секунда]
   * @Param {Boolean} Options.percentage [true (возвращается в процентах) | false]
   * @returns { Promise }
   */
  async  getCPUUsage(options={}) {
    const that = this;
    let { cpuUsageMS, percentage } = options;
    cpuUsageMS = cpuUsageMS || that.cpuUsageMSDefault;
    percentage = percentage || that.percentageDefault;
    const t1 = that._getCPUInfo (); // информация о процессоре в момент времени t1
    await sleep(cpuUsageMS); //делаем паузу
    const t2 = that._getCPUInfo (); // информация о процессоре в момент времени t2
    const idle = t2.idle - t1.idle;  //считаем дельты
    const total = t2.total - t1.total;
    let usage = 1 - idle / total;
 
    if (percentage) usage = (usage * 100.0).toFixed(2); // с точностью до 2-х знаков
 
    return usage;
  }
}


const m = new Metric
const hostname = os.hostname()
const hrTime = process.hrtime()
const timestamp = Number(Date.now() + String(hrTime[1]).slice(3))
const scriptname = path.basename(__filename)
m.getCPUUsage().then(cpu_busy=>
 console.log(`cpu_percent,host=${hostname},script=${scriptname} cpu_busy=${cpu_busy} ${timestamp}`)    
)