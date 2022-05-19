f = addfile("base-eof-result.nc","r")

ts1 = f->ts1
ts2 = f->ts2
ts3 = f->ts3

asciiwrite("ts1.txt",ts1)
asciiwrite("ts2.txt",ts2)
asciiwrite("ts3.txt",ts3)


