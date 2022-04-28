#!/usr/bin/python3

# после правки файла .service
# sudo systemctl daemon-reload
# sudo systemctl enable linux_monitoring.service
# sudo systemctl start linux_monitoring.service
# sudo systemctl status linux_monitoring.service
# sudo systemctl restart linux_monitoring.service
# sudo systemctl stop linux_monitoring.service
import time

while True:
    print ("This is a monitoring service!")
    time.sleep(5)