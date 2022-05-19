#!/usr/bin/python
import os,sys
result=os.popen('qload | grep "idle" | grep " 3:2:"').read()
list=result.split(" ")
#print list
index=0
print_str = "time bsub -b -I -m 1 -p -q q_soft_eco_qh -node "
for i in list:
	if len(i)==4 and "." not in i and "M" not in i and str.isdigit(i):
#print i+","
	print_str+=str(i)+","
	index+=1
	if(index==sys.argv[1]):
		break
print sys.argv[1]
print_str+="-host_stack 1024 -share_size 6000 -n "+ sys.argv[2]+" -o run.log -cgsp 1 ./cesm.exe"
print print_str