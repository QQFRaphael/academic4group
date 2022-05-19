#!/bin/sh

ROOT=`pwd`
CESM_ROOT=/THL6/home/renguang/CESM/cesm1_1_1

# what is your case name?
case="ice.long"

# which compset? FC5 is only cam5
compset="FC5"

# what resolution? usually I use f19_g16
res="f19_g16"

# which machine? In Tianhe, the account is Prof.Wu, thus, mach is wu
# This param can be changed if necessary
mach="wu"

# how long?
ntimes=220

# create a new case
$CESM_ROOT/scripts/create_newcase -case $case -res $res -compset $compset -mach $mach

# build the model and modify the output dirctory
cd $case
./xmlchange -file env_build.xml -id EXEROOT -val "$ROOT/$case/output"
./xmlchange -file env_run.xml -id RUNDIR -val "$ROOT/$case/output"
./xmlchange -file env_run.xml -id STOP_OPTION -val "nyears"
./xmlchange -file env_run.xml -id STOP_N -val "$ntimes"
./xmlchange -file env_run.xml -id REST_OPTION -val "nyears"
./xmlchange -file env_run.xml -id REST_N -val "30"
./xmlchange -file env_run.xml -id DOUT_S_SAVE_INT_REST_FILES -val "TRUE"
#./xmlchange -file env_run.xml -id SSTICE_DATA_FILENAME -val "\$DIN_LOC_ROOT/atm/cam/sst/sst_HadOIBl_bc_1x1_clim_c101029.nc"
./xmlchange -file env_run.xml -id SSTICE_DATA_FILENAME -val "/THL6/home/renguang/qqf/sea_ice_modified.nc"
./cesm_setup
./${case}.build
cd ..
