import os
import random
import time 
count = 0 
while ( count == 0 ):
 time.sleep (0.5)
 bps = random.randrange (750, 850)
 bps = bps * 1000000
 str = "vppctl fastpath set_ue_bps ip 192.168.103.10 bps " + format(bps) 
 print (str)
 os.system(str);
