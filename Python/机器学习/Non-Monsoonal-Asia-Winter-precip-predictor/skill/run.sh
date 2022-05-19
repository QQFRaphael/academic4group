#!/bin/bash

for model in GBDT LightGBM CatBoost XGBoost LR
do
	cd ../${model}
	ncl ${model}.ncl
	cd ../skill
	sed -i "7s/^.*.$/mymodel = \"${model}\"/g" compare.ncl
	ncl compare.ncl
done

ncl model.ncl
ncl ens-ml.ncl

for ii in `ls *.eps`
do
	convert -density 800 -trim $ii ${ii/eps/png}
	echo $ii
done

rm -rf *.eps
