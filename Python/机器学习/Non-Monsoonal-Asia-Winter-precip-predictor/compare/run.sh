#!/bin/bash

for model1 in ens_ml #ens_all22
do
	for model2 in ens_dy22 
	do
	sed -i "6s/^.*.$/mymodel1 = \"${model1}\"/g" diff.ncl
	sed -i "14s/^.*.$/mymodel2 = \"${model2}\"/g" diff.ncl
	ncl diff.ncl
	done
done

for ii in `ls *.eps`
do
	convert -density 800 -trim $ii ${ii/eps/png}
	echo $ii
done

rm -rf *.eps
