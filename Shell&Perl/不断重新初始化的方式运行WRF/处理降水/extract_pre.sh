#!/bin/bash
for ii in `ls /home/yongluo/WORK/wrfoutput/wrfout/`
do
	all_file=(`ls /home/yongluo/WORK/wrfoutput/wrfout/$ii`)
	echo ${all_file[@]:0:1}
	echo ${all_file[@]:4:1}
	echo ${all_file[@]:5:1}
	echo ${all_file[@]:9:1}
	sed -i "6s/^.*.$/wrff1=addfile(\"\/home\/yongluo\/WORK\/wrfoutput\/wrfout\/$ii\/${all_file[@]:0:1}\",\"r\")/" ./extract_pre.ncl 
	sed -i "7s/^.*.$/wrff2=addfile(\"\/home\/yongluo\/WORK\/wrfoutput\/wrfout\/$ii\/${all_file[@]:4:1}\",\"r\")/" ./extract_pre.ncl
	sed -i "8s/^.*.$/wrff3=addfile(\"\/home\/yongluo\/WORK\/wrfoutput\/wrfout\/$ii\/${all_file[@]:5:1}\",\"r\")/" ./extract_pre.ncl
	sed -i "9s/^.*.$/wrff4=addfile(\"\/home\/yongluo\/WORK\/wrfoutput\/wrfout\/$ii\/${all_file[@]:9:1}\",\"r\")/" ./extract_pre.ncl
	sed -i "42s/^.*.$/out=addfile(\"$ii\_d01.nc\",\"c\")/" ./extract_pre.ncl
	sed -i "47s/^.*.$/out=addfile(\"$ii\_d02.nc\",\"c\")/" ./extract_pre.ncl
	ncl extract_pre.ncl 
done
