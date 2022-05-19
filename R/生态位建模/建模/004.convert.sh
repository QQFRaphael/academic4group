#!/bin/bash

rm -rf ncOutput

mkdir ncOutput

for model in BCC-CSM2-MR CanESM5 CNRM-CM6-1 CNRM-ESM2-1 MIROC6 MIROC-ES2L
do
	for scene in ssp126 ssp245 ssp370 ssp585
	do
		for period in 2021-2040 2041-2060 2061-2080 2081-2100
		do
			dirname="proj_${model}-${scene}-${period}"
			for metric in TSS ROC
			do
				gdal_translate  hongdoushan/${dirname}/individual_projections/hongdoushan_EMwmeanBy${metric}_mergedAlgo_mergedRun_mergedData.grd ncOutput/${dirname}-${metric}.nc
			done
		done
	done
done


for metric in TSS ROC
do
	gdal_translate  hongdoushan/proj_current/individual_projections/hongdoushan_EMwmeanBy${metric}_mergedAlgo_mergedRun_mergedData.grd ncOutput/current-${metric}.nc
done
