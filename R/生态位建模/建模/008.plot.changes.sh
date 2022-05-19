#!/bin/bash

rm -rf changes
mkdir -p changes/change02
mkdir -p changes/change04
mkdir -p changes/change06

for scene in ssp126 ssp245 ssp370 ssp585
do
	for time in 2021-2040 2041-2060 2061-2080 2081-2100
	do
		for case in 02 04 06
		do
			echo "============================================ ${case} ============================================"
			myscene="${scene}-${time}"
			sed -i "7s/^.*.$/scene1 = \"${myscene}\"/g" 008.change.ncl
			sed -i "9s/^.*.$/path = \"binary\/binary${case}\/\"/g" 008.change.ncl
			ncl 008.change.ncl
			mv ${myscene}-current.nc changes/change${case}/
			convert -density 800 -trim ${myscene}-current.eps ${myscene}-current.png
			mv ${myscene}-current.png changes/change${case}/
			rm -rf ${myscene}-current.eps
		done
	done
done

