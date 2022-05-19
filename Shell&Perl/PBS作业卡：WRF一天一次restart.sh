#!/bin/sh
#PBS -l nodes=12:ppn=16
echo "This jobs is "$PBS_JOBID@$PBS_QUEUE
NSLOTS=`cat ${PBS_NODEFILE} | wc -l`
cd $PBS_O_WORKDIR
Y0=2000
Y1=2003
for ((Y=${Y0};Y<=${Y1};Y++))
do
if [ $[$Y % 4] -eq 0 ]
then
NMD=(31 29 31 30 31 30 31 31 30 31 30 31)
else
NMD=(31 28 31 30 31 30 31 31 30 31 30 31)
fi
YS=$Y
YE=$Y
for ((M=1;M<=12;M++))
do
MS=$M
ME=$M
for ((D=1;D<=${NMD[M-1]};D++))
do
DS=$D
DE=$[$D + 1]
ad=$[${NMD[M-1]} - $D]
if [ "$ad" = 0 ]
then
DE=1
ME=$[$M + 1]
if [ "$M" = 12 ]
then
ME=1
YE=$[$Y + 1]
fi
fi
sr=true
if [ "$Y" = ${Y0} ]
then
if [ "$M" = 1 ]
then
if [ "$D" = 1 ]
then
sr=false
fi
fi
fi
cat > namelist.input << EOF
 &time_control
 run_days                            = 1,
 run_hours                           = 0,
 run_minutes                         = 0,
 run_seconds                         = 0,
 start_year                          = $YS,
 start_month                         = $MS,
 start_day                           = $DS,
 start_hour                          = 00,
 start_minute                        = 00,   00,   00,
 start_second                        = 00,   00,   00,
 end_year                            = $YE,
 end_month                           = $ME,
 end_day                             = $DE,
 end_hour                            = 00,
 end_minute                          = 00,   00,   00,
 end_second                          = 00,   00,   00,
 interval_seconds                    = 21600
 input_from_file                     = .true.,.true.,.true.,
 history_interval                    = 360,  60,   60,
 frames_per_outfile                  = 2000, 1000, 1000,
 restart                             = .$sr.,
 restart_interval                    = 1440
 io_form_history                     = 2
 io_form_restart                     = 2
 io_form_input                       = 2
 io_form_boundary                    = 2
 debug_level                         = 0
 auxinput4_inname                    = "wrflowinp_d01"
 auxinput4_interval                  = 360
 io_form_auxinput4                   = 2
 reset_simulation_start              = .true.,
 override_restart_timers             = .true.,
 /

 &domains
 time_step                           = 120,
 time_step_fract_num                 = 0,
 time_step_fract_den                 = 1,
 max_dom                             = 1,
 e_we                                = 221,    52,   142,
 e_sn                                = 181,    52,   142,
 e_vert                              = 28,    34,    40,
 p_top_requested                     = 5000,
 num_metgrid_levels                  = 27,
 num_metgrid_soil_levels             = 2,
 dx                                  = 30000, 9000,  1000,
 dy                                  = 30000, 9000,  1000,
 grid_id                             = 1,     2,     3,
 parent_id                           = 0,     1,     2,
 i_parent_start                      = 1,     12,    7,
 j_parent_start                      = 1,     12,    7,
 parent_grid_ratio                   = 1,     3,     3,
 parent_time_step_ratio              = 1,     3,     3,
 feedback                            = 1,
 smooth_option                       = 0,
 /

 &physics
 mp_physics                          = 6,     4,     6,
 ra_lw_physics                       = 3,     1,     1,
 ra_sw_physics                       = 3,     1,     2,
 radt                                = 30,    10,     1,
 sf_sfclay_physics                   = 1,     5,     5,
 sf_surface_physics                  = 2,     1,     2,
 bl_pbl_physics                      = 5,     5,     5,
 bldt                                = 0,     0,     0,
 cu_physics                          = 1,     5,     0,
 cudt                                = 5,     0,     5,
 isfflx                              = 1,
 ifsnow                              = 0,
 icloud                              = 1,
 surface_input_source                = 1,
 num_soil_layers                     = 4,
 num_land_cat 			     = 24,
 sf_urban_physics                    = 0,     0,     0,
 mp_zero_out = 0,
! maxiens = 1,
! cu_diag = 0,
! convtrans_avglen_m = 30,
 tmn_update =1,
 sst_update			     = 1,
 bucket_mm =100.0,
 bucket_J = 1.e9,
 usemonalb			    = .true.,
 /

 &fdda
 /

 &dynamics
 w_damping                           = 1,
 diff_opt                            = 1,
 km_opt                              = 4,
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
 spec_exp                            = 0.33,
 nested                              = .false., .true., .true.,
 /

 &grib2
 /

 &namelist_quilt
 nio_tasks_per_group = 0,
 nio_groups = 1,
 /
EOF
/share/apps/openmpi-1.4.5/bin/mpirun -np 16  ./real.exe
ncl change_albedo.ncl
/share/apps/openmpi-1.4.5/bin/mpirun -machinefile $PBS_NODEFILE -np $NSLOTS  ./wrf.exe
done
done
done
