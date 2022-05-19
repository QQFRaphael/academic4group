#!/bin/bash

for ii in `ls ../data/`
do
	sed -i "4s/^.*.$/case <- '$ii'/g" 002.load2proj.R
	Rscript 002.load2proj.R
	echo "=================================$ii================================="
done