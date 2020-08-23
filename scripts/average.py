with open('/tmp/abc.txt') as fh:
    sum = 0
    numlines = 0
    for line in fh:
    	if line.strip():
        	n = line.split(':')[-1]
	        sum += float(n)
	        numlines += 1
    average = sum / numlines
#print average
print("%.9f" % round(average,9))

