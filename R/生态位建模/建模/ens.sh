#!/bin/bash

for scene in ssp126 ssp245 ssp370 ssp585
do
	for period in 2021-2040 2041-2060 2061-2080 2081-2100
	do
		outname="ens-${scene}-${period}"
		cdo ensmean BCC-CSM2-MR-${scene}-${period}.nc CanESM5-${scene}-${period}.nc CNRM-CM6-1-${scene}-${period}.nc CNRM-ESM2-1-${scene}-${period}.nc MIROC6-${scene}-${period}.nc MIROC-ES2L-${scene}-${period}.nc ${outname}.nc
	done
done
