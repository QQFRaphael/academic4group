f1 = addfile("eof-pre-djf-square-root.nc","r")
f2 = addfile("eof-pre-djf.nc","r")

ts1 = f1->ts1
ts2 = f1->ts2
ts3 = f1->ts3

ts11 = f2->ts1
ts22 = f2->ts2
ts33 = f2->ts3

print(escorc_n(ts1,ts11, 0, 0))
print(escorc_n(ts2,ts22, 0, 0))
print(escorc_n(ts3,ts33, 0, 0))

