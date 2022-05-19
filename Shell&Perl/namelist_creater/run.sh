#!/bin/sh

for ii in `seq 3000`:
do
    perl namelist_creater.pl > namelist.input.$ii
done
