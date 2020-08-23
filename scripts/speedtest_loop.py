import time
import os
count = 50
os.system("echo \"0\" > /tmp/a")
while ( count != 0 ):
 print ("Running interation {}".format(count))
 os.system("speedtest -s 16353 >> /tmp/a") 
 #os.system("/root/.local/bin/speedtest-cli --no-upload --server 16353 >> /tmp/a") 
 time.sleep(2)
 count = count -1


