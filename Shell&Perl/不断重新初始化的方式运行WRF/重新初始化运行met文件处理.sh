#!/bin/bash

year=2014
year_b=2013
year_a=2015

cp ../complete/$year_b/12/met_em.d0?.$year_b-12-31_1[2-8]* ./01/
cp ./02/met_em.d0?.$year-02-01_00\:00\:00.nc ./01/

cp ./01/met_em.d0?.$year-01-31_1[2-8]* ./02/
cp ./03/met_em.d0?.$year-03-01_00\:00\:00.nc ./02/

cp ./02/met_em.d0?.$year-02-28_1[2-8]* ./03/
cp ./04/met_em.d0?.$year-04-01_00\:00\:00.nc ./03/

cp ./03/met_em.d0?.$year-03-31_1[2-8]* ./04/
cp ./05/met_em.d0?.$year-05-01_00\:00\:00.nc ./04/

cp ./04/met_em.d0?.$year-04-30_1[2-8]* ./05/
cp ./06/met_em.d0?.$year-06-01_00\:00\:00.nc ./05/

cp ./05/met_em.d0?.$year-05-31_1[2-8]* ./06/
cp ./07/met_em.d0?.$year-07-01_00\:00\:00.nc ./06/

cp ./06/met_em.d0?.$year-06-30_1[2-8]* ./07/
cp ./08/met_em.d0?.$year-08-01_00\:00\:00.nc ./07/

cp ./07/met_em.d0?.$year-07-31_1[2-8]* ./08/
cp ./09/met_em.d0?.$year-09-01_00\:00\:00.nc ./08/

cp ./08/met_em.d0?.$year-08-31_1[2-8]* ./09/
cp ./10/met_em.d0?.$year-10-01_00\:00\:00.nc ./09/

cp ./09/met_em.d0?.$year-09-30_1[2-8]* ./10/
cp ./11/met_em.d0?.$year-11-01_00\:00\:00.nc ./10/

cp ./10/met_em.d0?.$year-10-31_1[2-8]* ./11/
cp ./12/met_em.d0?.$year-12-01_00\:00\:00.nc ./11/

cp ./11/met_em.d0?.$year-11-30_1[2-8]* ./12/
cp ../$year_a/01/met_em.d0?.$year_a-01-01_00\:00\:00.nc ./12/