const os = require('os');
const libfs = require( 'fs' );
const path = require('path');
const sleep = ms => new Promise(resolve => setTimeout(resolve, ms));



class Metric {
    constructor() {
        this.cpuUsageMSDefault = 1000; // Период загрузки ЦП по умолчанию
        this.percentageDefault = true; // Считать в % по умолчанию
    }
   /*
    * Прочитать файл статитсики
    * @Returns {string} содержимое файла
   */
    _readStat () {
        const data = libfs.readFileSync( "/proc/stat")
        const d = data.toString().split('\n'); //разбиваем на строки
        return d[0] //возвращаем только первую строку
    }
   /*
    * Получить информацию о процессоре
    * @Returns {Object} информацию о загрузке и простое процессоре
   */
   _getCPUInfo() {
    const data = this._readStat() 
  // cpu  2112080 0 119450 94011396 9440 0 159990 0 0 0          
    const d = data.split(' ');

/* 2– user: обычные процессы, которые выполняются в user mode
 * 3– nice: процессы с nice (приоритезация) в user mode
 * 4– system: процессы в kernel mode
 * 5– idle: время в простое(ЦПУ простаивает)
 * 6– iowait: ожидание операций I/O (ввода/вывода)
 * 7– irq: обработка аппаратных прерываний
 * 8– softirq: обработка программных прирываний многозадачности
 * 9– steal: “украденное” время, потраченное другими операционными системами при использовании виртуализации; 
 * 10– guest: обработка “гостевых” (виртуальных) процессоров
 * 11- guest_nice: обработка “гостевых” (виртуальных) nice процессоров
*/
 let total=0;       
 
    for(var i=2;i<d.length; i++){
        total+=parseInt(d[i])
    }

const idle = parseInt(d[5])
 
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