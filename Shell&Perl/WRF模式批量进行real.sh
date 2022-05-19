#!/bin/bash
for ((YEAR=1979; YEAR<=1980; YEAR++))
do
  year_end=`expr $YEAR + 1`
  ln -sf /home/ERA_METFILE/$YEAR/met_em.d01.$YEAR* /home/qianqf/WRFV3/run/
  ln -sf /home/ERA_METFILE/$year_end/met_em.d01.$year_end-01-01_00* /home/qianqf/WRFV3/run/
  sed -i "s/^.*start_year.*$/ start_year                          = $YEAR, $YEAR, $YEAR/" namelist.input
  sed -i "s/^.*end_year.*$/ end_year                            = $year_end, $year_end, $year_end/" namelist.input
  mpirun -np 8 ./real.exe
  mv wrfbdy_d01 wrfbdy_d01_$YEAR
  mv wrffdda_d01 wrffdda_d01_$YEAR
  mv wrfinput_d01 wrfinput_d01_$YEAR
  mv wrflowinp_d01 wrflowinp_d01_$YEAR
  rm -rf met_em.d01*
done