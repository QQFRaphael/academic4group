#!/bin/bash

for ii in `ls ../data/`
do
	sed -i "6s/^.*.$/case <- '$ii'/g" vif.R
	Rscript vif.R
	echo "=================================$ii================================="
done