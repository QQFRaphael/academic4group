#!/bin/bash

export https_proxy=127.0.0.1:58591

urlHead="https://collaboration.cmc.ec.gc.ca/cmc/saison/hindcast_2011_2019/raw"

for year in `seq 2011 2019`
do
	for mon in 01 02 03 04 05 06 07 08 09 10 11 12
	do
		for var in HGT_ISBL_0500 PRATE_SFC_0 PRMSL_MSL_0 TMP_ISBL_0850 TMP_TGL_2m UGRD_ISBL_0200 UGRD_ISBL_0850 VGRD_ISBL_0200 VGRD_ISBL_0850 WTMP_SFC_0 
		do
			url=${urlHead}/${year}/${mon}/cansips_hindcast_raw_latlon1.0x1.0_${var}_${year}-${mon}_allmembers.grib2
			echo $url
			wget --user="wmouser" --password="globale98" $url
		done
	done
	mkdir ${year}
	mv *${year}*.grib2 ${year}
done
