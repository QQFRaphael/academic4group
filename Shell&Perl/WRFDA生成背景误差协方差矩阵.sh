#!/bin/sh
#PBS -l nodes=n01:ppn=16+n02:ppn=16+n03:ppn=16+n04:ppn=16+n05:ppn=16+n07:ppn=16
#PBS -p 1023

export WORKING_DIR=`pwd`
mkdir -p ${WORKING_DIR}/gen_be_work
export GEN_BE_WORK=${WORKING_DIR}/gen_be_work
export WPS_DIR=${WORKING_DIR}/WPS/for_gen_be
export WRF_DIR=${WORKING_DIR}/WRFV3
export WRFVAR_DIR=${WORKING_DIR}/WRFDA
mkdir -p ${WORKING_DIR}/gen_be_work/gen_be_fc
export FC_DIR=${WORKING_DIR}/gen_be_work/gen_be_fc

#set the start time, forecast 24h and save every 12h and 24h results
#run interval is 6h
export run_hours=24
export history_interval=720   #unit: minute
export metfile_interval=6     #unit: hour
export max_dom=1

cd ${GEN_BE_WORK}
ln -sf ${WPS_DIR}/met_em.d01* .
ln -sf ${WRF_DIR}/run/LANDUSE.TBL .
ln -sf ${WRF_DIR}/run/ozone_plev.formatted .
ln -sf ${WRF_DIR}/run/ozone_lat.formatted .
ln -sf ${WRF_DIR}/run/ozone.formatted .
ln -sf ${WRF_DIR}/run/RRTMG_LW_DATA .
ln -sf ${WRF_DIR}/run/RRTMG_SW_DATA .
ln -sf ${WRF_DIR}/run/VEGPARM.TBL .
ln -sf ${WRF_DIR}/run/SOILPARM.TBL .
ln -sf ${WRF_DIR}/run/GENPARM.TBL .

