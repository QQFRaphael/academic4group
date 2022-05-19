#!/bin/bash

for scene in ssp126 ssp245 ssp370 ssp585
do
	for period in 2021-2040 2041-2060 2061-2080 2081-2100
	do
		outname="ens-${scene}-${period}"
		cdo ensmean ncOutput/proj_BCC-CSM2-MR-${scene}-${period}-ROC.nc ncOutput/proj_CanESM5-${scene}-${period}-ROC.nc ncOutput/proj_CNRM-CM6-1-${scene}-${period}-ROC.nc ncOutput/proj_CNRM-ESM2-1-${scene}-${period}-ROC.nc ncOutput/proj_MIROC6-${scene}-${period}-ROC.nc ncOutput/proj_MIROC-ES2L-${scene}-${period}-ROC.nc ncOutput/${outname}-ROC.nc
	done
done
