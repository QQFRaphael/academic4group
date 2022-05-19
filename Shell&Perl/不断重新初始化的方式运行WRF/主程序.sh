#!/bin/bash
#BSUB -q hpc_linux
#BSUB -a openmpi
#BSUB -n 360
#BSUB -o OUTPUTFILE.%J
#BSUB -e ERRORFILE.%J
echo "################ Let's begin ################" >> run_wrf_reini.log
echo "################ Get all files' name  ################" >> run_wrf_reini.log
files_d01=(`ls /home/yongluo/WORK/tibetmet/*d01*.nc`)
files_d02=(`ls /home/yongluo/WORK/tibetmet/*d02*.nc`)
echo "################ Get all fisrt time files' name ################" >> run_wrf_reini.log
START_HOUR=12
files_time=(`ls /home/yongluo/WORK/tibetmet/met_em.d01.*_${START_HOUR}:00:00*`)
echo "################ calculate running times ################" >> run_wrf_reini.log
run_n_times=${#files_time[@]}
echo "################ we need to run $run_n_times times ################" >> run_wrf_reini.log
mkdir /home/yongluo/WORK/wrfoutput/spinup
mkdir /home/yongluo/WORK/wrfoutput/wrfout
mkdir /home/yongluo/WORK/wrfoutput/wrfpress
mkdir /home/yongluo/WORK/wrfoutput/rsl
mkdir /home/yongluo/WORK/wrfoutput/wrfrst
mkdir /home/yongluo/WORK/wrfoutput/wrfini
echo "################ creat directory to store model output ################" >> run_wrf_reini.log
for ((i=0; i<=$run_n_times-1; i++))
do
	echo "---------------- this is No.$i ----------------" >> run_wrf_reini.log
	tmp_d01=(${files_d01[@]:$i*4:7})
	tmp_d02=(${files_d02[@]:$i*4:7})
	tmp_time_start=${tmp_d01[0]##*/}
	tmp_time_end=${tmp_d01[6]##*/}
	tmp_time_store=${tmp_d01[2]##*/}
	tmp_start=$(echo ${tmp_time_start/met_em.d01./}|sed -e 's/\:00\:00.nc//')
	tmp_end=$(echo ${tmp_time_end/met_em.d01./}|sed -e 's/\:00\:00.nc//')
	tmp_store=$(echo ${tmp_time_store/met_em.d01./}|sed -e 's/\:00\:00.nc//')
	year_start=${tmp_start:0:4}
	month_start=${tmp_start:5:2}
	day_start=${tmp_start:8:2}
	hour_start=${tmp_start:11:2}
	echo "start time is:" $year_start-$month_start-$day_start-$hour_start >> run_wrf_reini.log
	year_end=${tmp_end:0:4}
    month_end=${tmp_end:5:2}
    day_end=${tmp_end:8:2}
    hour_end=${tmp_end:11:2}
	echo "end time is:" $year_end-$month_end-$day_end-$hour_end >> run_wrf_reini.log
    year_store=${tmp_store:0:4}
    month_store=${tmp_store:5:2}
    day_store=${tmp_store:8:2}
	echo "store time is:" $year_store-$month_store-$day_store >> run_wrf_reini.log
	echo "link metfile to WRF run directory" >> run_wrf_reini.log
    ln -sf ${tmp_d01[@]} /home/yongluo/WORK/Model/WRFV3/run
	ln -sf ${tmp_d02[@]} /home/yongluo/WORK/Model/WRFV3/run
	echo "modify namelist.input" >> run_wrf_reini.log
	sed -i "6s/^.*.$/ start_year                          = $year_start,	$year_start,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
	sed -i "7s/^.*.$/ start_month                         = $month_start,	$month_start,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
	sed -i "8s/^.*.$/ start_day                           = $day_start,	$day_start,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
    sed -i "9s/^.*.$/ start_hour                          = $hour_start,	$hour_start,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
	sed -i "12s/^.*.$/ end_year                            = $year_end,	$year_end,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
    sed -i "13s/^.*.$/ end_month                           = $month_end,	$month_end,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
    sed -i "14s/^.*.$/ end_day                             = $day_end,	$day_end,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
    sed -i "15s/^.*.$/ end_hour                            = $hour_end,	$hour_end,/" /home/yongluo/WORK/Model/WRFV3/run/namelist.input
	echo "run real.exe" >> run_wrf_reini.log
	mpirun.lsf ./real.exe
	echo "run wrf.exe" >> run_wrf_reini.log
	mpirun.lsf ./wrf.exe
	echo "WRF complete" >> run_wrf_reini.log
	echo "move initial & boundary condition to a certain directory"
	mkdir /home/yongluo/WORK/wrfoutput/wrfini/$year_store-$month_store-$day_store
	mv ./wrfbdy* /home/yongluo/WORK/wrfoutput/wrfini/$year_store-$month_store-$day_store
	mv ./wrfinput* /home/yongluo/WORK/wrfoutput/wrfini/$year_store-$month_store-$day_store
	mv ./wrflowinp* /home/yongluo/WORK/wrfoutput/wrfini/$year_store-$month_store-$day_store
	echo "move spin up output to a certain directory" >> run_wrf_reini.log
	tmp_wrf=(`ls ./wrfout*`)
	mkdir /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	mv ${tmp_wrf[@]:0:2} /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	mv ${tmp_wrf[@]:7:2} /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	tmp_press=(`ls ./wrfpress*`)
	mv ${tmp_press[@]:0:2} /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	mv ${tmp_press[@]:7:2} /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	tmp_rst=(`ls ./wrfrst*`)
	mv ${tmp_rst:0:2} /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	mv ${tmp_rst:7:2} /home/yongluo/WORK/wrfoutput/spinup/$year_store-$month_store-$day_store
	echo "move model output to a certain directory" >> run_wrf_reini.log
	mkdir /home/yongluo/WORK/wrfoutput/wrfout/$year_store-$month_store-$day_store
	mv ./wrfout* /home/yongluo/WORK/wrfoutput/wrfout/$year_store-$month_store-$day_store
	echo "move model press to a certain directory" >> run_wrf_reini.log
	mkdir /home/yongluo/WORK/wrfoutput/wrfpress/$year_store-$month_store-$day_store
	mv ./wrfpress* /home/yongluo/WORK/wrfoutput/wrfpress/$year_store-$month_store-$day_store
	echo "move model rsl to a certain directory" >> run_wrf_reini.log
	mkdir /home/yongluo/WORK/wrfoutput/rsl/$year_store-$month_store-$day_store
	cp ./rsl.*.0000 /home/yongluo/WORK/wrfoutput/rsl/$year_store-$month_store-$day_store
	echo "move model restart to a certain directory" >> run_wrf_reini.log
	mkdir /home/yongluo/WORK/wrfoutput/wrfrst/$year_store-$month_store-$day_store
	mv ./wrfrst* /home/yongluo/WORK/wrfoutput/wrfrst/$year_store-$month_store-$day_store
	echo "clean metfiles" >> run_wrf_reini.log
	rm -rf ./met_em.d0?.*
	echo "copy namelist.input to a certain directory"
	cp ./namelist.input /home/yongluo/WORK/wrfoutput
	echo "================ No.$i complete ================" >> run_wrf_reini.log
done
