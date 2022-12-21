//node.js пример вычисления загрузки ЦПУ через стандартный пакет OS

const path = require('path');
const os=require('os');

//Функция перебирает все ЦПУ в системе
function cpuAverage() {
  var totalIdle = 0, totalTick = 0;
  var cpus = os.cpus();

  for(var i = 0, len = cpus.length; i < len; i++) {
    var cpu = cpus[i];
    for(type in cpu.times) {
      totalTick += cpu.times[type];
   }

    totalIdle += cpu.times.idle;
  }
  return {idle: totalIdle / cpus.length,  total: totalTick / cpus.length};
}

//Вычисляем загрузку ЦПУ
function CPULoad(interval, callback) {
  this.samples = [];
  this.samples[1] = cpuAverage();
  this.refresh = setInterval(() => {
    this.samples[0] = this.samples[1];
    this.samples[1] = cpuAverage();
    var totalDiff = this.samples[1].total - this.samples[0].total;
    var idleDiff = this.samples[1].idle - this.samples[0].idle;
    callback((100*(1 - idleDiff / totalDiff)).toFixed(1));
  }, interval);
}

const hostname = os.hostname()

//получаем время в высоком разрешении, наносекунды
const hrTime = process.hrtime()
//вычисляем timestamp в наносекундах, фактически текущую дату+"хвост" и знаносекунд
const timestamp = Number(Date.now() + String(hrTime[1]).slice(3))
//имя скрипта
const scriptname = path.basename(__filename)
//интервал измерения и вычисления использования ЦПУ в мсек
const interval = 1000

//вызов с callback
CPULoad(interval, (cpu_busy) => {
  console.log(`cpu_percent,host=${hostname},script=${scriptname} cpu_busy=${cpu_busy} ${timestamp}`);
  process.exit(0);
  }
);



