#!/bin/bash

for scene in current ens-ssp126-2021-2040 ens-ssp126-2041-2060 ens-ssp126-2061-2080 ens-ssp126-2081-2100 ens-ssp245-2021-2040 ens-ssp245-2041-2060 ens-ssp245-2061-2080 ens-ssp245-2081-2100 ens-ssp370-2021-2040 ens-ssp370-2041-2060 ens-ssp370-2061-2080 ens-ssp370-2081-2100 ens-ssp585-2021-2040 ens-ssp585-2041-2060 ens-ssp585-2061-2080 ens-ssp585-2081-2100
do 
	sed -i "8s/^.*.$/scene = \"${scene}\"/g" 006.plot.each.ncl
	ncl 006.plot.each.ncl
	convert -density 800 -trim ${scene}.eps ${scene}.png
done

rm -rf *.eps plot-scene

mkdir plot-scene
mv *.png plot-scene
