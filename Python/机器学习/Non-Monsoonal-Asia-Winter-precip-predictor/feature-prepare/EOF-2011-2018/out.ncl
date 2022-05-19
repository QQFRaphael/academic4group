f = addfile("eof-pre-djf.nc","r")

ts1 = f->ts1
ts2 = f->ts2
ts3 = f->ts3
ts4 = f->ts4

asciiwrite("ts1.txt",ts1)
asciiwrite("ts2.txt",ts2)
asciiwrite("ts3.txt",ts3)
asciiwrite("ts4.txt",ts4)

