#!/bin/bash

for model in ens #BCC-CSM2-MR CanESM5 CNRM-CM6-1 CNRM-ESM2-1 MIROC6 MIROC-ES2L
do
	for scene in ssp126 ssp245 ssp370 ssp585
	do
		for period in 2021-2040 2041-2060 2061-2080 2081-2100
		do
			filename="${model}-${scene}-${period}"
			sed -i "8s/^.*.$/scene = \"${filename}\"/g" 009.mess.ncl
			ncl 009.mess.ncl
			convert -density 800 -trim ${filename}.eps ${filename}.png
			rm -rf ${filename}.eps
			mv ${filename}.png mess
		done
	done
done
