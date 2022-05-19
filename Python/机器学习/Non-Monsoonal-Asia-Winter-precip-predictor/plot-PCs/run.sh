#!/bin/bash

for model in XGBoost GBDT LightGBM CatBoost LR
do
	sed -i "6s/^.*.$/mymodel = \"${model}\"/g" plot-pcs.ncl
	ncl plot-pcs.ncl
done

for ii in `ls *.eps`
do
	convert -density 800 -trim $ii ${ii/eps/png}
	echo $ii
done

rm -rf *.eps