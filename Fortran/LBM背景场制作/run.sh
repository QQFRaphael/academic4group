#!/bin/sh

if [[ ! -e "ncep.nc" ]]; then
	ncl preprocess.ncl
fi

gfortran -I/usr/include -L/usr/lib/x86_64-linux-gnu -l netcdff  create_lbm_bs.f90 

./a.out

rm -rf a.out