allfiles=(`ls ${GEN_BE_WORK}/met_em.d01.*`)
run_n_times=${#allfiles[@]}

for ((i=0; i<=$run_n_times-5; i++))
do
start_tmp=${allfiles[$i]##*/}
end_tmp=${allfiles[$i+4]##*/}
START_YEAR=${start_tmp:11:4}
START_MONTH=${start_tmp:16:2}
START_DAY=${start_tmp:19:2}
START_HOUR=${start_tmp:22:2}
START_MINUTE=${start_tmp:25:2}
START_SECOND=${start_tmp:28:2}

END_YEAR=${end_tmp:11:4}
END_MONTH=${end_tmp:16:2}
END_DAY=${end_tmp:19:2}
END_HOUR=${end_tmp:22:2}
END_MINUTE=${end_tmp:25:2}
END_SECOND=${end_tmp:28:2}

echo "===========Forecast begins==========="
echo "The start time is: "$START_YEAR-$START_MONTH-$START_DAY-$START_HOUR:$START_MINUTE:$START_SECOND
echo "The end time is:   "$END_YEAR-$END_MONTH-$END_DAY-$END_HOUR:$END_MINUTE:$END_SECOND

cat >> namelist.input << EOF
 &time_control
 run_days                            = 0,
 run_hours                           = ${run_hours},
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = ${START_YEAR}, ${START_YEAR}, ${START_YEAR},
 start_month                         = ${START_MONTH},   ${START_MONTH},   ${START_MONTH},
 start_day                           = ${START_DAY},   ${START_DAY},   ${START_DAY},
 start_hour                          = ${START_HOUR},   ${START_HOUR},   ${START_HOUR},
 start_minute                        = ${START_MINUTE},   ${START_MINUTE},   ${START_MINUTE},
 start_second                        = ${START_SECOND},   ${START_SECOND},   ${START_SECOND},
 end_year                            = ${END_YEAR}, ${END_YEAR}, ${END_YEAR},
 end_month                           = ${END_MONTH},   ${END_MONTH},   ${END_MONTH},
 end_day                             = ${END_DAY},   ${END_DAY},   ${END_DAY},
 end_hour                            = ${END_HOUR},   ${END_HOUR},   ${END_HOUR},
 end_minute                          = ${END_MINUTE},   ${END_MINUTE},   ${END_MINUTE},
 end_second                          = ${END_SECOND},   ${END_SECOND},   ${END_SECOND},
 interval_seconds                    = 21600
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = ${history_interval},  ${history_interval},  ${history_interval},
 frames_per_outfile                  = 1, 1, 1,
 restart                             = .false.,
 restart_interval                    = 9999999,
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 /

 &domains
 time_step                           = 120,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 1,
 max_dom                             = ${max_dom},
 e_we                                = 189,   361,   436,
 e_sn                                = 146,   238,   355,
 e_vert                              = 31,    31,    31,
 p_top_requested                     = 5000,
 num_metgrid_levels                  = 27,
 num_metgrid_soil_levels             = 4,
 dx                                  = 27000, 9000, 3000,
 dy                                  = 27000, 9000, 3000,
 grid_id                             = 1,     2,     3,
 parent_id                           = 1,     1,     2,
 i_parent_start                      = 1,     35,    109,
 j_parent_start                      = 1,     34,    61,
 parent_grid_ratio                   = 1,     3,     3,
 parent_time_step_ratio              = 1,     3,     5,
 feedback                            = 0,
 smooth_option                       = 0
 /

 &physics
 mp_physics                          = 8,     8,     8,
 ra_lw_physics                       = 4,     4,     4,
 ra_sw_physics                       = 4,     4,     4,
 radt                                = 27,    9,     3,
 sf_sfclay_physics                   = 1,     1,     1,
 sf_surface_physics                  = 2,     2,     2,
 bl_pbl_physics                      = 1,     1,     1,
 bldt                                = 0,     0,     0,
 cu_physics                          = 1,     1,     0,
 cudt                                = 5,     5,     0,
 isfflx                              = 1,
 ifsnow                              = 1,
 icloud                              = 1,
 surface_input_source                = 1,
 num_soil_layers                     = 4,
 sf_urban_physics                    = 0,     0,     0,
 num_land_cat                        = 24,
 /

 &fdda
 /

 &dynamics
 w_damping                           = 0,
 diff_opt                            = 1,      1,      1,
 km_opt                              = 4,      4,      4,
 diff_6th_opt                        = 0,      0,      0,
 diff_6th_factor                     = 0.12,   0.12,   0.12,
 base_temp                           = 290.
 damp_opt                            = 0,
 zdamp                               = 5000.,  5000.,  5000.,
 dampcoef                            = 0.2,    0.2,    0.2
 khdif                               = 0,      0,      0,
 kvdif                               = 0,      0,      0,
 non_hydrostatic                     = .true., .true., .true.,
 moist_adv_opt                       = 1,      1,      1,
 scalar_adv_opt                      = 1,      1,      1,
 /

 &bdy_control
 spec_bdy_width                      = 10,
 spec_zone                           = 1,
 relax_zone                          = 9,
 specified                           = .true., .false.,.false.,
 nested                              = .false., .true., .true.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /
EOF

#set the mpi
NSLOTS=`cat ${PBS_NODEFILE} | wc -l`
/share/apps/intel/impi/4.1.1.036/intel64/bin/mpirun -machinefile $PBS_NODEFILE -np $NSLOTS ${WRF_DIR}/run/real.exe
/share/apps/intel/impi/4.1.1.036/intel64/bin/mpirun -machinefile $PBS_NODEFILE -np $NSLOTS ${WRF_DIR}/run/wrf.exe

mkdir -p ${GEN_BE_WORK}/${START_YEAR}${START_MONTH}${START_DAY}${START_HOUR}
tmp_filename=(`ls ${GEN_BE_WORK}/wrfout*`)
mv ${tmp_filename[@]:1:2} ${GEN_BE_WORK}/${START_YEAR}${START_MONTH}${START_DAY}${START_HOUR}
rm -rf ${GEN_BE_WORK}/wrfout_d01*
rm -rf ${GEN_BE_WORK}/namelist.input
echo "===========This is the $i times==========="
done
echo "===========Forecast ends==========="

rm -rf ${GEN_BE_WORK}/met_em.d01*
rm -rf ${GEN_BE_WORK}/LANDUSE.TBL
rm -rf ${GEN_BE_WORK}/ozone_plev.formatted
rm -rf ${GEN_BE_WORK}/ozone_lat.formatted
rm -rf ${GEN_BE_WORK}/ozone.formatted
rm -rf ${GEN_BE_WORK}/RRTMG_LW_DATA
rm -rf ${GEN_BE_WORK}/RRTMG_SW_DATA
rm -rf ${GEN_BE_WORK}/VEGPARM.TBL
rm -rf ${GEN_BE_WORK}/SOILPARM.TBL
rm -rf ${GEN_BE_WORK}/GENPARM.TBL
rm -rf ${GEN_BE_WORK}/rsl.*
rm -rf ${GEN_BE_WORK}/namelist.input
rm -rf ${GEN_BE_WORK}/namelist.output
rm -rf ${GEN_BE_WORK}/wrfbdy_d0*
rm -rf ${GEN_BE_WORK}/wrfinput_d0*
rm -rf ${GEN_BE_WORK}/qr_acr*
rm -rf ${GEN_BE_WORK}/freezeH2O.dat
mv ${GEN_BE_WORK}/${START_YEAR}* ${FC_DIR}/
echo "===========clean files==========="
cp $WRFDA_DIR/var/scripts/gen_be .